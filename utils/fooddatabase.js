// server/utils/fooddatabase.js

const findNutrientByName = (nutrients, keywords) => {
  // Returns the actual nutrient item from the FDC array so we can track it
  return (nutrients || []).find((n) => {
    if (!n.nutrient || !n.nutrient.name) return false;
    const name = n.nutrient.name.toLowerCase();
    return keywords.some((key) => name.includes(key.toLowerCase()));
  });
};

// Helper to format the found nutrient for the response
const formatNutrient = (item) => {
  if (!item) return null;
  return {
    amount: item.amount,
    unit: item.nutrient.unitName,
    name: item.nutrient.name,
  };
};

exports.foodtoCalAI = (food) => {
  const allNutrients = food.foodNutrients || [];

  // 1. Find the specific ones first
  const calMatch = findNutrientByName(allNutrients, ["energy", "kcal"]);
  const proMatch = findNutrientByName(allNutrients, ["protein"]);
  const carbMatch = findNutrientByName(allNutrients, [
    "carbohydrate, by difference",
  ]);
  const fatMatch = findNutrientByName(allNutrients, ["total lipid", "fat"]);
  const sugarMatch = findNutrientByName(allNutrients, [
    "sugars, total",
    "sugar",
  ]);
  const fiberMatch = findNutrientByName(allNutrients, ["fiber, total dietary"]);
  const magMatch = findNutrientByName(allNutrients, ["magnesium, mg"]);

  // 2. Create a Set of "Used" names to filter out later
  // We use the exact name from the USDA object for a perfect match
  const usedNames = new Set(
    [calMatch, proMatch, carbMatch, fatMatch, sugarMatch, fiberMatch, magMatch]
      .filter(Boolean)
      .map((n) => n.nutrient.name),
  );

  return {
    fdcId: food.fdcId,
    name: food.description,
    portions: food.foodPortions,
    input_foods: food.inputFoods,
    nutrients: {
      calories: formatNutrient(calMatch),
      proteins: formatNutrient(proMatch),
      carbs: formatNutrient(carbMatch),
      fats: formatNutrient(fatMatch),
      sugar: formatNutrient(sugarMatch),
      fiber: formatNutrient(fiberMatch),
      magnesium: formatNutrient(magMatch),
    },
    // 3. Filter: Only include items NOT in the usedNames set
    other_nutrients: allNutrients
      .filter(
        (i) =>
          i.amount > 0 && i.nutrient?.name && !usedNames.has(i.nutrient.name), // <--- The Exclusion Logic
      )
      .map((i) => ({
        name: i.nutrient.name,
        amount: i.amount,
        unitName: i.nutrient.unitName,
      })),
  };
};
