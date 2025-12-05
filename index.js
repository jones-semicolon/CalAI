const express = require("express");
const cors = require("cors");
const { Groq } = require("groq-sdk");
require("dotenv").config();

const app = express();
const groq = new Groq({
  apiKey: process.env.GROQ_API_KEY,
});
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json({ limit: "50mb" }));
app.use(express.urlencoded({ limit: "50mb", extended: true }));

// Test endpoint
app.get("/test", async (req, res) => {
  try {
    const completion = await groq.chat.completions.create({
      messages: [{ role: "system", content: "Hello" }],
      model: "meta-llama/llama-4-maverick-17b-128e-instruct",
    });
    console.log("Test completion:", completion);
    res.json({ success: true, completion });
  } catch (err) {
    console.error("Test endpoint error:", err);
    res.status(500).json({ error: "Internal server error" });
  }
});

// Chat endpoint
app.post("/chat", async (req, res) => {
  try {
    const { image_url } = req.body;

    if (!image_url) {
      return res.status(400).json({ error: "image_url is required" });
    }

    console.log("Received image URL:", image_url);

    const completion = await groq.chat.completions.create({
      messages: [
        {
          role: "system",
          content: process.env.CONTENT || "You are an assistant.",
        },
        {
          role: "user",
          content: [{ type: "image_url", image_url: { url: image_url } }],
        },
      ],
      model: "meta-llama/llama-4-maverick-17b-128e-instruct",
      temperature: 1,
      max_completion_tokens: 1024,
      top_p: 1,
      stream: false,
    });

    const message = completion.choices?.[0]?.message?.content || "";

    res.json({
      success: true,
      model: completion.model,
      content: message,
      usage: completion.usage,
    });
  } catch (err) {
    console.error("Chat endpoint error:", err);
    res.status(500).json({ error: "Internal server error" });
  }
});

// Start server
app.listen(PORT, () => {
  console.log(`🚀 Server running at http://localhost:${PORT}`);
});
