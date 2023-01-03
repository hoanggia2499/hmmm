import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mirukuru/core/resources/core_resource.dart';
import 'package:mirukuru/core/util/core_util.dart';
import 'package:mirukuru/core/widgets/common/text_widget.dart';
import 'package:flustars_flutter3/flustars_flutter3.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/config/common.dart';
import '../../../../core/secure_storage/user_secure_storage.dart';
import '../../../../core/widgets/common/sub_title_widget.dart';
import '../../../../core/widgets/common/template_page.dart';
import '../../../inform_list/data/models/inform_list_response.dart';
import '../../../login/data/models/login_model.dart';
import '../../../menu_widget_test/pages/button_widget.dart';
import '../../data/models/carSP_request.dart';
import '../../data/models/inform_detail_request.dart';
import '../bloc/inform_detail_bloc.dart';

class InformDetailPage extends StatefulWidget {
  final InformListResponseModel informListResponseModel;

  const InformDetailPage({
    Key? key,
    required this.informListResponseModel,
  }) : super(key: key);

  @override
  State<InformDetailPage> createState() => _InformDetailPageState();
}

class _InformDetailPageState extends State<InformDetailPage> {
  /// To load logo and scroll bar
  LoginModel _loginModel = LoginModel();
  String _buildAppBarLogo(LoginModel loginModel) {
    return loginModel.logoMark.isEmpty
        ? ''
        : '${Common.imageUrl + loginModel.memberNum + '/' + loginModel.logoMark}';
  }

  /// Get memberNum
  late String memberNum;
  bool? isReloadInformList;
  String urlPicFile = '';

  @override
  void initState() {
    initData();
    getData();
    super.initState();
  }

  void initData() async {
    //get member num from local
    memberNum = await UserSecureStorage.instance.getMemberNum() ?? '';

    //get url picFile
    String authority = Common.imageUrl;
    var picFile = widget.informListResponseModel.picFile ?? "";
    urlPicFile = "$authority$memberNum/$picFile";

    if (widget.informListResponseModel.confirmDate != null) {
      isReloadInformList = false;
      // do not reload inform list page when seen notification
      return;
    } else {
      isReloadInformList = true;

      var userNum = await UserSecureStorage.instance.getUserNum() ?? '';
      var sendNum = widget.informListResponseModel.sendNum;
      var requestModel = InformDetailRequestModel(
        memberNum: memberNum,
        userNum: int.tryParse(userNum) != null ? int.parse(userNum) : 0,
        sendNum: sendNum,
      );

      context.read<InformDetailBloc>().add(GetInformDetailEvent(requestModel));
    }
  }

  void getData() async {
    _loginModel = await HelperFunction.instance.getLoginModel();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return TemplatePage(
      appBarLogo: _buildAppBarLogo(_loginModel),
      appBarTitle: "NOTIFICATIONS_DETAIL".tr(),
      storeName: _loginModel.storeName2.isNotEmpty
          ? '${_loginModel.storeName}\n${_loginModel.storeName2}'
          : _loginModel.storeName,
      hasMenuBar: true,
      onBackAction: () => Navigator.of(context).pop(isReloadInformList),
      appBarColor: ResourceColors.color_FF1979FF,
      resizeToAvoidBottomInset: true,
      currentIndex: Constants.NOTIFICATION_INDEX,
      body: BlocListener<InformDetailBloc, InformDetailState>(
        listener: (context, state) {
          if (state is OnCarSPLinkAccessState) {
            var itemSearchModel = state.itemSearchModel;

            Navigator.of(context).pushNamed(
              AppRoutes.searchDetailPage,
              arguments: {Constants.ITEM_SEARCH_MODEL: itemSearchModel},
            );
          }
        },
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    final model = widget.informListResponseModel;

    return BlocBuilder<InformDetailBloc, InformDetailState>(
        builder: (context, state) {
      if (EasyLoading.isShow) {
        EasyLoading.dismiss();
      }

      if (state is Loading) {
        EasyLoading.show();
      }

      return Stack(children: [_buildBodyInfo(model), _buildButtonNewQues()]);
    });
  }

  Widget _buildBodyInfo(InformListResponseModel model) {
    return Padding(
      padding: EdgeInsets.only(
        left: Dimens.getWidth(10.0),
        right: Dimens.getWidth(10.0),
        bottom: Dimens.getHeight(80.0),
      ),
      child: Column(
        children: [
          _buildTitle(model),
          SizedBox(
            height: Dimens.getHeight(10.0),
          ),
          Flexible(
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: <Widget>[
                _buildBanner(model),
                _buildDetailInform(model),
                _buildPdfFile(model),
                _buildGuidListCarSP(model),
                ..._buildLinkCarSP(model),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuidListCarSP(InformListResponseModel model) {
    return Visibility(
      visible: model.carSPNo1 != "" && model.carSPNo1 != null,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: Dimens.getHeight(5)),
        child: TextWidget(
          label: 'PLEASE_TOUCH_FOLLOW_FOR_RECOMMEND_VEHICLES'.tr(),
          textStyle: MKStyle.t10R,
        ),
      ),
    );
  }

  _buildButtonNewQues() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          decoration: _buildBoxDecoration(),
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildButtonNewQuestion(),
          ),
        )
      ],
    );
  }

  //TODO: check lại design, để tạm màu trắng
  BoxDecoration _buildBoxDecoration() {
    return BoxDecoration(
      color: ResourceColors.color_FFFFFF,
      // gradient: LinearGradient(
      //   colors: [
      //     const Color(0xFFFDFEFF),
      //     const Color(0xFFEEF9FF),
      //   ],
      //   begin: Alignment.topCenter,
      //   end: Alignment.bottomCenter,
      // ),
    );
  }

  _buildButtonNewQuestion() {
    return Visibility(
        visible: true,
        child: Center(
          child: Column(
            children: [
              TextWidget(
                label: 'PLEASE_CONTACT_US_FOR_RESERVATION'.tr(),
                textStyle: MKStyle.t10R,
              ),
              SizedBox(
                height: Dimens.getHeight(5),
              ),
              ButtonWidget(
                width: MediaQuery.of(context).size.width / 2,
                content: "INQUIRE".tr(),
                borderRadius: 30.0,
                clickButtonCallBack: () async {
                  await Navigator.of(context).pushNamed(AppRoutes.newQuestion);
                },
                textStyle:
                    MKStyle.t14R.copyWith(color: ResourceColors.color_FFFFFF),
                bgdColor: ResourceColors.color_FF0FA4EA,
                borderColor: ResourceColors.color_FF4BC9FD,
                heightText: 1.2,
              ),
            ],
          ),
        ));
  }

  Widget _buildDetailInform(InformListResponseModel model) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Dimens.getHeight(5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget(
            label: model.info ?? "",
            textStyle: MKStyle.t12R.copyWith(
              color: ResourceColors.color_333333,
            ),
          )
        ],
      ),
    );
  }

  List<Widget> _buildLinkCarSP(InformListResponseModel model) {
    List<String> listCarSP = [];

    if (model.carSPNo1 != "" && model.carSPNo1 != null) {
      listCarSP.add(model.carSPNo1 ?? "");
    }
    if (model.carSPNo2 != "" && model.carSPNo1 != null) {
      listCarSP.add(model.carSPNo2 ?? "");
    }
    if (model.carSPNo3 != "" && model.carSPNo1 != null) {
      listCarSP.add(model.carSPNo3 ?? "");
    }
    if (model.carSPNo4 != "" && model.carSPNo1 != null) {
      listCarSP.add(model.carSPNo4 ?? "");
    }
    if (model.carSPNo5 != "" && model.carSPNo1 != null) {
      listCarSP.add(model.carSPNo5 ?? "");
    }

    return List.generate(
        listCarSP.length,
        growable: false,
        (index) => Padding(
              padding: EdgeInsets.symmetric(vertical: Dimens.getHeight(5)),
              child: InkWell(
                onTap: () async {
                  onGetCarSP(listCarSP[index]);
                },
                child: TextWidget(
                  label: "500-${listCarSP[index]}",
                  textStyle: MKStyle.t9B.copyWith(
                      color: ResourceColors.color_0075C1,
                      decoration: TextDecoration.underline),
                ),
              ),
            ));
  }

  Widget _buildPdfFile(InformListResponseModel model) {
    return Visibility(
      visible: model.pdfFile != null && model.pdfFile!.isNotEmpty,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: Dimens.getHeight(5)),
        child: InkWell(
          onTap: () async {
            _launchUrl(model.pdfFile ?? "");
          },
          child: TextWidget(
            label: model.pdfFile ?? "",
            textStyle: MKStyle.t9B.copyWith(
                decoration: TextDecoration.underline,
                color: ResourceColors.color_0075C1),
          ),
        ),
      ),
    );
  }

  Widget _buildBanner(InformListResponseModel model) {
    return model.picFile != null && model.picFile != ''
        ? Padding(
            padding: EdgeInsets.symmetric(vertical: Dimens.getHeight(5)),
            child: Image.network(
              urlPicFile,
              fit: BoxFit.fill,
              errorBuilder: (context, object, stack) {
                return Center(
                  child: TextWidget(
                    label: "STORE_PHOTO".tr(),
                    textStyle: MKStyle.t30B
                        .copyWith(color: ResourceColors.color_929292),
                  ),
                );
              },
            ),
          )
        : SizedBox.shrink();
  }

  Widget _buildTitle(
    InformListResponseModel model,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SubTitle(
          label: model.title ?? "",
          paddingLeft: 0,
          textStyle: MKStyle.t14B,
        ),
        Padding(
          padding: EdgeInsets.only(left: Dimens.getWidth(10)),
          child: TextWidget(
            label: DateUtil.formatDateStr(model.sendDate ?? "",
                format: "yyyy年MM月dd日 HH:mm"),
            textStyle: MKStyle.t10R.copyWith(color: ResourceColors.color_70),
          ),
        ),
      ],
    );
  }

  ///Move to pdf view on browser
  Future<void> _launchUrl(String url) async {
    String authority = Common.imageUrl;

    var uri = Uri.parse("$authority$memberNum/$url");

    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  ///Call API 18
  onGetCarSP(String carSPNum) {
    var corner = carSPNum.substring(0, 2); // check native source
    var aACount = carSPNum.substring(2, 6);
    var exhNum = carSPNum.substring(6, 10);

    var request = CarSPRequestModel(
      memberNum: memberNum,
      corner: corner,
      aACount: aACount,
      exhNum: exhNum,
    );

    context.read<InformDetailBloc>().add(GetCarSPEvent(request));
  }
}
