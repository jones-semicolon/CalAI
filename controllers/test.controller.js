const groq = require("../config/groq");

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
