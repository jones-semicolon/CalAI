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

//Barcode endpoint
app.post("/barcode", async (req, res) => {
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
        nutritional_score: product.nutriscore_score || 0,
      },

      confidence_score: 1.0,

      notes: "Converted from OpenFoodFacts data"
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
app.post("/image", async (req, res) => {
  try {
    const { image_url } = req.body;

    if (!image_url) {
      return res.status(400).json({ error: "image_url is required" });
    }

    // console.log("Received image URL:", image_url);

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
