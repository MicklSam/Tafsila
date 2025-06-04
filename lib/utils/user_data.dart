class UserData {
  static double? userHeight;
  static double? userWeight;

  // Body measurements
  static Map<String, double>? measurements;

  // Clothing sizes
  static Map<String, Map<String, String>>? clothingSizes;

  // Save measurements and sizes
  static void saveMeasurements(
    Map<String, double> newMeasurements,
    Map<String, Map<String, String>> newSizes,
  ) {
    measurements = newMeasurements;
    clothingSizes = newSizes;
  }

  // Clear measurements
  static void clearMeasurements() {
    measurements = null;
    clothingSizes = null;
  }
}
