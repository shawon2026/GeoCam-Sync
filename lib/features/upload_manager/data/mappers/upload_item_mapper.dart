import '/features/upload_manager/data/models/upload_item_model.dart';
import '/features/upload_manager/domain/entities/upload_item.dart';

class UploadItemMapper {
  static UploadItemModel toModel(UploadItem entity) {
    return UploadItemModel.fromEntity(entity);
  }
}
