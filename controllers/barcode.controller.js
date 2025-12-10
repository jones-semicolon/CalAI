// controllers/barcode.controller.js
const fetch = require("node-fetch");
const { convertToCalAI } = require("../utils/openfoodfacts");

exports.scanBarcode = async (req, res) => {
  try {
    const { barcode } = req.body;

    if (!barcode) {
      return res.status(400).json({ error: "barcode is required" });
    }

    const apiUrl = `https://world.openfoodfacts.net/api/v2/product/${barcode}?fields=product_name,ingredients,nutriscore_grade,nutriscore_score,nutriments`;
    const response = await fetch(apiUrl);
    const data = await response.json();

    if (!data || data.status !== 1) {
      return res.status(404).json({ error: "Product not found" });
    }

    const product = data.product;
    const formatted = convertToCalAI(product);

    res.json({
      success: true,
      barcode,
      data: formatted,
    });
  } catch (err) {
    console.error("Barcode endpoint error:", err);
    res.status(500).json({ error: "Internal server error" });
  }
};
