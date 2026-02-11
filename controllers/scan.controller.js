// controllers/scan.controller.js

/**
 * Food Scanner Controller
 *
 * This controller handles receiving an image URL, sending it to the Groq API
 * for multimodal processing, and returning the structured JSON result.
 */
const groq = require("../config/groq");
const { SYSTEM_PROMPT } = require("../config/prompts/foodScannerPrompt");

const API_MODEL = "meta-llama/llama-4-maverick-17b-128e-instruct"; 
const ERROR_MESSAGE_INTERNAL = "Internal server error during food scanning.";

exports.scanFood = async (req, res) => {
  try {
    // 1. Validate the file exists in memory
    if (!req.file) {
      return res.status(400).json({ error: "No image file provided" });
    }

    // ✅ Convert Buffer to Base64 Data URL
    // This allows you to pass the image data without saving it to a disk
    const base64Image = req.file.buffer.toString('base64');
    const dataUrl = `data:${req.file.mimetype};base64,${base64Image}`;

    // 2. Call Groq API
    const completion = await groq.chat.completions.create({
      model: API_MODEL,
      messages: [
        {
          role: "user",
          content: [
            { type: "text", text: SYSTEM_PROMPT },
            { 
              type: "image_url", 
              image_url: { url: dataUrl } // ✅ Pass the Data URL here
            },
          ],
        },
      ],
      response_format: { type: "json_object" }, 
      temperature: 0.1,
    });

    // 3. Process Response
    const responseContent = completion.choices?.[0]?.message?.content;

    if (!responseContent) {
      throw new Error("API returned empty content");
    }

    // 4. Parse JSON
    let parsedData = {};
    try {
      parsedData = JSON.parse(responseContent);
    } catch (parseError) {
      console.error("JSON Parse Fail:", responseContent);
      return res.status(500).json({
        success: false,
        error: "AI generation failed to produce valid JSON.",
      });
    }

    // 5. Success
    res.json({
      success: true,
      data: parsedData,
      usage: completion.usage,
    });

  } catch (err) {
    console.error("Food Scan Error:", err);
    res.status(500).json({
      success: false,
      error: ERROR_MESSAGE_INTERNAL,
      details: err.message,
    });
  }
};