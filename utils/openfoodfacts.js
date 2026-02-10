exports.convertToCalAI = (product) => ({
  name: product.product_name || "unknown product",
  image_url: product.image_url || null,
  ingredients: (product.ingredients || []).map((i) => ({
    name: i.text,
    calories: i.percent_estimate ? Number(i.percent_estimate.toFixed(2)) : 0,
  })),
  nutrients: {
    calories: product.nutriments?.["energy_kcal"] || 0,
    carbs: product.nutriments?.carbohydrates || 0,
    fats: product.nutriments?.fat || 0,
    fibers: product.nutriments?.fiber || 0,
    sugar: product.nutriments?.sugars || 0,
    sodium: (product.nutriments?.sodium || 0) * 1000,
    notes: "From OpenFoodFacts data",
  },
});
