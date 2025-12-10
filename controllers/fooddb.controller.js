// controllers/fooddb.controller.js
const fetch = require("node-fetch");
const { foodtoCalAI } = require("../utils/fooddatabase");

const FOODCENTRAL_BASE_URL = "https://api.nal.usda.gov/fdc/v1/foods/";
const FOODCENTRAL_API_KEY = process.env.FOODCENTRAL_API_KEY;

const NUTRIENT_IDS = {
  carbs_g: 1005,
  calories_kcal: 1008,
  sugar_g: 2000,
  sodium_mg: 1093,
  protein_g: 1003,
  fat_g: 1004,
};

/**
 * Helper function to handle the fetch request to the FoodData Central API.
 * This function now returns the data or throws a detailed error object.
 * * @param {string} url The complete URL for the FDC API call.
 * @returns {Promise<object>} The JSON data from the FDC API.
 * @throws {Error} If the fetch operation fails or returns a non-200 status.
 */
const executeFetch = async (url) => {
  if (!FOODCENTRAL_API_KEY) {
    const error = new Error(
      "API key is missing. Please set FOODCENTRAL_API_KEY environment variable.",
    );
    error.status = 500;
    throw error;
  }

  try {
    const response = await fetch(url);

    // Check for non-successful HTTP status codes
    if (!response.ok) {
      const errorText = await response.text();
      console.error(`FDC API error: ${response.status} - ${errorText}`);
      const error = new Error(
        `Failed to fetch data from FoodData Central. Status: ${response.status}`,
      );
      error.details = errorText.substring(0, 200);
      error.status = response.status;
      throw error;
    }

    // Return raw data for the caller to process
    return await response.json();
  } catch (error) {
    // If it's not a custom error (e.g., fetch error), wrap it as 500
    if (!error.status) {
      console.error("Fetch operation failed:", error);
      const wrapError = new Error(
        "Internal server error during data fetching.",
      );
      wrapError.details = error.message;
      wrapError.status = 500;
      throw wrapError;
    }
    throw error;
  }
};

/**
 * Common error response sender.
 * @param {object} res The Express response object.
 * @param {Error} error The error object.
 */
const sendErrorResponse = (res, error) => {
  const status = error.status || 500;
  return res.status(status).json({
    error: error.message,
    details: error.details,
  });
};

/**
 * Handler for the /list endpoint. Designed for paginated browsing.
 */
exports.getFoodList = async (_, res) => {
  // NOTE: FDC API does not have a simple 'list' endpoint without a type.
  // This assumes the API supports a generic list or you are using a non-standard API.
  const url = `${FOODCENTRAL_BASE_URL}list?api_key=${FOODCENTRAL_API_KEY}`;

  try {
    const data = await executeFetch(url);
    // Send the raw data for list endpoint
    return res.json(data);
  } catch (error) {
    return sendErrorResponse(res, error);
  }
};

/**
 * Handler for the /fdc endpoint. Get the the data of the current product, transformed.
 * @param {string} req.id = Food ID from the Food Data Central
 */
exports.getFood = async (req, res) => {
  const { id } = req.query;

  if (!id) {
    return res.status(400).json({
      error: "An ID is required for the /FDC endpoint.",
      details:
        "Please provide a 'id' query parameter with the Food Data Central ID.",
    });
  }

  // Use the /foods endpoint to get detailed nutrient information for a specific FDC ID
  const url = `${FOODCENTRAL_BASE_URL}?api_key=${FOODCENTRAL_API_KEY}&fdcIds=${id}`;

  try {
    const rawData = await executeFetch(url);

    // FDC typically returns an array even for a single ID, so we take the first element.
    if (!Array.isArray(rawData) || rawData.length === 0) {
      return res.status(404).json({
        error: "Food not found.",
        details: `No data returned for FDC ID: ${id}.`,
      });
    }

    const foodItem = rawData[0];

    // Apply the transformation utility to format the output
    const transformedData = foodtoCalAI(foodItem);
    return res.json(transformedData);
  } catch (error) {
    return sendErrorResponse(res, error);
  }
};

/**
 * Handler for the /search endpoint. Requires a 'q' parameter for specific searching.
 */
exports.searchFoods = async (req, res) => {
  const { q } = req.query;

  if (!q) {
    return res.status(400).json({
      error:
        "A search query parameter 'q' is required for the /search endpoint.",
      details: "Example: /search?q=apple",
    });
  }

  const url = `${FOODCENTRAL_BASE_URL}search?api_key=${FOODCENTRAL_API_KEY}&query=${encodeURIComponent(q)}`;

  try {
    const data = await executeFetch(url);
    // Send the raw data for search endpoint
    return res.json(data);
  } catch (error) {
    return sendErrorResponse(res, error);
  }
};
