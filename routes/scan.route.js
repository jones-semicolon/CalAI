const express = require("express");
const router = express.Router();
const { scanFood } = require("../controllers/scan.controller");

router.post("/", scanFood);

module.exports = router;
