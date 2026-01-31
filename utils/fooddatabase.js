// server/utils/fooddatabase.js

// ---------------------------------------------------------
// 1. HELPER: Format Portions (The logic moved from Flutter)
// ---------------------------------------------------------
const formatPortions = (rawPortions) => {
  if (!rawPortions || !Array.isArray(rawPortions)) return [];

  return rawPortions
    .map((p) => {
      // 1. Safe Numbers
      const gramWeight = Number(p.gramWeight || 0);
      let desc = (p.portionDescription || "").trim();

      // 2. Filter Logic: Mark invalid items as null (to filter later)
      if (desc.toLowerCase().includes("quantity not specified")) {
        return null;
      }

      // 3. Extract Fields (Priority: Structured Data -> Fallback to Description)
      let amount = p.amount;
      let unit = p.measureUnit?.name; // Safe chaining
      let modifier = p.modifier;

      // If missing crucial data, try parsing the description string
      // Example: "1.5 cup, chopped"
      if ((!amount || !unit) && desc) {
        const parts = desc.split(",").map((s) => s.trim());
        const mainPart = parts[0]; // "1.5 cup"

        // If modifier wasn't in the API object, take it from the string
        if (!modifier && parts.length > 1) {
          modifier = parts.slice(1).join(", "); // "chopped"
        }

        // Regex: Matches number/fraction at start, then the rest
        const match = mainPart.match(/^([\d\./]+)\s+(.+)$/);

        if (match) {
          amount = match[1]; // "1.5"
          unit = match[2]; // "cup"
        } else {
          // Case: "Apple" (Implies 1 Apple)
          amount = 1;
          unit = mainPart;
        }
      }

      // 4. Cleanup & Defaults
      if (unit && unit.toLowerCase() === "undetermined") unit = null;

      return {
        amount: Number(amount) || 1, // Ensure it's a Number for math
        unit: unit ? unit.trim() : "Serving",
        modifier: modifier ? modifier.trim() : null,
        gramWeight: gramWeight,
      };
    })
    .filter(Boolean); // Remove the nulls we created in step 2
};

// ---------------------------------------------------------
// 2. HELPER: Find Nutrient (Your existing logic)
// ---------------------------------------------------------
const findNutrientByName = (nutrients, keywords) => {
  return (nutrients || []).find((n) => {
    if (!n.nutrient || !n.nutrient.name) return false;
    const name = n.nutrient.name.toLowerCase();
    return keywords.some((key) => name.includes(key.toLowerCase()));
  });
};

const formatNutrient = (item) => {
  if (!item) return null;
  return {
    amount: item.amount,
    unit: item.nutrient.unitName,
    name: item.nutrient.name,
  };
};

// ---------------------------------------------------------
// 3. MAIN FUNCTION
// ---------------------------------------------------------
exports.foodtoCalAI = (food) => {
  const allNutrients = food.foodNutrients || [];

  // 1. Find the specific ones
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

  // 2. Create Exclusion Set
  const usedNames = new Set(
    [calMatch, proMatch, carbMatch, fatMatch, sugarMatch, fiberMatch, magMatch]
      .filter(Boolean)
      .map((n) => n.nutrient.name),
  );

  return {
    fdcId: food.fdcId,
    name: food.description,

    // ✅ NOW USING THE HELPER HERE
    portions: formatPortions(food.foodPortions),

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
    other_nutrients: allNutrients
      .filter(
        (i) =>
          i.amount > 0 && i.nutrient?.name && !usedNames.has(i.nutrient.name),
      )
      .map((i) => ({
        name: i.nutrient.name,
        amount: i.amount,
        unitName: i.nutrient.unitName,
      })),
  };
};
