const express = require("express");
const router = express.Router();
const { log_exercise } = require("../controllers/exercise.controller");

router.post("/", log_exercise);

module.exports = router;
