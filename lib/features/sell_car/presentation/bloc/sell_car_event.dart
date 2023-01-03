import 'package:equatable/equatable.dart';
import '../../data/model/sell_car_delete_photo_request.dart';
import '../../data/model/sell_car_get_list_image.dart';
import '../../data/model/sell_car_model.dart';
import '../../data/model/sell_car_upload_photo_request.dart';

abstract class SellCarEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SellCarInit extends SellCarEvent {}

class GetLocalDataEvent extends SellCarEvent {}

class SellCarUpdatePhoto extends SellCarEvent {
  @override
  List<Object?> get props => super.props;
}

class DeletePhotoCarRegisEvent extends SellCarEvent {
  final List<SellCarDeleteSinglePhotoRequestModel> request;
  final SellCarUploadPhotoRequestModel? uploadPhotoRequestModel;

  DeletePhotoCarRegisEvent(this.request, this.uploadPhotoRequestModel);

  @override
  List<Object> get props => [request];
}

class GetCarListImagesEvent extends SellCarEvent {
  final SellCarGetCarImagesRequestModel request;

  GetCarListImagesEvent(
    this.request,
  );

  @override
  List<Object?> get props => [request];
}

class UpLoadPhotosEvent extends SellCarEvent {
  final SellCarUploadPhotoRequestModel request;

  UpLoadPhotosEvent(this.request);
}

class PostSellCarEvent extends SellCarEvent {
  final SellCarModel request;

  PostSellCarEvent(this.request);
}
