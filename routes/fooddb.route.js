const express = require("express");
const router = express.Router();
const {
  searchFoods,
  getFoodList,
  getFood,
} = require("../controllers/fooddb.controller");

router.post("/search", searchFoods);
router.get("/list", getFoodList);
router.post("/", getFood);

module.exports = router;
