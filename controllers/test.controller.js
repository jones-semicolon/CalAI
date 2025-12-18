const groq = require("../config/groq");

const API_MODEL = "openai/gpt-oss-120b";
const RESPONSE_TYPE = "json_object";
const age = 24;
const gender = "male";
const weight = 70;
const height = 175;
const activity_level = "moderate";
const goal = "maintain";

const PROMPT = `Calculate daily caloric and macronutrient needs for a
   ${age}-year-old ${gender} weighing ${weight} kg,
   ${height} cm tall, with a ${activity_level} activity level, aiming to ${goal}.
   Provide results ONLY in JSON: calories, nutrients: { protein_g, carbs_g, fat_g, micronutrients: {sugar_g, sodium_mg, fiber_g}}`;

exports.test = async (req, res) => {
  try {
    const completion = await groq.chat.completions.create({
      messages: [{ role: "system", content: "Hello" }],
      model: "meta-llama/llama-4-maverick-17b-128e-instruct",
    });

    res.json({ success: true, completion });
  } catch (err) {
    console.error("Test Error:", err);
    res.status(500).json({ error: "Internal server error" });
  }
};

exports.goals = async (req, res) => {
  try {
    const completion = await groq.chat.completions.create({
      messages: [
        // System instruction guides the model's persona and ensures JSON structure.
        {
          role: "system",
          content:
            "You are a nutrition expert that provides concise, structured data.",
        },
        // User prompt contains the specific calculation request.
        { role: "user", content: PROMPT },
      ],
      // The model specified in the original request.
      model: API_MODEL,
      // Enforce JSON output for reliable parsing.
      response_format: { type: RESPONSE_TYPE },
    });

    // 4. Extract the response content from the completion object.
    const messageContent = completion.choices?.[0]?.message?.content;

    if (!messageContent) {
      // Handle case where the API returns a completion object but no actual content.
      console.error(
        "API returned no content in completion message for goal calculation.",
      );
      return res.status(500).json({
        success: false,
        error:
          "Failed to receive a valid response from the calculation service.",
      });
    }

    // 5. Parse the JSON response from the LLM.
    const calculatedGoals = JSON.parse(messageContent);

    // 6. Send a successful response back to the client.
    /** @type {NutritionalGoals} */
    res.json({
      success: true,
      data: calculatedGoals,
      // Include usage metadata for potential logging or tracking.
      usage: completion.usage,
    });
  } catch (err) {
    console.error("Goals Error:", err);
    res.status(500).json({ error: "Internal server error" });
  }
};
