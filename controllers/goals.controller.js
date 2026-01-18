// controllers/goals.controller.js
const groq = require("../config/groq");

/**
 * @property {number} calories - Daily caloric intake recommendation.
 * @property {number} protein_g - Daily protein intake in grams.
 * @property {number} carbs_g - Daily carbohydrate intake in grams.
 * @property {number} fat_g - Daily fat intake in grams.
 * @property {object} micronutrients - Recommended micronutrient details.
 * @property {number} micronutrients.sugar_g - Daily sugar intake in grams.
 * @property {number} micronutrients.sodium_mg - Daily sodium intake in milligrams.
 * @property {number} micronutrients.fiber_g - Daily fiber intake in grams.
 */

/**
 * Calculates daily caloric and macronutrient goals based on user metrics
 * by calling the Groq Chat Completions API with a specific JSON output requirement.
 *
 * @param {number} req.body.age - User's age.
 * @param {number} req.body.weight - User's weight in kg.
 * @param {number} req.body.height - User's height in cm.
 * @param {string} req.body.activity_level - User's activity level (e.g., 'sedentary', 'moderate').
 * @param {string} req.body.gender - User's gender.
 * @param {string} req.body.goal - User's fitness goal (e.g., 'maintain', 'lose weight', 'gain muscle').
 * @returns {Promise<void>} Sends a JSON response containing the calculated goals or an error.
 */

const API_MODEL = "openai/gpt-oss-120b";
const RESPONSE_TYPE = "json_object";

exports.calculateGoals = async (req, res) => {
  try {
    // 1. Destructure and validate required user input fields.
    const { age, weight, height, activity_level, gender, goal } = req.query;

    if (!age || !weight || !height || !activity_level || !gender || !goal) {
      return res.status(400).json({
        success: false,
        error:
          "Missing required fields: age, weight, height, activity_level, gender, and goal are mandatory.",
      });
    }

    // 2. Construct the detailed prompt for the LLM.
    const PROMPT = `Calculate daily caloric and macronutrient needs for a
       ${age}-year-old ${gender} weighing ${weight} kg,
       ${height} cm tall, with a ${activity_level} activity level, aiming to ${goal}.
       Provide results ONLY in JSON: calories, nutrients: { protein_g, carbs_g, fat_g, micronutrients: {sugar_g, sodium_mg, fiber_g}}`;

    // 3. Call the Groq Chat Completions API.
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
    // Log the detailed error for server-side debugging.
    // The error might be from the API call itself or from JSON.parse if the LLM outputted bad JSON.
    console.error(
      "Error calculating nutritional goals:",
      err.message,
      err.stack,
    );

    // Send a generic 500 status error to the client.
    res.status(500).json({
      success: false,
      error:
        "Internal server error during goal calculation. Check server logs for details.",
    });
  }
};
