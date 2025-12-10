const groq = require("../config/groq");

exports.calculateGoals = async (req, res) => {
  try {
    const { age, weight, height, activity_level, gender, goal } = req.body;

    if (!age || !weight || !height || !activity_level || !gender || !goal) {
      return res.status(400).json({ error: "Missing required fields" });
    }

    const completion = await groq.chat.completions.create({
      messages: [
        { role: "system", content: "You are a nutrition expert." },
        {
          role: "user",
          content: `Calculate daily caloric and macronutrient needs for a ${age}-year-old ${gender} weighing ${weight} kg, ${height} cm tall, with a ${activity_level} activity level, aiming to ${goal}. Provide results ONLY in JSON: calories, protein_g, carbs_g, fat_g, micronutrients: {sugar_g, sodium_mg, fiber_g}`,
        },
      ],
      model: "openai/gpt-oss-120b",
      response_format: { type: "json_object" },
    });

    const message = completion.choices?.[0]?.message?.content || "{}";

    res.json({
      success: true,
      data: JSON.parse(message),
      usage: completion.usage,
    });
  } catch (err) {
    console.error("Goals Error:", err);
    res.status(500).json({ error: "Internal server error" });
  }
};
