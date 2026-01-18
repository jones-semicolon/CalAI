const express = require("express");
const router = express.Router();
const { scanFood } = require("../controllers/scan.controller");

router.get("/", scanFood);

module.exports = router;
