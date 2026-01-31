// server/utils/fooddatabase.js

const NUTRIENT_IDS = {
  carbs_g: 1005,
  calories_kcal: 1008,
  sugar_g: 2000,
  sodium_mg: 1093,
  protein_g: 1003,
  fat_g: 1004,
};

const EXCLUDED_NUTRIENT_IDS = new Set(Object.values(NUTRIENT_IDS));

/**
 * Searches the foodNutrients array for a specific nutrient by its ID.
 *
 * @param {Array<Object>} foodNutrients - The array of nutrient objects from the FDC API response.
 * @param {number} nutrientId - The ID of the nutrient to find (e.g., 1008 for Energy).
 * @returns {Object | null} An object containing the nutrient's details (ID, name, amount, unit)
 * or null if the nutrient is not found.
 */
const findNutrientById = (foodNutrients, nutrientId) => {
  const nutrientItem = (foodNutrients || []).find(
    (item) => item.nutrient && item.nutrient.id === nutrientId,
  );

  if (!nutrientItem) {
    return null;
  }

  const { amount, nutrient } = nutrientItem;
  const { id, name, unitName } = nutrient;

  return {
    id: id,
    name: name,
    amount: amount,
    unit: unitName,
  };
};

/**
 * Transforms a single FoodData Central food object into the desired CalAI format.
 * * @param {object} food - A single food object from the FDC API response.
 * @returns {object} The transformed food object.
 */
exports.foodtoCalAI = (food) => {
  const foodNutrients = food.foodNutrients || [];

  return {
    fdcId: food.fdcId,
    name: food.description,
    foodPortions: food.foodPortions,
    inputFoods: food.inputFoods,
    calories_kcal: findNutrientById(foodNutrients, NUTRIENT_IDS.calories_kcal),
    nutrients: {
      protein_g: findNutrientById(foodNutrients, NUTRIENT_IDS.protein_g),
      carbs_g: findNutrientById(foodNutrients, NUTRIENT_IDS.carbs_g),
      fats_g: findNutrientById(foodNutrients, NUTRIENT_IDS.fat_g),
    },
    // Filter out nutrients with zero amount, those missing a name, AND those in the excluded set
    other_nutrients: foodNutrients
      .filter(
        (i) =>
          i.amount > 0 &&
          i.nutrient &&
          i.nutrient.name &&
          !EXCLUDED_NUTRIENT_IDS.has(i.nutrient.id),
      )
      .map((i) => ({
        name: i.nutrient.name,
        amount: i.amount,
        unitName: i.nutrient.unitName,
      })),
  };
};
