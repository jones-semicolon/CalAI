const express = require("express");
const cors = require("cors");
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
