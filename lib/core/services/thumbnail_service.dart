import 'dart:io';
import 'dart:typed_data';

import 'package:image/image.dart' as img;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class ThumbnailService {
  const ThumbnailService();

  Future<String> buildThumbnailPath(String sourcePath) async {
    final sourceFile = File(sourcePath);
    final baseName = path.basenameWithoutExtension(sourcePath);
    final fileName = '${baseName}_thumb.jpg';
    final thumbnailDirectory = await _thumbnailDirectory();
    final output = File(path.join(thumbnailDirectory.path, fileName));

    final bytes = await sourceFile.readAsBytes();
    final decoded = img.decodeImage(bytes);
    if (decoded == null) {
      await sourceFile.copy(output.path);
      return output.path;
    }

    final thumbnail = img.copyResize(decoded, width: 240);
    final encoded = Uint8List.fromList(img.encodeJpg(thumbnail, quality: 72));
    await output.writeAsBytes(encoded, flush: true);
    return output.path;
  }

  Future<Directory> _thumbnailDirectory() async {
    final root = await getApplicationSupportDirectory();
    final dir = Directory(path.join(root.path, 'upload_thumbnails'));
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }
}
