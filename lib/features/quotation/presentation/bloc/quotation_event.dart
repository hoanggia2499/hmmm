import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:mirukuru/features/quotation/data/models/inquiry_request_model.dart';
import 'package:mirukuru/features/search_list/data/models/item_search_model.dart';

import '../../../search_detail/data/models/search_car_input_model.dart';

abstract class QuotationEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class MakeAnInquiryEvent extends QuotationEvent {
  final InquiryRequestModel inquiryRequestModel;

  MakeAnInquiryEvent(this.inquiryRequestModel);
}

class InitCarModelEvent extends QuotationEvent {
  InitCarModelEvent(this.context, this.searchCarInputModel);
  final SearchCarInputModel searchCarInputModel;
  final BuildContext context;
  @override
  List<Object> get props => [context, searchCarInputModel];
}

class SaveFavoriteToDBEvent extends QuotationEvent {
  SaveFavoriteToDBEvent(this.itemSearchModel);
  final ItemSearchModel itemSearchModel;

  @override
  List<Object> get props => [itemSearchModel];
}

class DeleteFavoriteFromDBEvent extends QuotationEvent {
  DeleteFavoriteFromDBEvent(this.itemSearchModel);
  final ItemSearchModel itemSearchModel;

  @override
  List<Object> get props => [itemSearchModel];
}
