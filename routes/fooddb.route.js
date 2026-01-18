const express = require("express");
const router = express.Router();
const {
  searchFoods,
  getFoodList,
  getFood,
} = require("../controllers/fooddb.controller");

router.get("/search", searchFoods);
router.get("/list", getFoodList);
router.get("/", getFood);

module.exports = router;
