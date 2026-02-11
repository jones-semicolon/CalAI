exports.convertToCalAI = (product) => {
  const nutriScoreMap = { 'a': 10, 'b': 8, 'c': 6, 'd': 4, 'e': 2 };
  const rawGrade = product.nutriscore_grade || product.nutrition_grades || "unknown";
  const healthScore = nutriScoreMap[rawGrade.toLowerCase()] || null;
  const nutriments = product.nutriments || {};

  const to2Dec = (val) => {
    const num = parseFloat(val);
    return isNaN(num) ? 0.00 : Number(num.toFixed(2));
  };

  // 1. Define the "Main" keys to exclude from "Other Nutrients"
  const mainNutrientKeys = [
    'energy-kcal', 'energy-kj', 'carbohydrates', 'proteins', 
    'fat', 'fiber', 'sugars', 'sodium', 'energy'
  ];

  // 2. Filter and Format "Other" Nutrients
  const otherNutrients = Object.keys(nutriments)
    .filter((key) => {
      // We only want keys ending in _100g to get the values
      if (!key.endsWith('_100g')) return false;

      const baseName = key.replace('_100g', '');
      const val = nutriments[key];

      // Exclude main macros, energy keywords, and zero values
      return (
        !mainNutrientKeys.includes(baseName) &&
        !baseName.toLowerCase().includes('energy') &&
        val > 0
      );
    })
    .map((key) => {
      const baseName = key.replace('_100g', '');
      // Format the name: "vitamin-c" -> "Vitamin C"
      const displayName = baseName
        .split('-')
        .map(word => word.charAt(0).toUpperCase() + word.slice(1))
        .join(' ');

      return {
        name: displayName,
        amount: to2Dec(nutriments[key]),
        unit: nutriments[`${baseName}_unit`] || 'g'
      };
    });

  const rawCalories = nutriments["energy-kcal_100g"] ?? 
                     (nutriments["energy-kj_100g"] ? nutriments["energy-kj_100g"] / 4.184 : 0);

  return {
    barcode: product.code || "unknown",
    name: product.product_name || "unknown product",
    image_url: product.image_url || null,
    ingredients: (product.ingredients || []).map((i) => ({
      name: i.text ? i.text.replace(/_/g, '') : "unknown",
      calories: to2Dec(i.percent_estimate),
    })),
    nutrients: {
      calories: to2Dec(rawCalories),
      carbs: to2Dec(nutriments.carbohydrates_100g),
      protein: to2Dec(nutriments.proteins_100g),
      fats: to2Dec(nutriments.fat_100g),
      fibers: to2Dec(nutriments.fiber_100g),
      sugar: to2Dec(nutriments.sugars_100g),
      sodium: to2Dec((nutriments.sodium_100g || 0) * 1000),
    },
    // other_nutrients: otherNutrients, // ✅ Now a filtered list of objects
    serving_size: product.serving_size,
    servings_per_container: to2Dec(product.serving_quantity),
    serving_quantity_unit: product.serving_quantity_unit,
    health_score: healthScore,
    notes: "Data normalized to 100g reference - precision 2 decimal places",
  };
};