import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mirukuru/core/util/process_util.dart';

part 'app_state.dart';
part 'app_event.dart';

class AppBloc extends Bloc<AppBlocEvent, AppBlocState> {
  bool _isNameLoaded = false;
  bool get isNameLoaded => this._isNameLoaded;
  set isNameLoaded(bool value) => this._isNameLoaded = value;

  bool _hasVersionChecked = false;
  bool get hasVersionChecked => this._hasVersionChecked;
  set hasVersionChecked(bool value) => this._hasVersionChecked = value;

  AppBloc() : super(NoAction(pageActing: false)) {
    on<AddActionEvent>(_onAddAction);
  }

  void _onAddAction(AddActionEvent event, Emitter<AppBlocState> emit) {
    if (event.currentAction != null) {
      ProcessUtil.instance.addProcess(event.currentAction!);
    }
  }
}
