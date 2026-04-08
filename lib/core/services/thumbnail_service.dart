import 'dart:io';
import 'dart:typed_data';

import 'package:image/image.dart' as img;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class ThumbnailService {
  const ThumbnailService();

  Future<String> buildThumbnailPath(String sourcePath) async {
    final sourceFile = File(sourcePath);
    final bytes = await sourceFile.readAsBytes();
    final decoded = img.decodeImage(bytes);
    if (decoded == null) {
      return sourcePath;
    }

    final thumbnail = img.copyResize(decoded, width: 240);
    final directory = await getTemporaryDirectory();
    final fileName = '${path.basenameWithoutExtension(sourcePath)}_thumb.jpg';
    final output = File(path.join(directory.path, fileName));
    final encoded = Uint8List.fromList(img.encodeJpg(thumbnail, quality: 72));
    await output.writeAsBytes(encoded, flush: true);
    return output.path;
  }
}
