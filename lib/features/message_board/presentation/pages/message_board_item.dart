import 'package:easy_localization/easy_localization.dart';
import 'package:flustars_flutter3/flustars_flutter3.dart';
import 'package:flutter/widgets.dart';

import 'package:mirukuru/core/resources/core_resource.dart';
import 'package:mirukuru/core/widgets/common/text_widget.dart';
import 'package:mirukuru/features/message_board/data/models/comment_model.dart';

class MessageBoardItem extends StatefulWidget {
  MessageDataItem item;

  MessageBoardItem({Key? key, required this.item}) : super(key: key);

  @override
  State<MessageBoardItem> createState() => _MessageBoardItemState();
}

class _MessageBoardItemState extends State<MessageBoardItem> {
  @override
  Widget build(BuildContext context) {
    var item = widget.item;

    return Padding(
      padding: EdgeInsets.only(bottom: Dimens.getHeight(15.0)),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
              color: item.messageType == MessageType.Customer
                  ? ResourceColors.color_0FA4EA
                  : ResourceColors.color_E1E1E1,
              width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: item.messageType == MessageType.Customer
                  ? ResourceColors.color_0FA4EA
                  : ResourceColors.color_E1E1E1,
              child: Padding(
                padding: EdgeInsets.only(
                    left: Dimens.getWidth(16.0),
                    top: Dimens.getWidth(5.0),
                    bottom: Dimens.getWidth(5.0)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextWidget(
                      label: item.messageType == MessageType.Customer
                          ? "YOUR_MESSAGE".tr()
                          : "STORE_MESSAGE".tr(),
                      textStyle: MKStyle.t12R.copyWith(
                          color: item.messageType == MessageType.Customer
                              ? ResourceColors.color_FFFFFF
                              : ResourceColors.color_333333),
                    ),
                    SizedBox(
                      width: Dimens.getWidth(45.0),
                    ),
                    TextWidget(
                      label: DateUtil.formatDateStr(item.sendDate,
                          format: "yyyy/MM/dd HH:mm"),
                      textStyle: MKStyle.t8R.copyWith(
                          color: item.messageType == MessageType.Customer
                              ? ResourceColors.color_FFFFFF
                              : ResourceColors.color_333333),
                    )
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                  left: Dimens.getWidth(16.0),
                  top: Dimens.getWidth(10.0),
                  right: Dimens.getWidth(10.0),
                  bottom: Dimens.getWidth(10.0)),
              child: TextWidget(
                label: item.messageContent,
                textStyle:
                    MKStyle.t10R.copyWith(color: ResourceColors.color_333333),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MessageDataItem {
  MessageType messageType;
  String messageContent;
  String sendDate;

  MessageDataItem({
    required this.messageType,
    required this.messageContent,
    required this.sendDate,
  });

  static List<MessageDataItem> convertFrom(List<CommentModel> comments) {
    List<MessageDataItem> quotationDataItems = [];
    comments.forEach((question) {
      var replies = question.replyList;
      if (replies.isNotEmpty) {
        quotationDataItems.addAll(replies.map((e) => MessageDataItem(
            messageType: MessageType.Store,
            messageContent: e.info ?? "",
            sendDate: e.sendDate?.toString() ?? "")));
      }
      quotationDataItems.add(MessageDataItem(
          messageType: MessageType.Customer,
          messageContent: question.question ?? "",
          sendDate: question.questionDate.toString()));
    });

    return quotationDataItems;
  }
}

enum MessageType { Customer, Store }
