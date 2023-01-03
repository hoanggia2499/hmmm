import 'package:mirukuru/features/question/data/models/question_bean.dart';
import 'package:mirukuru/features/quotation/presentation/models/inquiry_type_enum.dart';

class QueryListBean {
  String name;
  String unit;
  String price;
  String qty;
  String cartId;
  bool isCheck; // この問合わせにチェックが入っているか
  String id;
  String questionNum;
  String subtotal;
  String iconImage;
  String kindImage;

  QueryListBean(
      {this.questionNum = '',
      this.id = '',
      this.isCheck = false,
      this.price = '',
      this.name = '',
      this.cartId = '',
      this.qty = '',
      this.unit = '',
      this.iconImage = '',
      this.kindImage = '',
      this.subtotal = ''});

  factory QueryListBean.convertFrom(QuestionBean questionBean) {
    String questionDate = questionBean.questionDate;
    int id = questionBean.id;
    int questionKbn = questionBean.questionKbn;
    String asMakerName = questionBean.asMakerName;
    String asnetCarName = questionBean.asnetCarName;
    String fullExhNum = questionBean.fullExhNum;
    String questionNum = questionBean.questionNum.toString();
    String exhNum = questionBean.exhNum;

    String nameValue = "";
    if (exhNum.trim().isNotEmpty) {
      if (fullExhNum != "") {
        nameValue = fullExhNum + " " + asMakerName + " " + asnetCarName;
      }
    } else {
      nameValue = asMakerName + " " + asnetCarName;
    }

    String unitValue = questionDate;

    String kindImageValue =
        InquiryTypeExtension.classifyInquiryType(id, questionKbn)
            .getOrElse(() => InquiryTypeEnum.OTHERS_ADDITIONAL_INQUIRIES)
            .image;

    return QueryListBean(
        name: nameValue,
        unit: unitValue,
        id: id.toString(),
        kindImage: kindImageValue,
        questionNum: questionNum);
  }
}
