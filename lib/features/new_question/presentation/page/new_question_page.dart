import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mirukuru/core/resources/core_resource.dart';
import 'package:mirukuru/core/util/core_util.dart';
import 'package:mirukuru/core/widgets/common/template_page.dart';
import 'package:mirukuru/core/widgets/common/text_widget.dart';
import 'package:mirukuru/features/new_question/data/models/new_question_model.dart';
import '../../../../core/config/common.dart';
import '../../../../core/db/name_bean_hive.dart';
import '../../../../core/secure_storage/user_secure_storage.dart';
import 'package:mirukuru/core/util/image_util.dart' as ImageHelper;
import '../../../../core/widgets/common/custom_text_field_note.dart';
import '../../../../core/widgets/common/show_and_pickup_photo_view.dart';
import '../../../../core/widgets/common/sub_title_widget.dart';
import '../../../../core/widgets/dialog/common_dialog.dart';
import '../../../../core/widgets/row_widget/row_widget_pattern_6_new.dart';
import '../../../login/data/models/login_model.dart';
import '../../../menu_widget_test/pages/button_widget.dart';
import '../../../my_page/data/models/user_car_name_model.dart';
import '../../data/models/new_question_request.dart';
import '../../data/models/user_info_request_model.dart';
import '../bloc/new_question_bloc.dart';

class NewQuestionPage extends StatefulWidget {
  const NewQuestionPage({Key? key}) : super(key: key);

  @override
  State<NewQuestionPage> createState() => _NewQuestionPageState();
}

class _NewQuestionPageState extends State<NewQuestionPage> {
  /// To load logo and scroll bar
  LoginModel _loginModel = LoginModel();
  String _buildAppBarLogo(LoginModel loginModel) {
    return loginModel.logoMark.isEmpty
        ? ''
        : '${Common.imageUrl + loginModel.memberNum + '/' + loginModel.logoMark}';
  }

  ScrollController _scrollController = ScrollController();

  /// Load user info from data local
  late String memberNum;
  late String userNum;

  /// Load value of question for question Kbn dropdown list
  List<NameBeanHive> listQuestionKbn = [];
  int indexSelectedQuestionKbnType = 0;

  /// Current new question request Model
  NewQuestionRequestModel newQuestionRequestModel = NewQuestionRequestModel();

  /// Owner car selected
  List<UserCarNameModel> listOwnerCar = [];
  int indexSelectedOwnerCar = 0;

  /// Text field note
  TextEditingController fieldNoteController = TextEditingController();

  /// Init and update new question request
  updateQuestionRequest(int index) {
    newQuestionRequestModel.userCarNum =
        int.tryParse(listOwnerCar[index].userCarNum ?? "0");
    newQuestionRequestModel.makerCode =
        int.tryParse(listOwnerCar[index].makerCode ?? "0");
    newQuestionRequestModel.makerName = listOwnerCar[index].makerName;
    newQuestionRequestModel.carName = listOwnerCar[index].carGroup;
  }

  @override
  void initState() {
    loadUserInfoData();
    initLocalData();
    getData();
    super.initState();
  }

  initLocalData() {
    context.read<NewQuestionBloc>().add(GetLocalDataEvent());
  }

  void loadUserInfoData() async {
    memberNum = await UserSecureStorage.instance.getMemberNum() ?? '';
    userNum = await UserSecureStorage.instance.getUserNum() ?? '';

    var requestModel = UserInfoRequestModel(
      memberNum: memberNum,
      userNum: int.tryParse(userNum) != null ? int.parse(userNum) : -1,
    );
    context.read<NewQuestionBloc>().add(NewQuestionInitEvent(requestModel));
  }

  void getData() async {
    _loginModel = await HelperFunction.instance.getLoginModel();
    setState(() {});
  }

  initListQuestionKbn() {
    List<NameBeanHive> listQuestionKbnRaw = [];
    listQuestionKbnRaw = listQuestionKbn.where((e) => e.nameKbn == 4).toList();
    listQuestionKbn.clear();
    listQuestionKbn = listQuestionKbnRaw;
  }

  @override
  Widget build(BuildContext context) {
    return TemplatePage(
      appBarLogo: _buildAppBarLogo(_loginModel),
      appBarTitle: "NEW_QUESTION".tr(),
      storeName: _loginModel.storeName2.isNotEmpty
          ? '${_loginModel.storeName}\n${_loginModel.storeName2}'
          : _loginModel.storeName,
      hasMenuBar: true,
      appBarColor: ResourceColors.color_FF1979FF,
      resizeToAvoidBottomInset: true,
      currentIndex: Constants.INQUIRY_INDEX,
      buttonBottom: _buildButtonPost(),
      body: BlocListener<NewQuestionBloc, NewQuestionState>(
        listener: (buildContext, state) async {
          if (state is DeletedOnPhotoSuccessState) {
            /// Case: list photo is empty
            await CommonDialog.displayDialog(
              context,
              "",
              "REGISTERED_COMMENT".tr(),
              true,
              eventCallBack: () => Navigator.of(context).pop(true),
            );
          }

          if (state is Error) {
            await CommonDialog.displayDialog(context, state.errorModel.msgCode,
                eventCallBack: () {
              if (state.errorModel.msgCode == '5MA015SE') {
                Navigator.pop(context);
              }
            }, state.errorModel.msgContent, false);
          }

          if (state is InitLocalData) {
            listQuestionKbn = state.listNameBean;
            initListQuestionKbn();
          }

          if (state is UploadedPhotoState) {
            /// Case: list photo is not empty
            await CommonDialog.displayDialog(
              context,
              "",
              "REGISTERED_COMMENT".tr(),
              true,
              eventCallBack: () => Navigator.of(context).pop(true),
            );
          }

          if (state is LoadedCarListState) {
            if (state.listUserCarNameModel != null &&
                state.listUserCarNameModel!.isNotEmpty) {
              listOwnerCar = state.listUserCarNameModel ?? List.empty();
            } else {
              listOwnerCar.clear();
              listOwnerCar.add(
                UserCarNameModel(
                    userCarNum: "0",
                    makerName: "NO_VEHICLE".tr(),
                    carGroup: ""),
              ); // set maker name and car name
              listQuestionKbn.clear();
              listQuestionKbn
                  .add(NameBeanHive(name: 'OTHERS'.tr(), nameCode: 4));
            }
            updateQuestionRequest(0); // init is first element in list
          }

          if (state is OnSelectDivisionState) {
            indexSelectedQuestionKbnType = state.indexSelectQuestionKbnType;
          }

          if (state is OnSelectOwnerCarState) {
            indexSelectedOwnerCar = state.indexSelectOwnerCar;
            updateQuestionRequest(state
                .indexSelectOwnerCar); // update model when selected dropdown
          }
        },
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return BlocBuilder<NewQuestionBloc, NewQuestionState>(
        buildWhen: (previous, current) {
      if (previous is UpdatedPhotos && current is UpdatedPhotos) {
        return true;
      }
      return previous != current;
    }, builder: (context, state) {
      if (EasyLoading.isShow) {
        EasyLoading.dismiss();
      }

      if (state is Loading) {
        EasyLoading.show();
      }

      return Container(
        color: ResourceColors.color_FFFFFF,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimens.getWidth(10.0)),
          child: _buildMain(),
        ),
      );
    });
  }

  Widget _buildMain() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildSubtitle("VEHICLE_INFORMATION".tr()),
        Expanded(
            child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            _buildDivisionSelect(),
            _buildOwnedCarSelect(),
            _buttonPickupAPhoto(),
            SizedBox(
              height: Dimens.getHeight(32.0),
            ),
            _buildSubtitle("CONTENT_OF_INQUIRY".tr()),
            SizedBox(
              height: Dimens.getHeight(10.0),
            ),
            _buildTextFieldNote(),
            SizedBox(
              height: Dimens.getHeight(12.0),
            ),
          ],
        )),
      ],
    );
  }

  Widget _buttonPickupAPhoto() {
    return ShowAndPickupPhotoView(
      context: context,
      isGridViewTypeDisplay: true,
      onPhotoDeleted: (deletePhotoDataList) {
        context.read<NewQuestionBloc>().deletePhotoList = deletePhotoDataList;
      },
      onPhotoSelected: (uploadPhotoDataList) {
        context.read<NewQuestionBloc>().uploadPhotoList = uploadPhotoDataList;
      },
      photos: context.read<NewQuestionBloc>().existingPhotoList,
    );
  }

  Widget _buildSubtitle(String subTitle) {
    return SubTitle(
      label: subTitle,
      textStyle: MKStyle.t14R.copyWith(
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildButtonPost() {
    return ButtonWidget(
      content: 'SEND_QUESTION'.tr(),
      bgdColor: ResourceColors.color_0FA4EA,
      borderRadius: Dimens.getWidth(20.0),
      width: MediaQuery.of(context).size.width / 2.2,
      textStyle: MKStyle.t14R.copyWith(
        color: ResourceColors.color_white,
        fontWeight: FontWeight.w400,
      ),
      heightText: 1.2,
      clickButtonCallBack: postNewQuestion,
    );
  }

  Widget _buildDivisionSelect() {
    var firstValue = listQuestionKbn.isNotEmpty
        ? listQuestionKbn[indexSelectedQuestionKbnType].name ??
            Constants.OTHER_STATUS
        : Constants.OTHER_STATUS;

    checkHidden() {
      if (firstValue == Constants.OTHER_STATUS && listQuestionKbn.length == 1) {
        return true;
      } else {
        return false;
      }
    }

    var listNameQuestionKbn = listQuestionKbn.map((e) => e.name).toList();

    return RowWidgetPattern6New(
      textStr: "DIVISION".tr(),
      value: firstValue,
      isHidden: checkHidden(),
      typeScreen: Constants.MY_PAGE_SCREEN,
      typePattern: 7,
      btnCallBack: () async {
        await CommonDialog.displaySingleColumnPicker(
          context,
          listNameQuestionKbn,
          listNameQuestionKbn.indexOf(firstValue),
          (value) {
            indexSelectedQuestionKbnType = listNameQuestionKbn.indexOf(value);

            context
                .read<NewQuestionBloc>()
                .add(OnSelectDivisionEvent(indexSelectedQuestionKbnType));
          },
        );
      },
    );
  }

  Widget _buildOwnedCarSelect() {
    String firstValue = listOwnerCar.isNotEmpty
        ? listOwnerCar[indexSelectedOwnerCar].displayUserCarName()
        : "NO_VEHICLE".tr();

    var listCar = listOwnerCar.map((e) => e.displayUserCarName()).toList();

    return RowWidgetPattern6New(
      textStr: "OWNED_CAR".tr(),
      value: firstValue,
      typeScreen: Constants.MY_PAGE_SCREEN,
      isHidden: firstValue == "NO_VEHICLE".tr() ? true : false,
      typePattern: 7,
      btnCallBack: () async {
        await CommonDialog.displaySingleColumnPicker(
          context,
          listCar,
          listCar.indexOf(firstValue),
          (value) {
            context
                .read<NewQuestionBloc>()
                .add(OnSelectOwnerCarEvent(listCar.indexOf(value)));
          },
        );
      },
    );
  }

  validateForm(Function nextAction) async {
    var errorComment = [];

    if (listQuestionKbn.contains(NameBeanHive(name: "UNSPECIFIED".tr()))) {
      errorComment.add("PLEASE_SELECT_A_SEGMENT".tr());
    }

    if (fieldNoteController.text.isEmpty) {
      errorComment.add("PLEASE_ENTER_A_COMMENT".tr());
    }

    if (errorComment.isNotEmpty) {
      CommonDialog.displayDialog(
        context,
        "",
        errorComment.join("\n"),
        true,
        eventCallBack: () {},
      );
    } else {
      nextAction.call();
    }
  }

  /// Build button to send a new question
  postNewQuestion() async {
    var kubun = listQuestionKbn[indexSelectedQuestionKbnType].nameCode ?? 0;

    var makerCd =
        newQuestionRequestModel.makerCode == 0 // int.parse(param != null -> 0)
            ? null
            : newQuestionRequestModel.makerCode;

    var makerNm =
        newQuestionRequestModel.makerCode == 0 // int.parse(param != null -> 0)
            ? null
            : newQuestionRequestModel.makerName;

    var carNm =
        newQuestionRequestModel.makerCode == 0 // int.parse(param != null -> 0)
            ? null
            : newQuestionRequestModel.carName;

    List<PhotoData> _mListPhoto =
        context.read<NewQuestionBloc>().existingPhotoList;

    List<XFile?>? xFileList;
    if (_mListPhoto.isNotEmpty) {
      xFileList =
          await ImageHelper.ImageUtil.instance.resizeMultiImage(_mListPhoto);
    }

    var newQuestionRequest = NewQuestionModel(
      memberNum: memberNum,
      userNum: int.tryParse(userNum) != null ? int.parse(userNum) : -1,
      exhNum: "", // exhNum undefined so default is ""
      userCarNum: newQuestionRequestModel.userCarNum,
      makerCode: makerCd,
      makerName: makerNm,
      carName: carNm,
      id: 5, // kubun_id is 5 to select other division
      question: fieldNoteController.text.tr(),
      questionKbn: kubun.toString(),
      upKind: (kubun + 2).toString(),
      files: xFileList,
    );

    validateForm(() => {
          context
              .read<NewQuestionBloc>()
              .add(PostNewQuestionEvent(newQuestionRequest))
        });
  }

  Widget _buildTextFieldNote() {
    final maxLines = 5;
    return Padding(
      padding: EdgeInsets.only(
        left: Dimens.getHeight(10.0),
        right: Dimens.getHeight(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextFieldNote(
            maxLines: maxLines,
            fieldNoteController: fieldNoteController,
            maxLength: 500,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: TextWidget(
              label: "VALIDATE_INPUT_500".tr(),
              textStyle: MKStyle.t10R,
            ),
          ),
        ],
      ),
    );
  }
}
