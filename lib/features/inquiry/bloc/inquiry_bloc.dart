import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'inquiry_event.dart';
part 'inquiry_state.dart';

class InquiryBloc extends Bloc<InquiryEvent, InquiryState> {
  InquiryBloc() : super(InitInquiryState());
}
