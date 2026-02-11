const express = require("express");
const cors = require("cors");
const path = require("path"); // ✅ Added missing import
require("dotenv").config();

const testRoute = require("./routes/test.route");
const goalsRoute = require("./routes/goals.route");
const barcodeRoute = require("./routes/barcode.route");
const scanRoute = require("./routes/scan.route");
const foodDatabase = require("./routes/fooddb.route");
const exerciseRoute = require("./routes/exercise.route");

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json({ limit: "50mb" }));
app.use(express.urlencoded({ extended: true, limit: "50mb" }));

/** * ✅ VERCEL FIX: 
 * Static file serving from /uploads won't work on Vercel because the 
 * file system is read-only. We can leave it for local development, 
 * but since we are using memoryStorage for Multer now, we won't 
 * actually be saving files there anymore.
 */
if (process.env.NODE_ENV !== 'production') {
  app.use("/uploads", express.static(path.join(__dirname, "uploads")));
}

// Routes
app.use("/test", testRoute);
app.use("/calculate-goals", goalsRoute);
app.use("/scan-barcode", barcodeRoute);
app.use("/scan-food", scanRoute);
app.use("/log-exercise", exerciseRoute);
app.use("/food", foodDatabase);

app.listen(PORT, () => {
  console.log(`🚀 Server running at http://localhost:${PORT}`);
});
