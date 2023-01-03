import 'package:flustars_flutter3/flustars_flutter3.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mirukuru/core/config/common.dart';
import 'package:mirukuru/core/resources/core_resource.dart';
import 'package:mirukuru/core/secure_storage/user_secure_storage.dart';
import 'package:mirukuru/core/util/core_util.dart';
import 'package:mirukuru/core/util/image_util.dart' as ImageHelper;
import 'package:mirukuru/core/widgets/common/sub_title_widget.dart';
import 'package:mirukuru/core/widgets/common/template_page.dart';
import 'package:mirukuru/core/widgets/common/text_widget.dart';
import 'package:mirukuru/core/widgets/dialog/common_dialog.dart';
import 'package:mirukuru/core/widgets/row_widget/listview_widget.dart';
import 'package:mirukuru/core/widgets/row_widget/template_pattern_1.dart';
import 'package:mirukuru/features/login/data/models/login_model.dart';
import 'package:mirukuru/features/message_board/data/models/asnetcar_detail_request_model.dart';
import 'package:mirukuru/features/message_board/data/models/comment_list_request_model.dart';
import 'package:mirukuru/features/message_board/data/models/delele_single_photo_request.model.dart';
import 'package:mirukuru/features/message_board/data/models/get_image_request_model.dart';
import 'package:mirukuru/features/message_board/data/models/new_comment_request_model.dart';
import 'package:mirukuru/features/message_board/data/models/own_car_detail_model.dart';
import 'package:mirukuru/features/message_board/data/models/own_car_detail_request_model.dart';
import 'package:mirukuru/features/message_board/data/models/message_board_detail_model.dart';
import 'package:mirukuru/features/message_board/data/models/message_board_detail_request_model.dart';
import 'package:mirukuru/features/message_board/data/models/upload_photo_request_model.dart';
import 'package:mirukuru/features/message_board/presentation/bloc/message_board_bloc.dart';
import 'package:mirukuru/features/message_board/presentation/bloc/message_board_event.dart';
import 'package:mirukuru/features/message_board/presentation/bloc/message_board_state.dart';
import 'package:mirukuru/features/message_board/presentation/widgets/flexible_car_info_header.dart';
import 'package:mirukuru/features/message_board/presentation/widgets/widget_size.dart';
import 'package:mirukuru/features/quotation/presentation/models/inquiry_type_enum.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mirukuru/features/search_list/data/models/item_search_model.dart';
import 'package:path/path.dart' as path;

import '../../../../core/widgets/common/show_and_pickup_photo_view.dart';
import 'message_board_item.dart';

class MessageBoardPage extends StatefulWidget {
  final int kubunId;
  final int questionKbn;
  final String exhNum;
  final int userCarNum;
  final String questionDate;
  final String question;
  final String makerName;
  final String carName;

  MessageBoardPage({
    required this.kubunId,
    required this.questionKbn,
    required this.exhNum,
    required this.questionDate,
    required this.question,
    required this.userCarNum,
    required this.makerName,
    required this.carName,
  });

  @override
  _MessageBoardState createState() => _MessageBoardState();
}

class _MessageBoardState extends State<MessageBoardPage> {
  LoginModel loginModel = LoginModel();
  ScrollController scroll = ScrollController();
  late TextEditingController commentEditingController = TextEditingController();

  late InquiryTypeEnum inquiryType;
  MessageBoardDetailModel messageBoardDetail = MessageBoardDetailModel();
  List<MessageDataItem> inquiryHistoryList = [];
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    classifyMessageBoardDetailViewMode();
    getLoginModel();
    loadMessageBoard();
  }

  void classifyMessageBoardDetailViewMode() {
    inquiryType = InquiryTypeExtension.classifyInquiryType(
            widget.kubunId, widget.questionKbn)
        .getOrElse(() => InquiryTypeEnum.OTHERS_ADDITIONAL_INQUIRIES);
  }

  void loadMessageBoard() async {
    var memberNum = await UserSecureStorage.instance.getMemberNum() ?? '';
    var userNum =
        int.tryParse(await UserSecureStorage.instance.getUserNum() ?? '') ?? -1;

    var messageBoardDetailRequest = MessageBoardDetailRequestModel(
        commentListRequestModel: CommentListRequestModel(
            memberNum: memberNum,
            userNum: userNum,
            exhNum: widget.exhNum,
            id: widget.kubunId.toString(),
            questionKbn: widget.questionKbn,
            userCarNum: widget.userCarNum.toString()),
        asnetCarDetailRequestModel:
            inquiryType.mode == MessageBoardViewMode.MITUMORI
                ? AsnetCarDetailRequestModel(
                    carNo: widget.exhNum, memberNum: memberNum)
                : null,
        ownCarDetailRequestModel:
            (inquiryType.mode == MessageBoardViewMode.SATEI_IRAI)
                ? OwnCarDetailRequestModel(
                    memberNum: memberNum,
                    userNum: userNum.toString(),
                    userCarNum: widget.userCarNum.toString(),
                  )
                : null,
        getImageRequestModel:
            inquiryType.mode == MessageBoardViewMode.SATEI_IRAI
                ? GetImageRequestModel(
                    memberNum: memberNum,
                    userNum: userNum.toString(),
                    userCarNum: widget.userCarNum.toString(),
                    upKind: inquiryType.upKind?.toString() ?? "")
                : null);

    context
        .read<MessageBoardBloc>()
        .add(MessageBoardInit(messageBoardDetailRequest));
  }

  void getLoginModel() async {
    var localLoginModel = await HelperFunction.instance.getLoginModel();
    setState(() {
      loginModel = localLoginModel;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TemplatePage(
      appBarLogo: loginModel.logoMark.isEmpty
          ? ''
          : '${Common.imageUrl + loginModel.memberNum + '/' + loginModel.logoMark}',
      appBarTitle: inquiryType.title ?? "",
      storeName: loginModel.storeName2.isNotEmpty
          ? '${loginModel.storeName}\n${loginModel.storeName2}'
          : loginModel.storeName,
      hasMenuBar: false,
      appBarColor: ResourceColors.color_FF1979FF,
      currentIndex: Constants.INQUIRY_INDEX,
      body: BlocListener<MessageBoardBloc, MessageBoardState>(
        listener: (context, state) async {
          if (state is Loading) {
            await EasyLoading.show();
          }

          if (state is Error) {
            await CommonDialog.displayDialog(context, state.messageCode,
                eventCallBack: () {
              if (state.messageCode == '5MA015SE') {
                Navigator.pop(context);
              }
            }, state.messageContent, false);
          }

          if (state is TimeOut) {
            await CommonDialog.displayDialog(
              context,
              state.messageCode,
              state.messageContent,
              false,
            );

            Navigator.of(context)
                .pushNamedAndRemoveUntil(AppRoutes.loginPage, (route) => false);
          }

          if (state is SentComment) {
            await CommonDialog.displayDialog(
              context,
              "",
              "REGISTERED_COMMENT".tr(),
              true,
              eventCallBack: () => Navigator.of(context).pop(true),
            );
          }

          if (state is CarRemoved) {
            await CommonDialog.displayDialog(context, '', state.messageContent,
                eventCallBack: () {
              Navigator.pop(context);
            }, false);
          }

          if (!(state is Loading) && EasyLoading.isShow) {
            await EasyLoading.dismiss();
          }
        },
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return BlocBuilder<MessageBoardBloc, MessageBoardState>(
      builder: (context, state) {
        if (!(state is Loading) && EasyLoading.isShow) {
          EasyLoading.dismiss();
        }

        if (state is Loaded) {
          if (messageBoardDetail != state.messageBoardDetailModel) {
            messageBoardDetail = state.messageBoardDetailModel;

            if (messageBoardDetail.commentList != null) {
              inquiryHistoryList =
                  MessageDataItem.convertFrom(messageBoardDetail.commentList!);
            }

            if (messageBoardDetail.asnetCarDetailModel != null) {
              isFavorite = context.read<MessageBoardBloc>().isFavorite;
            }

            if (messageBoardDetail.images != null &&
                messageBoardDetail.images!.isNotEmpty) {
              context.read<MessageBoardBloc>().existingPhotoList =
                  PhotoData.convertFrom(
                      state.messageBoardDetailModel.images ?? []);
            }
          }

          // EasyLoading.dismiss();
        }

        if (state is FavoriteUpdated) {
          isFavorite = state.isChecked;
        }

        return Container(
          color: ResourceColors.color_FFFFFF,
          child: Stack(
            children: [
              _buildCarInfoAndMessageBoard(),
              Container(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    decoration: _buildBoxDecoration(),
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: _buildListButtonBottom(),
                    ),
                  )
                ],
              )),
            ],
          ),
        );
      },
    );
  }

  _buildListButtonBottom() {
    return Row(
      children: [
        _buildInput(commentEditingController, isTypeNumber: false),
        SizedBox(
          width: Dimens.getWidth(10.0),
        ),
        IconButton(
            iconSize: Dimens.getWidth(45.0),
            onPressed: _handlePostNewComment,
            icon: Image.asset(
              "assets/images/png/next_icon.png",
              width: Dimens.getWidth(45.0),
              height: Dimens.getWidth(45.0),
            ))
      ],
    );
  }

  void _handlePostNewComment() async {
    var comment = commentEditingController.text;
    if (comment.isEmpty) {
      CommonDialog.displayDialog(
        context,
        "",
        "EMPTY_COMMENT".tr(),
        true,
        eventCallBack: () {},
      );
    } else {
      // unfocus all element (tetxInput,...)
      FocusScope.of(context).unfocus();

      var memberNum = await UserSecureStorage.instance.getMemberNum() ?? '';
      var userNum =
          int.tryParse(await UserSecureStorage.instance.getUserNum() ?? '') ??
              -1;

      var newCommentRequestModel = NewCommentRequestModel(
          memberNum: memberNum,
          userNum: userNum,
          id: widget.kubunId,
          exhNum: widget.exhNum,
          userCarNum: widget.userCarNum,
          questionKbn: widget.questionKbn,
          question: comment);

      if (InquiryTypeExtension.getOtherTypeInquiryListData()
          .contains(inquiryType)) {
        var uploadPhotoList = context.read<MessageBoardBloc>().uploadPhotoList;

        PhotoUploadRequestModel? uploadPhotoRequest;
        if (uploadPhotoList.isNotEmpty) {
          var xFileList = await ImageHelper.ImageUtil.instance
              .resizeMultiImage(uploadPhotoList);

          uploadPhotoRequest = PhotoUploadRequestModel(
            memberNum: memberNum,
            userNum: userNum,
            userCarNum: widget.userCarNum,
            upKind: inquiryType.upKind?.toString() ?? "",
            files: xFileList,
          );
        }

        var deletePhotoList = context.read<MessageBoardBloc>().deletePhotoList;
        List<DeleteSinglePhotoRequestModel>? deleteRemotePhotoRequest;
        if (deletePhotoList.isNotEmpty) {
          deleteRemotePhotoRequest = deletePhotoList.map((e) {
            var imageUrl = e.photo as String;
            var imageName = path.basename(File(imageUrl).path);

            return DeleteSinglePhotoRequestModel(
                memberNum: memberNum,
                userNum: userNum.toString(),
                userCarNum: widget.userCarNum.toString(),
                upKind: inquiryType.upKind?.toString() ?? "",
                imgName: imageName);
          }).toList();
        }

        context.read<MessageBoardBloc>().add(MessageBoardSendComment(
            request: newCommentRequestModel,
            deleteRemotePhotoRequest: deleteRemotePhotoRequest,
            uploadPhotoRequestModel: uploadPhotoRequest));
      } else {
        context
            .read<MessageBoardBloc>()
            .add(MessageBoardSendComment(request: newCommentRequestModel));
      }
    }
  }

  Widget _buildInput(TextEditingController inputValue,
      {String hintInput = '',
      int? maxLength,
      bool isTypeNumber = true,
      bool obscureText = false}) {
    return Flexible(
      child: TextField(
        textInputAction: TextInputAction.next,
        keyboardType: isTypeNumber ? TextInputType.number : TextInputType.text,
        maxLength: maxLength,
        obscureText: obscureText,
        style: MKStyle.t14R,
        decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide:
                  BorderSide(width: 1, color: ResourceColors.color_929292),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide:
                  BorderSide(width: 1, color: ResourceColors.color_929292),
            ),
            hintText: hintInput,
            isDense: true,
            contentPadding: EdgeInsets.all(8),
            hintStyle: _buildHintTextStyle(),
            counterText: ''),
        controller: inputValue,
      ),
    );
  }

  TextStyle _buildHintTextStyle() {
    return MKStyle.t14R.copyWith(color: ResourceColors.text_grey);
  }

  BoxDecoration _buildBoxDecoration() {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [
          const Color(0xFFFDFEFF),
          const Color(0xFFEEF9FF),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    );
  }

  ScrollController _parentScrollController = ScrollController();
  ScrollController _childScrollController = ScrollController();

  ValueNotifier<double> previousPhotoSectionHeight = ValueNotifier(0.0);
  ValueNotifier<double> currentPhotoSectionHeight = ValueNotifier(0.0);
  ValueNotifier<double> carInfoSectionHeight = ValueNotifier(0.0);

  Widget _buildCarInfoAndMessageBoard() {
    double calcPhotoExtent() {
      var photoSectionHeight = -(MediaQuery.of(context).size.height / 5.8);

      if (context.read<MessageBoardBloc>().existingPhotoList.isNotEmpty) {
        previousPhotoSectionHeight.value = photoSectionHeight;
        return photoSectionHeight.abs();
      } else {
        if (previousPhotoSectionHeight.value == photoSectionHeight.abs()) {
          previousPhotoSectionHeight.value = photoSectionHeight.abs();
          return photoSectionHeight;
        } else {
          return 0.0;
        }
      }
    }

    calcCarInfoSectionExtentExactly() {
      if (carInfoSectionHeight.value == 0) {
        context.read<MessageBoardBloc>().add(MessageBoardUpdatePhoto());
      }

      var carInfoHeaderHeight;
      if (inquiryType.mode == MessageBoardViewMode.SATEI_IRAI &&
          messageBoardDetail.ownCarDetailModel != null &&
          !(messageBoardDetail.ownCarDetailModel
              is OwnCarDetailUndefinedModel)) {
        var buttonHeight = MediaQuery.of(context).size.height * 0.08;
        carInfoHeaderHeight =
            carInfoSectionHeight.value + calcPhotoExtent() + buttonHeight;
      } else {
        carInfoHeaderHeight = carInfoSectionHeight.value;
      }

      return FlexibleExtent(
          minExtent: 0.0,
          maxExtent: carInfoHeaderHeight + Dimens.getHeight(5.0));
    }

    var expandedChild = SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: Column(
        children: [
          Visibility(
              visible: inquiryType.mode == MessageBoardViewMode.MITUMORI,
              child: _buildMitumoriContent()),
          Visibility(
            visible: inquiryType.mode == MessageBoardViewMode.SATEI_IRAI &&
                messageBoardDetail.ownCarDetailModel != null &&
                widget.kubunId == 4 &&
                !(messageBoardDetail.ownCarDetailModel
                    is OwnCarDetailUndefinedModel),
            child: _buildSateiIraiContent(),
          ),
          SizedBox(
            height: Dimens.getHeight(5.0),
          ),
          Visibility(
              visible: inquiryType.mode == MessageBoardViewMode.SATEI_IRAI &&
                  messageBoardDetail.ownCarDetailModel != null &&
                  !(messageBoardDetail.ownCarDetailModel
                      is OwnCarDetailUndefinedModel),
              child: _buildButtonPickupAPhoto()),
        ],
      ),
    );

    var extent = calcCarInfoSectionExtentExactly();

    return NestedScrollView(
        controller: _parentScrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverPersistentHeader(
                pinned: true,
                delegate: FlexibleCarInfoHeader(context, expandedChild, extent))
          ];
        },
        body: Stack(
          fit: StackFit.loose,
          children: [
            SubTitle(
                label: "INQUIRY_HISTORY".tr(),
                textStyle:
                    MKStyle.t14R.copyWith(color: ResourceColors.color_333333)),
            _buildMessageBoard()
          ],
        ));
  }

  Widget _buildMessageBoard() {
    return Container(
      margin: EdgeInsets.only(
          top: Dimens.getHeight(30.0),
          left: Dimens.getWidth(5.0),
          right: Dimens.getWidth(5.0),
          bottom: Dimens.getHeight(60.0)),
      color: Colors.white,
      child: NotificationListener(
        onNotification: (notification) {
          if (notification is ScrollUpdateNotification) {
            if (notification.metrics.pixels ==
                notification.metrics.minScrollExtent) {
              _parentScrollController.animateTo(
                  _parentScrollController.position.minScrollExtent,
                  duration: Duration(milliseconds: 1000),
                  curve: Curves.decelerate);
            } else if (notification.metrics.pixels >=
                ScreenUtil.getScreenW(context) / 2.0) {
              double offset = notification.metrics.pixels;
              _parentScrollController.animateTo(offset,
                  duration: Duration(milliseconds: 1000),
                  curve: Curves.decelerate);
            }
          }
          return true;
        },
        child: ListViewWidget(
            countTotalListData: inquiryHistoryList.length,
            scrollDirection: Axis.vertical,
            scrollController: _childScrollController,
            rowEventCallBack: (int index) => _buildInquiryItem(index)),
      ),
    );
  }

  late GlobalKey _ownCarInfoKey = GlobalKey();
  late GlobalKey _asnetCarInfoKey = GlobalKey();
  late GlobalKey _showAndPickImageViewKey = GlobalKey();

  _buildMitumoriContent() {
    var itemSearchModel =
        ItemSearchModel.convertFrom(messageBoardDetail.asnetCarDetailModel);
    return WidgetSize(
      key: _asnetCarInfoKey,
      onSizeChanged: (size) {
        carInfoSectionHeight.value = size?.height ?? 0.0;
      },
      child: TemplatePattern1(
        isFavorite: isFavorite,
        value: true,
        isShowbottomUI: false,
        itemTemPlate: itemSearchModel,
        isShowCheckBox: false,
        typeButton: 1,
        favoriteCallBack: (bool isFavorite) {
          context
              .read<MessageBoardBloc>()
              .add(MessageBoardFavoriteClicked(itemSearchModel));
        },
      ),
    );
  }

  _buildSateiIraiContent() {
    return WidgetSize(
      key: _ownCarInfoKey,
      onSizeChanged: (size) {
        carInfoSectionHeight.value = size?.height ?? 0.0;
      },
      child: Column(
        children: [
          SubTitle(
            label: "VIEW_CAR_INFORMATION".tr(),
            textStyle:
                MKStyle.t14R.copyWith(color: ResourceColors.color_333333),
          ),
          Padding(
            padding: EdgeInsets.only(
                left: Dimens.getWidth(10.0), bottom: Dimens.getWidth(5.0)),
            child: Align(
                alignment: Alignment.centerLeft,
                child: TextWidget(
                  label: OwnCarDetailModel.displayName(
                      widget.makerName,
                      widget.carName,
                      messageBoardDetail.ownCarDetailModel?.carGrade ?? ""),
                  textStyle: MKStyle.t14R,
                )),
          ),
          _buildRowInfo(
              title1: "MODEL_YEAR".tr(),
              value1: OwnCarDetailModel.displayCarModel(
                  messageBoardDetail.ownCarDetailModel?.carModel ?? ""),
              title2: "INSPECTION_EXPIRARION".tr(),
              value2: messageBoardDetail.ownCarDetailModel != null
                  ? HelperFunction.instance.formatJapanDateString(
                      messageBoardDetail.ownCarDetailModel?.inspectionDate)
                  : ""),
          _buildRowInfo(
              title1: "COLOR".tr(),
              value1: messageBoardDetail.ownCarDetailModel?.colorName ?? "",
              title2: "MILEAGE".tr(),
              value2: OwnCarDetailModel.displayMileage(
                  messageBoardDetail.ownCarDetailModel?.mileage)),
        ],
      ),
    );
  }

  Widget _buildButtonPickupAPhoto() => WidgetSize(
        key: _showAndPickImageViewKey,
        onSizeChanged: (size) {
          currentPhotoSectionHeight.value = size?.height ?? 0.0;
        },
        child: ShowAndPickupPhotoView(
          context: context,
          onPhotoDeleted: (deletePhotoDataList) {
            context.read<MessageBoardBloc>().deletePhotoList =
                deletePhotoDataList;
          },
          onPhotoSelected: (uploadPhotoDataList) {
            context.read<MessageBoardBloc>().uploadPhotoList =
                uploadPhotoDataList;
          },
          photos: context.read<MessageBoardBloc>().existingPhotoList,
        ),
      );

  _buildRowInfo(
      {String title1 = '',
      String value1 = '',
      String title2 = '',
      String value2 = ''}) {
    return Padding(
      padding: EdgeInsets.only(left: Dimens.getWidth(10.0)),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: TextWidget(
              label: title1,
              textStyle: MKStyle.t8R.copyWith(color: ResourceColors.color_70),
            ),
          ),
          Expanded(
            flex: 3,
            child: TextWidget(label: value1, textStyle: MKStyle.t14R),
          ),
          SizedBox(
            width: Dimens.getWidth(20.0),
          ),
          Expanded(
            flex: 2,
            child: TextWidget(
              label: title2,
              textStyle: MKStyle.t8R.copyWith(color: ResourceColors.color_70),
            ),
          ),
          Expanded(
            flex: 7,
            child: TextWidget(
              label: value2,
              textStyle: MKStyle.t14R,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInquiryItem(int index) {
    return MessageBoardItem(
      key: GlobalKey(debugLabel: index.toString()),
      item: inquiryHistoryList.elementAt(index),
    );
  }
}
