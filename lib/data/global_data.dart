class GlobalData {
  static final GlobalData _instance = GlobalData._internal();

  factory GlobalData() {
    return _instance;
  }

  GlobalData._internal();

  int caloriesADay = 1356;
  int proteinADay = 136;
  int carbsADay = 118;
  int fatsADay = 37;
  int fiberADay = 38;
  int sugarADay = 51; 
  int sodiumADay = 2300;
}
