const express = require("express");
const router = express.Router();
const { test, goals } = require("../controllers/test.controller");

router.get("/", test);
router.get("/goals", goals);

module.exports = router;
