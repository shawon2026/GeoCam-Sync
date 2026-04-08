class CameraZoomUtils {
  static double clamp(double value, {double min = 1, double max = 5}) {
    if (value < min) {
      return min;
    }
    if (value > max) {
      return max;
    }
    return value;
  }
}
