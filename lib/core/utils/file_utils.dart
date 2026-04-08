class FileUtils {
  static String fileNameFromPath(String path) {
    final parts = path.split('/');
    return parts.isEmpty ? path : parts.last;
  }
}
