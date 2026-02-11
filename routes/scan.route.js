const express = require("express");
const router = express.Router();
const multer = require("multer");
const { scanFood } = require("../controllers/scan.controller");

// ✅ Use memoryStorage instead of disk storage
const storage = multer.memoryStorage();
const upload = multer({ 
  storage: storage,
  limits: { fileSize: 10 * 1024 * 1024 } // Limit to 10MB for Vercel payloads
});

router.post("/", upload.single("image"), scanFood);

module.exports = router;