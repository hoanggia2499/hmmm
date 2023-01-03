import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';

enum InquiryTypeEnum {
  REQUEST_FOR_QUOTATION,
  VISIT_RESERVATION,
  CAR_INQUIRY,
  REQUEST_FOR_ASSESSMENT,
  OTHERS_REPAIR_N_MAINTENANCE,
  OTHERS_VEHICLE_INSPECTION,
  OTHERS_PURCHASING_N_INSTALLING_PARTS,
  OTHERS_ADDITIONAL_INQUIRIES
}

enum MessageBoardViewMode { MITUMORI, SATEI_IRAI }

extension InquiryTypeExtension on InquiryTypeEnum {
  String? get title {
    switch (this) {
      case InquiryTypeEnum.REQUEST_FOR_QUOTATION:
        return "REQUEST_FOR_QUOTATION".tr();
      case InquiryTypeEnum.VISIT_RESERVATION:
        return "VISIT_RESERVATION".tr();
      case InquiryTypeEnum.CAR_INQUIRY:
        return "VEHICLE_INQUIRY".tr();
      case InquiryTypeEnum.REQUEST_FOR_ASSESSMENT:
        return "ASSESSMENT_REQUEST".tr();
      case InquiryTypeEnum.OTHERS_REPAIR_N_MAINTENANCE:
        return "REPAIR_MAINTENANCE".tr();
      case InquiryTypeEnum.OTHERS_VEHICLE_INSPECTION:
        return "CAR_INSPECTION".tr();
      case InquiryTypeEnum.OTHERS_PURCHASING_N_INSTALLING_PARTS:
        return "PURCHASING_INSTALLING_PARTS".tr();
      case InquiryTypeEnum.OTHERS_ADDITIONAL_INQUIRIES:
        return "OTHER_INQUIRIES".tr();
      default:
        break;
    }
    return null;
  }

  MessageBoardViewMode get mode {
    switch (this) {
      case InquiryTypeEnum.REQUEST_FOR_QUOTATION:
      case InquiryTypeEnum.VISIT_RESERVATION:
      case InquiryTypeEnum.CAR_INQUIRY:
        return MessageBoardViewMode.MITUMORI;
      case InquiryTypeEnum.REQUEST_FOR_ASSESSMENT:
      case InquiryTypeEnum.OTHERS_REPAIR_N_MAINTENANCE:
      case InquiryTypeEnum.OTHERS_VEHICLE_INSPECTION:
      case InquiryTypeEnum.OTHERS_PURCHASING_N_INSTALLING_PARTS:
      case InquiryTypeEnum.OTHERS_ADDITIONAL_INQUIRIES:
        return MessageBoardViewMode.SATEI_IRAI;
    }
  }

  int get kubunId {
    switch (this) {
      case InquiryTypeEnum.REQUEST_FOR_QUOTATION:
        return 1;
      case InquiryTypeEnum.VISIT_RESERVATION:
        return 2;
      case InquiryTypeEnum.CAR_INQUIRY:
        return 3;
      case InquiryTypeEnum.REQUEST_FOR_ASSESSMENT:
        return 4;
      case InquiryTypeEnum.OTHERS_REPAIR_N_MAINTENANCE:
      case InquiryTypeEnum.OTHERS_VEHICLE_INSPECTION:
      case InquiryTypeEnum.OTHERS_PURCHASING_N_INSTALLING_PARTS:
      case InquiryTypeEnum.OTHERS_ADDITIONAL_INQUIRIES:
        return 5;
    }
  }

  int get questionKbn {
    switch (this) {
      case InquiryTypeEnum.REQUEST_FOR_QUOTATION:
      case InquiryTypeEnum.VISIT_RESERVATION:
      case InquiryTypeEnum.CAR_INQUIRY:
      case InquiryTypeEnum.REQUEST_FOR_ASSESSMENT:
        return -1;
      case InquiryTypeEnum.OTHERS_REPAIR_N_MAINTENANCE:
        return 1;
      case InquiryTypeEnum.OTHERS_VEHICLE_INSPECTION:
        return 2;
      case InquiryTypeEnum.OTHERS_PURCHASING_N_INSTALLING_PARTS:
        return 3;
      case InquiryTypeEnum.OTHERS_ADDITIONAL_INQUIRIES:
        return 4;
      default:
        return 4;
    }
  }

  String get image {
    switch (this) {
      case InquiryTypeEnum.REQUEST_FOR_QUOTATION:
        return 'assets/images/png/mitsumori_irai_icon.png';
      case InquiryTypeEnum.VISIT_RESERVATION:
        return 'assets/images/png/raiten_yoyaku.png';
      case InquiryTypeEnum.CAR_INQUIRY:
        return 'assets/images/png/sharyo_toiawase.png';
      case InquiryTypeEnum.REQUEST_FOR_ASSESSMENT:
        return 'assets/images/png/sateirai.png';
      case InquiryTypeEnum.OTHERS_REPAIR_N_MAINTENANCE:
        return 'assets/images/png/syuri_sebi.png';
      case InquiryTypeEnum.OTHERS_VEHICLE_INSPECTION:
        return 'assets/images/png/shaken.png';
      case InquiryTypeEnum.OTHERS_PURCHASING_N_INSTALLING_PARTS:
        return 'assets/images/png/parts_konyu.png';
      case InquiryTypeEnum.OTHERS_ADDITIONAL_INQUIRIES:
        return 'assets/images/png/sonota_icon.png';
      default:
        return 'assets/images/png/sonota_icon.png';
    }
  }

  int? get upKind {
    switch (this) {
      case InquiryTypeEnum.REQUEST_FOR_ASSESSMENT:
        return 1;
      case InquiryTypeEnum.OTHERS_REPAIR_N_MAINTENANCE:
        return 3;
      case InquiryTypeEnum.OTHERS_VEHICLE_INSPECTION:
        return 4;
      case InquiryTypeEnum.OTHERS_PURCHASING_N_INSTALLING_PARTS:
        return 5;
      case InquiryTypeEnum.OTHERS_ADDITIONAL_INQUIRIES:
        return 6;
      default:
        return null;
    }
  }

  static InquiryTypeEnum? fromTitle(String title) {
    if (title.isNotEmpty) {
      for (InquiryTypeEnum type in InquiryTypeEnum.values) {
        if (type.title == title) return type;
      }
    }
    return null;
  }

  static InquiryTypeEnum? getInquiryTypeByTitle(String title) =>
      InquiryTypeEnum.values.firstWhere((element) => title == element.title);

  static List<String> getInquiryListData() {
    return InquiryTypeEnum.values.take(3).map((e) => e.title!).toList();
  }

  static List<InquiryTypeEnum> getOtherTypeInquiryListData() {
    return InquiryTypeEnum.values.skip(3).toList();
  }

  static Option<InquiryTypeEnum> classifyInquiryType(
      int kubunId, int questionKbn) {
    switch (kubunId) {
      case 1:
        return some(InquiryTypeEnum.REQUEST_FOR_QUOTATION);
      case 2:
        return some(InquiryTypeEnum.VISIT_RESERVATION);
      case 3:
        return some(InquiryTypeEnum.CAR_INQUIRY);
      case 4:
        return some(InquiryTypeEnum.REQUEST_FOR_ASSESSMENT);
      case 5:
        if (questionKbn == 1) {
          return some(InquiryTypeEnum.OTHERS_REPAIR_N_MAINTENANCE);
        } else if (questionKbn == 2) {
          return some(InquiryTypeEnum.OTHERS_VEHICLE_INSPECTION);
        } else if (questionKbn == 3) {
          return some(InquiryTypeEnum.OTHERS_PURCHASING_N_INSTALLING_PARTS);
        } else if (questionKbn == 4) {
          return some(InquiryTypeEnum.OTHERS_ADDITIONAL_INQUIRIES);
        } else {
          return some(InquiryTypeEnum.OTHERS_ADDITIONAL_INQUIRIES);
        }
      default:
        return none();
    }
  }
}
