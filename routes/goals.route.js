const express = require("express");
const router = express.Router();
const { calculateGoals } = require("../controllers/goals.controller");

router.get("/", calculateGoals);

module.exports = router;
