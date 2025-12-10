exports.convertToCalAI = (product) => ({
  meal_name: product.product_name || "Unknown product",

  ingredients: (product.ingredients || []).map((i) => ({
    name: i.text,
    estimated_weight_grams: i.percent_estimate
      ? Number(i.percent_estimate.toFixed(2))
      : 0,
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
  notes: "From OpenFoodFacts data",
});
