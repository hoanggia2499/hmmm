import 'package:equatable/equatable.dart';
import 'package:mirukuru/features/carlist/data/models/car_model.dart';
import 'package:mirukuru/features/maker/data/models/item_maker_model.dart';
import 'package:mirukuru/features/message_board/data/models/own_car_detail_model.dart';
import '../../data/model/local_data_model.dart';

abstract class CarRegisState extends Equatable {
  @override
  List<Object?> get props => [];
}

class Empty extends CarRegisState {}

class Loading extends CarRegisState {}

class Loaded extends CarRegisState {
  final List<CarModel> listCarModel;

  Loaded({required this.listCarModel});

  @override
  List<Object> get props => [listCarModel];
}

class Error extends CarRegisState {
  final String messageCode;
  final String messageContent;

  Error({required this.messageCode, required this.messageContent});

  @override
  List<Object> get props => [messageCode, messageContent];
}

class TimeOut extends CarRegisState {
  final String messageCode;
  final String messageContent;

  TimeOut({required this.messageCode, required this.messageContent});

  @override
  List<Object> get props => [messageCode, messageContent];
}

class CarTypePickerShowing extends CarRegisState {}

class ListCarModelSorted extends CarRegisState {
  final List<CarModel> listCarModel;

  ListCarModelSorted(this.listCarModel);
  @override
  List<Object?> get props => [listCarModel];
}

class CarTypePickerPopped extends CarRegisState {
  final String selectedCarTypeName;
  final String selectedCarCode;

  CarTypePickerPopped(
      {required this.selectedCarTypeName, required this.selectedCarCode});

  @override
  List<Object?> get props => [selectedCarTypeName];
}

class MakerCodeDialogPopped extends CarRegisState {
  final ItemMakerModel selectedMaker;

  MakerCodeDialogPopped(this.selectedMaker);

  @override
  List<Object?> get props => [selectedMaker.makerCode];
}

class MakerCodeDialogShowing extends CarRegisState {}

class CarListImagesLoaded extends CarRegisState {
  final List<String> images;

  CarListImagesLoaded(this.images);

  @override
  List<Object?> get props => [images];
}

class ChangeRIKUJIState extends CarRegisState {
  final RIKUJIModel value;

  ChangeRIKUJIState(this.value);

  @override
  List<Object?> get props => [value];
}

class ChangeInputTextState extends CarRegisState {
  final InputTextModel modelText;

  ChangeInputTextState(this.modelText);

  @override
  List<Object?> get props => [modelText];
}

class ChangeSelectionFieldState extends CarRegisState {
  final SelectionFieldModel modelSelection;

  ChangeSelectionFieldState(this.modelSelection);

  @override
  List<Object?> get props => [modelSelection];
}

class InitLocalData extends CarRegisState {
  final LocalModel localModel;

  InitLocalData(this.localModel);

  @override
  List<Object?> get props => [localModel];
}

class CarUserListLoaded extends CarRegisState {
  final OwnCarDetailModel ownCarDetailModel;

  CarUserListLoaded(this.ownCarDetailModel);

  @override
  List<Object?> get props => [ownCarDetailModel];
}

class DeleteOwnCarLoaded extends CarRegisState {
  final String response;

  DeleteOwnCarLoaded(this.response);

  @override
  List<Object?> get props => [response];
}

class PostSuccess extends CarRegisState {
  final String successContent;

  PostSuccess(this.successContent);
  @override
  List<Object?> get props => [successContent];
}

class UpdatedPhotos extends CarRegisState {
  final DateTime updatedTime;

  UpdatedPhotos() : this.updatedTime = DateTime.now();

  @override
  List<Object> get props => [this.updatedTime];
}
