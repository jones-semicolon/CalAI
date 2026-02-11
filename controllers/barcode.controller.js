// controllers/barcode.controller.js
const fetch = require("node-fetch");
const { convertToCalAI } = require("../utils/openfoodfacts");

/**
 * Handles the POST request to scan a barcode, fetch product data from Open Food Facts,
 * and return the result formatted for CalAI.
 *
 * @param {number} req.body.barcode - Barcode of the product.
 * @returns {Promise<void>} Sends a JSON response containing the data based on the barcode provided or an error.
 */

// Define API constants for better readability and maintainability.
const OPENFOODFACTS_BASE_URL = "https://world.openfoodfacts.net/api/v2/product";
const PRODUCT_FIELDS = [
  "product_name",
  "ingredients",
  "nutriscore_grade",
  "nutriscore_score",
  "nutriments",
  "image_url",
].join(","); // Join the array into the required comma-separated string

exports.scanBarcode = async (req, res) => {
  // Use destructuring for cleaner access to input
  const { barcode } = req.query;

  if (!barcode) {
    // Use success: false for non-200 responses to be explicit
    return res
      .status(400)
      .json({ success: false, error: "Barcode is required in request body." });
  }

  try {
    // Construct the URL using constants, making the fields list manageable
    const apiUrl = `${OPENFOODFACTS_BASE_URL}/${barcode}`;

    // 1. Fetch data and check HTTP response status
    const response = await fetch(apiUrl);

    if (!response.ok) {
      // Throw an error for non-200 responses (e.g., network failure, server error)
      throw new Error(
        `Open Food Facts API failed with status ${response.status}: ${response.statusText}`,
      );
    }

    // 2. Parse JSON and use destructuring for API-specific data
    const data = await response.json();
    const { status, product } = data;

    // 3. Data validation: Check the Open Food Facts API-specific status (1 = found)
    if (status !== 1 || !product) {
      // status: 0 means product not found
      return res.status(404).json({
        success: false,
        error: `Product with barcode ${barcode} not found.`,
      });
    }

    // 4. Process and respond
    const formattedData = convertToCalAI(product);

    res.json({
      success: true,
      barcode,
      data: formattedData,
    });
  } catch (err) {
    // 5. Centralized Error Handling
    console.error(`[Barcode Scan Error] Barcode ${barcode}:`, err.message);

    // Use a 503 if the external API is likely down, otherwise use 500
    const statusCode = err.message.includes("API failed") ? 503 : 500;

    res.status(statusCode).json({
      success: false,
      error: "Internal server error during product lookup.",
      details: err.message,
    });
  }
};
