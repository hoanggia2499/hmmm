import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mirukuru/features/about/domain/usecases/get_about.dart';

part 'about_event.dart';
part 'about_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';

class AboutBloc extends Bloc<AboutEvent, AboutState> {
  final GetAbout getAbout;

  AboutBloc(this.getAbout) : super(Empty()) {
    on<AboutInit>(_onAboutInit);
  }

  Future _onAboutInit(AboutInit event, Emitter<AboutState> emit) async {}
}
