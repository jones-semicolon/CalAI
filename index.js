const express = require("express");
const cors = require("cors");
const { Groq } = require("groq-sdk");
require("dotenv").config();
const nodeFetch = fetch;

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

app.post("/calculate_goals", async (req, res) => {
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
          content: `Calculate daily caloric and macronutrient needs for a ${age}-year-old ${gender} weighing ${weight} kg, ${height} cm tall, with a ${activity_level} activity level, aiming to ${goal}. Provide results in a strictly JSON format with calories, protein_g, carbs_g, and fat_g.`,
        },
      ],
      model: "meta-llama/llama-4-maverick-17b-128e-instruct",
      temperature: 0.7,
      max_completion_tokens: 500,
      top_p: 1,
      stream: false,
    });
    const message = completion.choices?.[0]?.message?.content || "";
    console.log("Calculate goals response message:", message);
    let goals;
    try {
      goals = JSON.parse(message);
    } catch (parseErr) {
      return res.status(500).json({ error: "Failed to parse goals from model response", details: parseErr.message });
    }
    res.json({
      success: true,
      model: completion.model,
      goals,
      usage: completion.usage,
    });
  } catch (err) {
    console.error("Calculate goals endpoint error:", err);
    res.status(500).json({ error: "Internal server error" });
  }
});

//Barcode endpoint
app.post("/scan_barcode", async (req, res) => {
  try {
    const { barcode } = req.body;

    if (!barcode) {
      return res.status(400).json({ error: "barcode is required" });
    }

    const apiUrl = `https://world.openfoodfacts.net/api/v2/product/${barcode}?fields=product_name,ingredients,nutriscore_grade,nutriscore_score,nutriments`;

    console.log("Fetching:", apiUrl);

    const response = await fetch(apiUrl);
    const data = await response.json();

    if (!data || data.status !== 1) {
      return res.status(404).json({ error: "Product not found" });
    }

    const product = data.product;

    // ---- CONVERSION TO CALAI FORMAT ----
    const calaiData = {
      meal_name: product.product_name || "Unknown product",

      ingredients: (product.ingredients || []).map((ing) => ({
        name: ing.text,
        estimated_weight_grams: ing.percent_estimate
          ? Number(ing.percent_estimate.toFixed(2))
          : 0
      })),

      nutrition: {
        calories_kcal: product.nutriments["energy-kcal"] || 0,
        protein_g: product.nutriments.proteins || 0,
        carbs_g: product.nutriments.carbohydrates || 0,
        fat_g: product.nutriments.fat || 0,
        fiber_g: product.nutriments.fiber || 0,
        sugar_g: product.nutriments.sugars || 0,
        health_score: product.nutriscore_grade || 0,
      },

      confidence_score: 1.0,

      notes: "From OpenFoodFacts data"
    };
    // -------------------------------------

    res.json({
      success: true,
      barcode,
      data: calaiData
    });

  } catch (err) {
    console.error("Barcode endpoint error:", err);
    res.status(500).json({ error: "Internal server error" });
  }
});

// Chat endpoint
app.post("/scan_food", async (req, res) => {
  try {
    const { image_url } = req.body;

    if (!image_url) {
      return res.status(400).json({ error: "image_url is required" });
    }

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
