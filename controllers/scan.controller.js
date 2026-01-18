// controllers/scan.controller.js

/**
 * Food Scanner Controller
 *
 * This controller handles receiving an image URL, sending it to the Groq API
 * for multimodal processing, and returning the structured JSON result.
 */
const groq = require("../config/groq");
const { SYSTEM_PROMPT } = require("../config/prompts/foodScannerPrompt");

// Constants for API configuration
const API_MODEL = "meta-llama/llama-4-maverick-17b-128e-instruct";
const RESPONSE_TYPE = "json_object";
const ERROR_MESSAGE_MISSING_URL = "image_url is required in the request body.";
const ERROR_MESSAGE_INTERNAL = "Internal server error during food scanning.";
const FALLBACK_SYSTEM_PROMPT = "You are an assistant that analyzes images.";

/**
 * Scans a food image provided via URL using the Groq Vision model.
 * @param {number} req.body.image_url - base64 Image URL of the food
 * @returns {Promise<void>} Sends a JSON response containing the calculated goals or an error.
 */
exports.scanFood = async (req, res) => {
  const { image_url } = req.query;

  // 1. Input Validation
  if (!image_url) {
    return res.status(400).json({
      success: false,
      error: ERROR_MESSAGE_MISSING_URL,
    });
  }

  try {
    // 2. Prepare the API Call
    const systemInstruction = SYSTEM_PROMPT || FALLBACK_SYSTEM_PROMPT;

    const completion = await groq.chat.completions.create({
      model: API_MODEL,
      messages: [
        {
          role: "system",
          content: systemInstruction,
        },
        {
          role: "user",
          content: [
            {
              type: "image_url",
              image_url: { url: image_url },
            },
          ],
        },
      ],
      response_format: { type: RESPONSE_TYPE },
    });

    // 3. Process the API Response
    const responseContent = completion.choices?.[0]?.message?.content;

    if (!responseContent) {
      // Handle case where API returns a completion object but no message content
      return res.status(500).json({
        success: false,
        error: "API returned an empty response.",
      });
    }

    // Attempt to parse the expected JSON output
    let parsedData = {};
    try {
      parsedData = JSON.parse(responseContent);
    } catch (parseError) {
      console.error("JSON Parse Error:", parseError);
      return res.status(500).json({
        success: false,
        error: "Failed to parse API response content as JSON.",
        rawResponse: responseContent,
      });
    }

    // 4. Send Success Response
    res.json({
      success: true,
      data: parsedData,
      usage: completion.usage,
    });
  } catch (err) {
    // 5. Global Error Handling
    console.error("Food Scan Controller Error:", err.message);

    // Check if the error is an API error (e.g., bad request, rate limit)
    const status = err.status || 500;

    res.status(status).json({
      success: false,
      error: ERROR_MESSAGE_INTERNAL,
      details: err.message,
    });
  }
};
