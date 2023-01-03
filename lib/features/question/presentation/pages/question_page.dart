import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mirukuru/core/config/common.dart';
import 'package:mirukuru/core/resources/core_resource.dart';
import 'package:mirukuru/core/secure_storage/user_secure_storage.dart';
import 'package:mirukuru/core/util/core_util.dart';
import 'package:mirukuru/core/widgets/common/slide_widget.dart';
import 'package:mirukuru/core/widgets/common/text_widget.dart';
import 'package:mirukuru/core/widgets/core_widget.dart';
import 'package:mirukuru/features/carlist/presentation/listview_question_widget.dart';
import 'package:mirukuru/features/login/data/models/login_model.dart';
import 'package:mirukuru/features/menu_widget_test/pages/button_widget.dart';
import 'package:mirukuru/features/question/data/models/delete_question_param.dart';
import 'package:mirukuru/features/question/data/models/query_list_bean.dart';
import 'package:mirukuru/features/question/data/models/question_bean.dart';
import 'package:mirukuru/features/question/data/models/question_bean_param.dart';
import 'package:mirukuru/features/question/presentation/bloc/question_bloc.dart';
import 'package:mirukuru/features/question/presentation/bloc/question_event.dart';
import 'package:mirukuru/features/question/presentation/bloc/question_state.dart';

class QuestionPage extends StatefulWidget {
  QuestionPage();

  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  LoginModel loginModel = LoginModel();
  bool? isShowDeleteIcon;

  List<String> itemCheckedValue = [];

  bool isSort = false; // ソートの結果、データがなかった場合にメッセージを表示するためのフラグ
  //int sortId = 0;     // 問い合わせリストのソートId
  int sortId = 0; // 問い合わせリストのソートId
  int backSortId = 0; // 前回のソートId
  List<QuestionBean> questionList = []; // １問い合わせの詳細リスト？

  @override
  void initState() {
    super.initState();
    getLoginModel();
    callApiGetQuestionList();
  }

  callApiGetQuestionList({bool forceRefresh = false}) async {
    var memberNum = await UserSecureStorage.instance.getMemberNum() ?? '';
    var userNum = await UserSecureStorage.instance.getUserNum() ?? '';

    if (forceRefresh) {
      questionList.clear();
      context.read<QuestionBloc>().resetPaginatedDataParams();
    }

    context.read<QuestionBloc>().add(LoadQuestions(
        questionBeanParam: QuestionBeanParam(
            userNum: int.parse(userNum),
            memberNum: memberNum,
            sortId: sortId)));
  }

  @override
  Widget build(BuildContext context) {
    return TemplatePage(
      isHiddenLeadingPop: true,
      appBarLogo: loginModel.logoMark.isEmpty
          ? ''
          : '${Common.imageUrl + loginModel.memberNum + '/' + loginModel.logoMark}',
      appBarTitle: "QUESTION_PAGE".tr(),
      storeName: loginModel.storeName2.isNotEmpty
          ? '${loginModel.storeName}\n${loginModel.storeName2}'
          : loginModel.storeName,
      hasMenuBar: true,
      appBarColor: ResourceColors.color_FF1979FF,
      currentIndex: Constants.INQUIRY_INDEX,
      buttonBottom: _buildButtonNewQuestion(),
      body: BlocListener<QuestionBloc, QuestionState>(
        listener: (context, questionState) async {
          if (questionState is Error) {
            await CommonDialog.displayDialog(context, questionState.messageCode,
                questionState.messageContent, false);
          }
          if (questionState is TimeOut) {
            await CommonDialog.displayDialog(context, questionState.messageCode,
                questionState.messageContent, false);

            Navigator.of(context)
                .pushNamedAndRemoveUntil(AppRoutes.loginPage, (route) => false);
          }
          if (questionState is Loading && questionList.isEmpty) {
            await EasyLoading.show();
          }

          if (questionState is QuestionListState) {
            if (questionState.result.length == 0 && isSort) {
              sortId = backSortId;
              showConfirmOk();
            } else if (questionState.result.length == 0) {
              // 初回読み込み時 何も処理しない。
            } else {
              //　前回のソートを記録しておく
              backSortId = sortId;
              appendDataListView(context.read<QuestionBloc>().data);
            }
          }

          if (questionState is DeleteQuestionState) {
            isSort = false;

            questionState.deletedQuestions.forEach((deletedQuestion) {
              questionList.removeWhere((element) =>
                  element.id.toString().trim() == deletedQuestion.id &&
                  element.questionNum.toString().trim() ==
                      deletedQuestion.questionNum);
              setState(() {});
            });
            await CommonDialog.displayDialog(
              context,
              '',
              eventCallBack: () async {
                isShowDeleteIcon = true;
                setState(() {});
              },
              'SUCCESSFULLY_DELETED'.tr(),
              false,
            );
          }
        },
        child: _buildBody(),
      ),
    );
  }

  void getLoginModel() async {
    var localLoginModel = await HelperFunction.instance.getLoginModel();
    setState(() {
      loginModel = localLoginModel;
    });
  }

  Widget _buildBody() {
    return BlocBuilder<QuestionBloc, QuestionState>(
      builder: (context, state) {
        if (EasyLoading.isShow) {
          EasyLoading.dismiss();
        }

        if (state is Loading && questionList.isEmpty) {
          EasyLoading.show();
        }

        return Column(
          children: [
            _buildTop(),
            Expanded(child: _buildListQuestion()),
          ],
        );
      },
    );
  }

  void appendDataListView(List<QuestionBean> nextPageData) {
    setState(() {
      questionList.addAll(nextPageData);
    });
  }

  Widget _buildListQuestion() {
    return ListViewQuestionWidget(
      initItemChecked: itemCheckedValue,
      listData: questionList.map((e) => QueryListBean.convertFrom(e)).toList(),
      isShowDeleteIcon: isShowDeleteIcon != null ? !isShowDeleteIcon! : false,
      callBackItemChecked: (List<String> itemChecked) {
        itemCheckedValue = itemChecked;
      },
      onItemClick: (int index) async {
        var flag = await Navigator.of(context)
            .pushNamed(AppRoutes.messageBoardPage, arguments: {
          "KubunId": questionList[index].id,
          "QuestionKbn": questionList[index].questionKbn,
          "ExhNum": questionList[index].exhNum,
          "UserCarNum": questionList[index].userCarNum,
          "QuestionDate": questionList[index].questionDate,
          "Question": questionList[index].question,
          "MakerName": questionList[index].asMakerName,
          "CarName": questionList[index].asnetCarName
        });

        if (!mounted) {
          return;
        }

        if (flag != null) {
          flag as bool;

          if (flag) {
            callApiGetQuestionList(forceRefresh: true);
          }
        }
      },
      isEndList: !context.read<QuestionBloc>().hasMoreData,
      totalItemsCount: context.read<QuestionBloc>().totalCount,
      loadMorePageCallback: () {
        context.read<QuestionBloc>().add(LoadQuestions(
            questionBeanParam: context.read<QuestionBloc>().getQuestionParam));
      },
    );
  }

  _buildButtonNewQuestion() {
    return Visibility(
        visible: true,
        child: Center(
          child: ButtonWidget(
            width: MediaQuery.of(context).size.width / 2,
            content: "NEW_QUESTION".tr(),
            borderRadius: 30.0,
            clickButtonCallBack: () async {
              var flag =
                  await Navigator.of(context).pushNamed(AppRoutes.newQuestion);

              if (flag != null) {
                flag as bool;

                if (flag) {
                  sortId = 0;
                  callApiGetQuestionList(forceRefresh: true);
                }
              }
            },
            bgdColor: ResourceColors.color_FF0FA4EA,
            borderColor: ResourceColors.color_FF4BC9FD,
            textStyle:
                MKStyle.t14R.copyWith(color: ResourceColors.color_FFFFFF),
            heightText: 1.2,
          ),
        ));
  }

  _buildTop() {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        color: ResourceColors.color_E1E1E1,
        height: Dimens.getWidth(40.0),
        padding: EdgeInsets.only(right: Dimens.getWidth(10.0)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(left: Dimens.getWidth(15.0)),
              child: TextWidget(
                label: "LIST_QUESTION".tr(),
                textStyle:
                    MKStyle.t12R.copyWith(color: ResourceColors.color_757575),
              ),
            ),
            HidableActionsWidget(
              child: Row(
                children: [
                  _buildSortOrder(),
                  SizedBox(
                    width: Dimens.getWidth(5.0),
                  ),
                  _buildEdit(),
                  _buildDelete(),
                ],
              ),
              slideOffset: Offset(0.36, 0.0),
              isHiding: isShowDeleteIcon != null ? isShowDeleteIcon! : true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDelete() {
    return Padding(
      padding: EdgeInsets.only(
          left: Dimens.getWidth(
              (isShowDeleteIcon != null && isShowDeleteIcon!) ? 0.0 : 5.0)),
      child: InkWell(
        onTap: () async {
          if (itemCheckedValue.length > 0) {
            showConfirmDeleteItemsDialog();
          }
        },
        child: Image.asset(
          "assets/images/png/delete.png",
          width: DimenFont.sp25,
          height: DimenFont.sp25,
        ),
      ),
    );
  }

  Widget _buildEdit() {
    return InkWell(
      onTap: () {
        setState(() {
          isShowDeleteIcon = !(isShowDeleteIcon ?? true);
        });
      },
      child: Image.asset(
        "assets/images/png/edit.png",
        width: DimenFont.sp25,
        height: DimenFont.sp25,
      ),
    );
  }

  Widget _buildSortOrder() {
    return InkWell(
      onTap: () async {
        if ((isShowDeleteIcon ?? true) != false) {
          await CommonDialog.displaySingleColumnPicker(
              context, QuestionPageValues.itemsSortOrder, sortId, (value) {
            String selectedOption = value;
            Logging.log.info("selectedSortOption: $selectedOption");
            setState(() {
              isSort = true;
              sortId =
                  QuestionPageValues.itemsSortOrder.indexOf(selectedOption);
              if (backSortId != sortId) {
                callApiGetQuestionList(forceRefresh: true);
              }
            });
          });
        }
      },
      child: Image.asset(
        "assets/images/png/sortOrder.png",
        width: DimenFont.sp25,
        height: DimenFont.sp25,
      ),
    );
  }

  showConfirmOk() async {
    await CommonDialog.displayConfirmOneButtonDialog(
      context,
      TextWidget(
        label: "NO_DATA_EXISTED".tr(),
        textStyle: MKStyle.t14R,
        alignment: TextAlign.start,
      ),
      'OK',
      "OK".tr(),
      okEvent: () async {
        queryDelete();
        setState(() {});
      },
      cancelEvent: () {},
    );
  }

  showConfirmDeleteItemsDialog() async {
    await CommonDialog.displayConfirmDialog(
      context,
      TextWidget(
        label: "DELETE_QUESTION_SELECTED".tr(),
        textStyle: MKStyle.t14R,
        alignment: TextAlign.start,
      ),
      'DELETE'.tr(),
      "CANCEL".tr(),
      okEvent: () async {
        queryDelete();
      },
      cancelEvent: () {},
    );
  }

  queryDelete() async {
    var memberNum = await UserSecureStorage.instance.getMemberNum() ?? '';
    var userNum = await UserSecureStorage.instance.getUserNum() ?? '';
    List<String> nums = [];
    List<String> ids = [];

    itemCheckedValue.forEach((element) {
      var split = element.split(',');
      ids.add(split[0]);
      nums.add(split[1]);
    });

    context.read<QuestionBloc>().add(DeleteQuestionInit(
        DeleteQuestionParam(
            memberNum: memberNum,
            userNum: int.parse(userNum),
            ids: ids,
            nums: nums),
        context));
  }
}
