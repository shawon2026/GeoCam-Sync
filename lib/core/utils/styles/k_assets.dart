enum KAssetName { logoJpg }

extension AssetsExtension on KAssetName {
  String get imagePath {
    const rootPath = 'assets';
    const imagesDir = '$rootPath/images';
    switch (this) {
      case KAssetName.logoJpg:
        return '$imagesDir/logo.jpg';
    }
  }
}
