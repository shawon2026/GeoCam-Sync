class UploadProgressUtils {
  static double completion({
    required int totalItems,
    required int uploadedItems,
  }) {
    if (totalItems <= 0) {
      return 0;
    }
    return uploadedItems / totalItems;
  }
}
