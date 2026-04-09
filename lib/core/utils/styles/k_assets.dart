enum KAssetName { logoPng, logoJpg }

extension AssetsExtension on KAssetName {
  String get imagePath {
    const String _rootPath = 'assets';
    const String _imagesDir = '$_rootPath/images';
    switch (this) {
      case KAssetName.logoPng:
        return '$_imagesDir/logo.png';
      case KAssetName.logoJpg:
        return '$_imagesDir/logo.jpg';
    }
  }
}
