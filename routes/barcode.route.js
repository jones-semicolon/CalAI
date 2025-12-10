const express = require("express");
const router = express.Router();
const { scanBarcode } = require("../controllers/barcode.controller");

router.post("/", scanBarcode);

module.exports = router;
