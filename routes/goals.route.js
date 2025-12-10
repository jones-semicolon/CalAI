const express = require("express");
const router = express.Router();
const { calculateGoals } = require("../controllers/goals.controller");

router.post("/", calculateGoals);

module.exports = router;
