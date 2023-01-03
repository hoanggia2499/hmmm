import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mirukuru/core/config/common.dart';
import 'package:mirukuru/core/resources/core_resource.dart';
import 'package:mirukuru/core/util/core_util.dart';
import 'package:mirukuru/core/widgets/common/template_page.dart';
import 'package:mirukuru/core/widgets/common/text_widget.dart';
import 'package:mirukuru/core/widgets/dialog/common_dialog.dart';
import 'package:mirukuru/features/carlist/presentation/listview_question_widget.dart';
import 'package:mirukuru/features/login/data/models/login_model.dart';
import 'package:mirukuru/features/question/data/models/query_list_bean.dart';
import 'package:mirukuru/features/question/data/models/question_bean.dart';
import 'package:mirukuru/features/quotation_list/presentation/bloc/quotation_list_bloc.dart';
import 'package:mirukuru/features/quotation_list/presentation/bloc/quotation_list_event.dart';
import 'package:mirukuru/features/quotation_list/presentation/bloc/quotation_list_state.dart';
import 'package:easy_localization/easy_localization.dart';

class QuotationListPage extends StatefulWidget {
  QuotationListPage();

  @override
  _QuotationListPageState createState() => _QuotationListPageState();
}

class _QuotationListPageState extends State<QuotationListPage> {
  LoginModel loginModel = LoginModel();
  List<QuestionBean> questionList = []; // １問い合わせの詳細リスト？

  @override
  void initState() {
    context.read<QuotationListBloc>().add(QuotationListInit());
    super.initState();
    getLoginModel();
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
      appBarTitle: "QUOTATION_REQUEST_LIST".tr(),
      storeName: loginModel.storeName2.isNotEmpty
          ? '${loginModel.storeName}\n${loginModel.storeName2}'
          : loginModel.storeName,
      appBarColor: ResourceColors.color_FF1979FF,
      body: BlocListener<QuotationListBloc, QuotationListState>(
        listener: (context, quotationState) async {
          if (quotationState is Error) {
            await CommonDialog.displayDialog(
                context,
                quotationState.messageCode,
                quotationState.messageContent,
                false);
          }
          if (quotationState is TimeOut) {
            await CommonDialog.displayDialog(
                context,
                quotationState.messageCode,
                quotationState.messageContent,
                false);

            Navigator.of(context)
                .pushNamedAndRemoveUntil(AppRoutes.loginPage, (route) => false);
          }

          if (quotationState is Loading && questionList.isEmpty) {
            await EasyLoading.show();
          }

          if (quotationState is Loaded) {
            appendDataListView(context.read<QuotationListBloc>().data);
          }
        },
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return Stack(
      children: [
        _buildTop(),
        _buildListQuestion(),
      ],
    );
  }

  _buildListQuestion() {
    return BlocBuilder<QuotationListBloc, QuotationListState>(
      builder: (context, state) {
        if (EasyLoading.isShow) {
          EasyLoading.dismiss();
        }

        if (state is Loading && questionList.isEmpty) {
          EasyLoading.show();
        }

        return Padding(
          padding: EdgeInsets.only(top: Dimens.getWidth(40.0)),
          child: ListViewQuestionWidget(
            initItemChecked: [],
            listData:
                questionList.map((e) => QueryListBean.convertFrom(e)).toList(),
            isShowDeleteIcon: false,
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
                  questionList.clear();
                  context.read<QuotationListBloc>().resetPaginatedDataParams();
                  context.read<QuotationListBloc>().add(QuotationListInit());
                }
              }
            },
            isEndList: !context.read<QuotationListBloc>().hasMoreData,
            totalItemsCount: context.read<QuotationListBloc>().totalCount,
            loadMorePageCallback: () {
              context.read<QuotationListBloc>().add(QuotationListInit());
            },
          ),
        );
      },
    );
  }

  _buildTop() {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        color: ResourceColors.color_E1E1E1,
        height: Dimens.getWidth(40.0),
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
          ],
        ),
      ),
    );
  }

  void appendDataListView(List<QuestionBean> nextPageData) {
    setState(() {
      questionList.addAll(nextPageData);
    });
  }
}
