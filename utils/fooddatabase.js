/**
 * HELPER: Safe Fraction Evaluator
 * Handles "1/2", "1.5", and "1" safely.
 */
const evalFraction = (val) => {
  if (!val) return 1;
  if (typeof val === "number") return val;
  if (val.includes("/")) {
    const [n, d] = val.split("/");
    return Number(n) / Number(d);
  }
  return Number(val) || 1;
};

/**
 * HELPER: Format Portions
 * Normalizes units (e.g. "Cup"), calculates per-unit weight, and cleans labels.
 */
const formatPortions = (rawPortions) => {
  if (!rawPortions || !Array.isArray(rawPortions)) return [];

  return rawPortions
    .map((p) => {
      // 1. Get Base Data
      const rawGrams = Number(p.gramWeight || 0);
      let desc = (p.portionDescription || "").trim();

      // Filter out bad data
      if (desc.toLowerCase().includes("quantity not specified")) return null;

      // 2. Extract Fields (Structured vs String Parsing)
      let amount = p.amount;
      let unit = p.measureUnit?.name;
      let modifier = p.modifier;

      // Logic: Parse "1.5 cup, chopped" from string if fields are missing
      if ((!amount || !unit) && desc) {
        const parts = desc.split(",").map((s) => s.trim());
        const mainPart = parts[0];

        const match = mainPart.match(/^([\d\./]+)\s+(.+)$/); // e.g. "1.5" "Cup"
        if (match) {
          amount = match[1];
          unit = match[2];
        } else {
          // Case: "Apple" (Implies 1 Apple)
          amount = 1;
          unit = mainPart;
        }

        if (!modifier && parts.length > 1) {
          modifier = parts.slice(1).join(", ");
        }
      }

      // 3. Normalize Amount & Math
      const finalAmount = evalFraction(amount);

      // FORMULA: If "2 Slices" = 50g, then "1 Slice" = 25g
      let singleUnitWeight = rawGrams;
      if (finalAmount > 0) {
        singleUnitWeight = rawGrams / finalAmount;
      }

      // 4. Clean Unit Label
      let finalUnit = unit && unit !== "undetermined" ? unit.trim() : "Serving";

      // Normalize common units
      finalUnit = finalUnit.toLowerCase();
      if (finalUnit.startsWith("tablespoon")) finalUnit = "Tbsp";
      else if (finalUnit.startsWith("teaspoon")) finalUnit = "Tsp";
      else if (finalUnit.startsWith("ounce")) finalUnit = "oz";

      // Capitalize
      finalUnit = finalUnit.charAt(0).toUpperCase() + finalUnit.slice(1);

      // Readable "RACC"
      if (finalUnit.includes("RACC")) finalUnit = "Standard Serving";

      return {
        label: finalUnit, // Display: "Cup"
        modifier: modifier, // Display: "Chopped"
        gramWeight: Number(singleUnitWeight.toFixed(2)), // Math: 128.0
        originalAmount: finalAmount,
      };
    })
    .filter(Boolean); // Remove nulls
};

/**
 * HELPER: Format Nutrient Output
 */
const formatNutrient = (item) => {
  if (!item) return null;
  // Normalize fields between Search (value) and Details (amount)
  const amount = item.amount !== undefined ? item.amount : item.value;
  const unit = item.nutrient?.unitName || item.unitName;
  const name = item.nutrient?.name || item.nutrientName;

  return {
    amount: Number(amount || 0),
    unit: unit || "",
    name: name || "",
  };
};

/**
 * HELPER: Smart Nutrient Finder
 * Finds nutrient by name, but PRIORITIZES a specific unit (e.g. 'kcal' or 'g').
 * * @param {Array} nutrients - The list of nutrients
 * @param {Array} keywords - Keywords to search (e.g. ["energy"])
 * @param {String} preferredUnit - The unit we want (e.g. "kcal")
 * @param {String} altUnit - A fallback unit to convert from (e.g. "kJ")
 * @param {Number} conversion - Factor to divide by (e.g. 4.184)
 */
const findNutrient = (
  nutrients,
  keywords,
  preferredUnit,
  altUnit = null,
  conversion = 1,
) => {
  if (!nutrients) return { amount: 0, unit: preferredUnit, name: keywords[0] };

  // Match Helpers
  const matchName = (n) => {
    const name = (n.nutrient?.name || n.nutrientName || "").toLowerCase();
    return keywords.some((k) => name.includes(k.toLowerCase()));
  };
  const matchUnit = (n, u) => {
    const unit = (n.nutrient?.unitName || n.unitName || "").toLowerCase();
    return unit === u.toLowerCase();
  };

  // 1. Strict Match (Name + Preferred Unit)
  const strictMatch = nutrients.find(
    (n) => matchName(n) && matchUnit(n, preferredUnit),
  );
  if (strictMatch) return formatNutrient(strictMatch);

  // 2. Conversion Match (Name + Alt Unit)
  if (altUnit) {
    const altMatch = nutrients.find(
      (n) => matchName(n) && matchUnit(n, altUnit),
    );
    if (altMatch) {
      const formatted = formatNutrient(altMatch);
      if (formatted) {
        // NOTE: This rounds the result (e.g., 3.3 fl oz becomes 3 fl oz)
        formatted.amount = Math.round(formatted.amount / conversion);
        formatted.unit = preferredUnit; // Force correct label
      }
      return formatted;
    }
  }

  // 3. Loose Match (Name Only - Safety Fallback)
  const looseMatch = nutrients.find((n) => matchName(n));
  if (looseMatch) return formatNutrient(looseMatch);

  // 4. Not Found (Return 0)
  return { amount: 0, unit: preferredUnit, name: keywords[0] };
};

// =============================================================================
// MAIN TRANSFORMER FUNCTION
// =============================================================================
exports.foodtoCalAI = (food) => {
  const allNutrients = food.foodNutrients || [];

  // 1. EXTRACT MAIN NUTRIENTS (Smart Strategy)
  // Energy: Prefer 'kcal', fallback 'kJ' (divide by 4.184)
  const calories = findNutrient(allNutrients, ["energy"], "kcal", "kJ", 4.184);

  // Macros: Prefer 'g'
  const protein = findNutrient(allNutrients, ["protein"], "g");
  const carbs = findNutrient(
    allNutrients,
    ["carbohydrate, by difference"],
    "g",
  );
  const fats = findNutrient(allNutrients, ["total lipid", "fat"], "g");
  const sugar = findNutrient(allNutrients, ["sugars, total", "sugar"], "g");
  const fiber = findNutrient(allNutrients, ["fiber, total dietary"], "g");

  // Minerals: Prefer 'mg'
  const sodium = findNutrient(allNutrients, ["sodium, na"], "mg");
  
  // ✅ UPDATE: Convert Water from 'g' to 'fl oz'
  // 1 fl oz = 29.57 g
  const water = findNutrient(allNutrients, ["water"], "fl oz", "g", 29.57);


  // 2. EXCLUSION SET (Prevent Duplicates in 'Other Nutrients')
  const usedNames = new Set(
    [calories, protein, carbs, fats, sugar, fiber, sodium, water]
      .filter((n) => n && n.name)
      .map((n) => n.name),
  );

  // 3. INGREDIENTS NORMALIZATION (Merge Survey & Branded types)
  let finalIngredients = [];

  if (food.inputFoods && Array.isArray(food.inputFoods)) {
    // Case A: Survey Food (Structured Input Foods)
    finalIngredients = food.inputFoods.map((item) => ({
      name:
        item.foodDescription ||
        item.inputFood?.description ||
        "Unknown Ingredient",
      id: item.id,
      amount: item.ingredientWeight || 0,
      unit: "g",
    }));
  } else if (food.ingredients && typeof food.ingredients === "string") {
    // Case B: Branded Food (String List)
    finalIngredients = food.ingredients
      .split(",")
      .map((s) => ({ name: s.trim(), id: null, amount: 0, unit: null }))
      .filter((i) => i.name.length > 0);
  }

  // 4. RETURN CLEAN OBJECT
  return {
    fdcId: food.fdcId,
    name: food.description,
    brand: food.brandOwner || food.brandName || null,

    // Processed Portions
    portions: formatPortions(food.foodPortions),

    // Processed Ingredients
    ingredients: finalIngredients,

    nutrients: {
      calories: calories,
      proteins: protein,
      carbs: carbs,
      fats: fats,
      sugar: sugar,
      fiber: fiber,
      sodium: sodium,
      water: water,
    },

    // Filter "Other" Nutrients
    other_nutrients: allNutrients
      .filter((i) => {
        const val = i.amount !== undefined ? i.amount : i.value;
        const name = i.nutrient?.name || i.nutrientName;

        // Exclude Energy explicitly (keywords sometimes miss partial matches)
        if (name && name.toLowerCase().includes("energy")) return false;

        return val > 0 && name && !usedNames.has(name);
      })
      .map((i) => formatNutrient(i)),
  };
};