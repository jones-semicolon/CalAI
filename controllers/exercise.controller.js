const groq = require("../config/groq");

// UPDATED: Use the latest Llama 3.3 model
const API_MODEL = "llama-3.3-70b-versatile";

// Move constant data to code for reliability

// FIXED: MET_TABLE updated with values from Omics Online Table 3
// Source: https://www.omicsonline.org/articles-images/2157-7595-6-220-t003.html
const MET_TABLE = {
  // Source: "resistance training" (3.5), "calisthenics moderate" (3.8), "calisthenics vigorous" (8.0)
  weightlifting: { low: 3.5, medium: 3.8, high: 8.0 },

  // Source: "jogging, general" (7.0), "running jogging, in place" (8.0)
  run: { low: 7.0, medium: 8.0, high: 9.0 },

  // Source: "walking 1.7mph" (2.3), "walking 2.5mph" (2.9), "walking 3.4mph" (3.6)
  walking: { low: 2.3, medium: 2.9, high: 3.6 },

  // Source: "bicycling 50W" (3.0), "bicycling <10mph" (4.0), "bicycling 100W" (5.5)
  cycling: { low: 3.0, medium: 4.0, high: 5.5 },

  // Source: "water aerobics" (5.3). Table lacks "swimming laps", using aerobics as proxy.
  swimming: { low: 5.3, medium: 5.3, high: 7.0 },

  // Source: "rope jumping" (10.0)
  jump_rope: { low: 8.0, medium: 10.0, high: 12.0 },

  // Source: "yoga, Hatha" (3.0), "Pilates" (3.8)
  yoga: { low: 2.0, medium: 3.0, high: 3.8 },

  // Not explicitly in Table 3, keeping standard fallback or aligning with Walking High
  hiking: { low: 4.0, medium: 5.0, high: 6.0 },

  // Fallback for unknown activities
  unknown: { low: 3.0, medium: 4.5, high: 6.0 },
};

exports.log_exercise = async (req, res) => {
  try {
    // 1. Switch to req.body for POST requests
    const { weight_kg, exercise_type, intensity, duration_mins, description } =
      req.body;

    // 2. Fixed Validation Logic
    // We need Weight + (Structure OR Description)
    const hasStructure = exercise_type && duration_mins;
    const hasDescription = !!description;

    if (!weight_kg || (!hasStructure && !hasDescription)) {
      return res.status(400).json({
        success: false,
        error:
          "Missing required fields. Provide weight_kg AND (description OR exercise_type + duration_mins).",
      });
    }

    // 3. Simplified Prompt: Extraction Only (No Math)
    const PROMPT = `
    You are an exercise parser. Extract data from the user input.
    
    INPUT:
    ${JSON.stringify({ exercise_type, intensity, duration_mins, description })}

    RULES:
    - If specific fields are provided, use them. 
    - If a description is provided, extract missing fields from it.
    - Normalize "exercise_type" to one of: [weightlifting, run, walking, hiking, cycling, swimming, jump_rope, yoga, etc.].
    - If the exercise doesn't fit those, use "unknown".
    - Normalize "intensity" to: [low, medium, high]. Default to "medium".
    - Convert all durations to integers in MINUTES.
    
    OUTPUT JSON format:
    {
      "exercise_type": "string",
      "intensity": "low|medium|high",
      "duration_mins": number, 
      "confidence": number
    }
    `;

    const completion = await groq.chat.completions.create({
      messages: [
        { role: "system", content: "Return ONLY valid JSON. No markdown." },
        { role: "user", content: PROMPT },
      ],
      model: API_MODEL,
      response_format: { type: "json_object" },
    });

    const content = completion.choices?.[0]?.message?.content;
    if (!content) throw new Error("Empty response from LLM");

    // 4. Safe Parsing
    let extracted;
    try {
      extracted = JSON.parse(content);
    } catch (e) {
      throw new Error("Failed to parse LLM JSON response");
    }

    // 5. Perform Math in JavaScript (Deterministic & Accurate)
    const finalType = extracted.exercise_type || "unknown";
    const finalIntensity = extracted.intensity || "medium";
    const finalDuration = extracted.duration_mins || 0;

    // Lookup MET
    const exerciseMetData = MET_TABLE[finalType] || MET_TABLE.unknown;
    const metValue = exerciseMetData[finalIntensity];

    // Formula: MET * 3.5 * weight / 200 * duration
    const calories = Math.round(
      ((metValue * 3.5 * Number(weight_kg)) / 200) * finalDuration,
    );

    res.json({
      success: true,
      data: {
        parsed_input: extracted,
        calculation: {
          weight_kg: Number(weight_kg),
          met_used: metValue,
          formula: "(MET * 3.5 * weight / 200) * mins",
          calories_burned: calories,
        },
      },
      usage: completion.usage,
    });
  } catch (err) {
    console.error("Error calculating calories:", err);
    res.status(500).json({
      success: false,
      error: "Internal server error.",
    });
  }
};
