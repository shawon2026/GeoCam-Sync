enum UploadConstants {
  maxConcurrentUploads(1),
  maxSyncedHistoryItems(20),
  maxRetryCount(3),
  retryDelaySeconds(2),
  defaultZoom(1);

  final num value;
  const UploadConstants(this.value);
}
