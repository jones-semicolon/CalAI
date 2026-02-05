// server/controllers/exerciseController.js
const groq = require("../config/groq");

// Use a reliable, fast model
const API_MODEL = "llama-3.3-70b-versatile";

// ==========================================
// 1. MET TABLE (Metabolic Equivalent of Task)
// ==========================================
// Source: Compendium of Physical Activities
const MET_TABLE = {
  weightlifting: { low: 3.5, medium: 3.8, high: 6.0 }, // Adjusted High based on intense powerlifting
  run: { low: 6.0, medium: 8.0, high: 11.5 },
  walking: { low: 2.5, medium: 3.5, high: 4.5 },
  hiking: { low: 5.3, medium: 6.0, high: 7.5 },
  cycling: { low: 4.0, medium: 8.0, high: 10.0 },
  swimming: { low: 6.0, medium: 8.0, high: 10.0 },
  jump_rope: { low: 8.8, medium: 11.0, high: 12.0 },
  yoga: { low: 2.0, medium: 3.0, high: 4.0 },
  sports: { low: 4.0, medium: 7.0, high: 10.0 }, // General sports (basketball, soccer)
  unknown: { low: 3.0, medium: 5.0, high: 7.0 }, // Fallback
};

exports.log_exercise = async (req, res) => {
  try {
    const { weight_kg, exercise_type, intensity, duration_mins, description } =
      req.body;

    // ==========================================
    // 2. INPUT VALIDATION
    // ==========================================

    // Hard Fail: No weight provided
    if (!weight_kg) {
      return res.status(400).json({
        success: false,
        error: "Weight (kg) is required to calculate calories.",
      });
    }

    // Hard Fail: No context provided (neither structured input nor description)
    if (!description && (!exercise_type || !duration_mins)) {
      return res.status(400).json({
        success: false,
        error:
          "Please provide either a description (e.g., 'ran 30 mins') OR specific exercise details.",
      });
    }

    // ==========================================
    // 3. AI PARSING (Strict Mode)
    // ==========================================
    const PROMPT = `
    You are a strict exercise data parser. Analyze the user's input.
    
    USER INPUT:
    ${JSON.stringify({ exercise_type, intensity, duration_mins, description })}

    RULES:
    0. **SUBJECT CHECK**: ONLY extract actions performed by the USER ("I", "me", or implied "ran 5 miles"). IGNORE actions performed by others ("they", "he", "she", "my friend").
       - Example: "They ran 30 mins" -> exercise_type: null
       - Example: "I walked while they ran" -> exercise_type: "walking"
    1. Detect the "exercise_type". Normalize to: [weightlifting, run, walking, hiking, cycling, swimming, jump_rope, yoga, sports].
    2. If the input is nonsense (e.g., "hi", "test", "foo"), or non-physical (e.g., "sleeping", "watching tv"), set "exercise_type": null and "confidence": 0.
   3. Detect "duration_mins". ONLY extract if the user explicitly states a time (e.g. "10 mins", "half hour").
       - IF NO TIME IS STATED: Set "duration_mins": null. 
       - DO NOT GUESS or hallucinate a default time.
    4. Detect "intensity" (low, medium, high). Default to "medium".
    5. Set "confidence" score (0 to 1). 1 = Clear data, 0 = Garbage input.

    OUTPUT JSON ONLY:
    {
      "exercise_type": "string" | null,
      "intensity": "low" | "medium" | "high",
      "duration_mins": number,
      "confidence": number
    }
    `;

    const completion = await groq.chat.completions.create({
      messages: [
        { role: "system", content: "You output ONLY valid JSON. No Markdown." },
        { role: "user", content: PROMPT },
      ],
      model: API_MODEL,
      response_format: { type: "json_object" },
    });

    const content = completion.choices?.[0]?.message?.content;
    if (!content) throw new Error("Empty response from AI");

    let extracted;
    try {
      extracted = JSON.parse(content);
    } catch (e) {
      throw new Error("AI response was not valid JSON");
    }

    // ==========================================
    // 4. LOGIC GUARDRAILS
    // ==========================================

    // Guardrail 1: Reject garbage input (e.g. "hi")
    if (!extracted.exercise_type || extracted.confidence < 0.5) {
      return res.status(422).json({
        success: false,
        error:
          "Could not identify a valid exercise. Try: 'I ran for 20 minutes'.",
        debug_parsed: extracted, // Helpful for debugging why it failed
      });
    }

    // Guardrail 2: Ensure valid duration
    if (!extracted.duration_mins || extracted.duration_mins <= 0) {
      return res.status(422).json({
        success: false,
        error:
          "Could not determine duration. Please specify how long you exercised.",
      });
    }

    // ==========================================
    // 5. MATH CALCULATION
    // ==========================================

    // Normalize values
    const finalType = MET_TABLE[extracted.exercise_type]
      ? extracted.exercise_type
      : "unknown";
    const finalIntensity = extracted.intensity || "medium";
    const finalDuration = extracted.duration_mins;

    // Get MET value
    const metValue = MET_TABLE[finalType][finalIntensity];

    // Formula: Calories = (MET * 3.5 * Weight(kg) / 200) * Duration(mins)
    const caloriesBurned = Math.round(
      ((metValue * 3.5 * Number(weight_kg)) / 200) * finalDuration,
    );

    // ==========================================
    // 6. SUCCESS RESPONSE
    // ==========================================
    res.json({
      success: true,
      data: {
        exercise_type: finalType,
        intensity: finalIntensity,
        duration_mins: finalDuration,
        calories_burned: caloriesBurned,
        meta: {
          weight_used: Number(weight_kg),
          met_value: metValue,
          confidence: extracted.confidence,
        },
      },
    });
  } catch (err) {
    console.error("Log Exercise Error:", err);
    res.status(500).json({
      success: false,
      error: "Internal server error processing exercise.",
    });
  }
};
