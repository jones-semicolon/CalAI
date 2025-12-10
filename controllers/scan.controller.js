const groq = require("../config/groq");
const { SYSTEM_PROMPT } = require("../config/prompts/foodScannerPrompt");

exports.scanFood = async (req, res) => {
  try {
    const { image_url } = req.body;

    if (!image_url) {
      return res.status(400).json({ error: "image_url is required" });
    }

    const completion = await groq.chat.completions.create({
      messages: [
        {
          role: "system",
          content: SYSTEM_PROMPT || "You are an assistant.",
        },
        {
          role: "user",
          content: [{ type: "image_url", image_url: { url: image_url } }],
        },
      ],
      model: "meta-llama/llama-4-maverick-17b-128e-instruct",
      response_format: { type: "json_object" },
    });

    const message = completion.choices?.[0]?.message?.content || "{}";

    res.json({
      success: true,
      data: JSON.parse(message),
      usage: completion.usage,
    });
  } catch (err) {
    console.error("Scan Error:", err);
    res.status(500).json({ error: "Internal server error" });
  }
};
