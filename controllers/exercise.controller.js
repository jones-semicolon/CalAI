const groq = require("../config/groq");

const API_MODEL = "openai/gpt-oss-120b";
const RESPONSE_TYPE = "json_object";

exports.log_exercise = async (req, res) => {
  try {
    const { weight_kg, exercise_type, intensity, duration_mins, description } =
      req.body;

    if (
      !weight_kg &&
      ((exercise_type, intensity, duration_mins) || description)
    ) {
      return res.status(400).json({
        success: false,
        error: "Missing required fields.",
      });
    }

    const PROMPT = `You are a calories-burned calculator.

You will receive INPUT JSON with either:
A) structured fields, or
B) a natural language "description".

INPUT JSON:
{
  "weight_kg": number (required),
  "exercise_type": "string" (optional),
  "intensity": "low|medium|high" (optional),
  "duration_mins": number (optional),
  "description": "string" (optional)
}

RULES:
- Output MUST be valid JSON only. No markdown. No extra text.
- If "description" exists, extract exercise_type, duration, and intensity from it.
- If BOTH structured fields and description exist, structured fields override description.
- duration is REQUIRED. If missing, return INVALID_INPUT.
- intensity must be one of: low, medium, high. If missing, infer from description.
- weight_kg is required. 

DURATION PARSING:
- If description uses hours, convert to minutes:
  minutes = hours * 60
- Examples:
  "5 hours" => 300
  "1.5 hours" => 90
  "45 mins" => 45

INTENSITY INFERENCE (from description keywords):
- high if text includes: "exhausted", "sprinting", "all out", "training to failure", "breathing heavily"
- medium if text includes: "sweaty", "tired", "jogging", "moderate pace", "many reps"
- low if text includes: "easy", "light", "casual", "chill", "not sweating"
- If still unknown, default to "medium" and add warning "INTENSITY_INFERRED_DEFAULT_MEDIUM"

EXERCISE NORMALIZATION:
- lowercase + trim
- synonyms:
  "weights","lifting","gym" -> "weightlifting"
  "running","jogging","sprint" -> "run"
  "walk","walking" -> "walking"
  "hike","hiking","outdoor hiking" -> "hiking"
  "bike","biking" -> "cycling"

MET TABLE:
- weightlifting: low=3.0, medium=5.0, high=6.0
- run: low=3.3, medium=9.8, high=23.0
- walking: low=2.5, medium=3.5, high=5.0
- hiking: low=5.0, medium=6.5, high=8.0
- cycling: low=4.0, medium=6.8, high=10.0
- swimming: low=5.0, medium=7.0, high=9.8
- jump_rope: low=8.0, medium=10.0, high=12.3
- yoga: low=2.0, medium=3.0, high=4.0

UNKNOWN EXERCISE fallback:
- MET: low=3.0, medium=5.0, high=8.0
- add warning: "UNKNOWN_EXERCISE_TYPE"
- confidence <= 0.6

CALCULATION:
calories_burned = MET * 3.5 * weight_kg / 200 * duration_mins
Round calories_burned to nearest integer.

OUTPUT JSON:
{
  "ok": true,
  "parsed_from": "structured|description",
  "exercise_type": "string",
  "intensity": "low|medium|high",
  "duration_mins": number,
  "weight_kg": number,
  "met_used": number,
  "calories_burned": number,
  "confidence": number,
  "warnings": []
}

ERROR JSON:
{
  "ok": false,
  "error": {
    "code": "INVALID_INPUT",
    "message": "string",
    "fields": ["string"]
  }
}

Now calculate using this INPUT:
${JSON.stringify({ exercise_type, intensity, duration_mins, weight_kg, description })}`;

    const completion = await groq.chat.completions.create({
      messages: [
        {
          role: "system",
          content:
            "Return ONLY valid JSON. Never include markdown, comments, or extra text.",
        },
        { role: "user", content: PROMPT },
      ],
      model: API_MODEL,
      response_format: { type: RESPONSE_TYPE },
    });

    const messageContent = completion.choices?.[0]?.message?.content;

    if (!messageContent) {
      return res.status(500).json({
        success: false,
        error: "No response content returned by Groq.",
      });
    }

    const calculatedStats = JSON.parse(messageContent);

    res.json({
      success: true,
      data: calculatedStats,
      usage: completion.usage,
    });
  } catch (err) {
    console.error("Error calculating calories:", err.message);

    res.status(500).json({
      success: false,
      error: "Internal server error during exercise calorie calculation.",
    });
  }
};
