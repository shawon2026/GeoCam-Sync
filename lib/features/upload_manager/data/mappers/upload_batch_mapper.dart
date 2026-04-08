import '/features/upload_manager/data/models/upload_batch_model.dart';
import '/features/upload_manager/domain/entities/upload_batch.dart';

class UploadBatchMapper {
  static UploadBatchModel toModel(UploadBatch entity) {
    return UploadBatchModel.fromEntity(entity);
  }
}
