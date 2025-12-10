const express = require("express");
const cors = require("cors");
require("dotenv").config();

const testRoute = require("./routes/test.route");
const goalsRoute = require("./routes/goals.route");
const barcodeRoute = require("./routes/barcode.route");
const scanRoute = require("./routes/scan.route");

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json({ limit: "50mb" }));
app.use(express.urlencoded({ extended: true, limit: "50mb" }));

// Routes
app.use("/test", testRoute);
app.use("/calculate_goals", goalsRoute);
app.use("/scan_barcode", barcodeRoute);
app.use("/scan_food", scanRoute);

app.listen(PORT, () => {
  console.log(`🚀 Server running at http://localhost:${PORT}`);
});
