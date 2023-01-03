import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../../../core/config/common.dart';
import '../../../../core/util/app_route.dart';
import '../../../../core/util/constants.dart';
import '../../../../core/util/helper_function.dart';
import '../../../../core/widgets/common/template_page.dart';
import '../../../login/data/models/login_model.dart';
import '../../bloc/inquiry_bloc.dart';

class InquiryPage extends StatefulWidget {
  @override
  _InquiryPageState createState() => _InquiryPageState();
}

class _InquiryPageState extends State<InquiryPage>
    with SingleTickerProviderStateMixin {
  LoginModel loginModel = LoginModel();

  String telCompany = '';

  bool tabButtonFlag = false;
  bool foreignMode = false;

  late List<Map<String, String>> listDataMaker;

  late List<Map<int, String>> listDataBodyType;

  List<String> listImgKoKuSanMaker = [];
  List<String> listImgBodyType = [];
  late TabController controller;

  @override
  void initState() {
    super.initState();
    getLoginModel();
  }

  void getLoginModel() async {
    var localLoginModel = await HelperFunction.instance.getLoginModel();
    //  var localTelCompany = await UserSecureStorage.instance.getTelCompany();
    setState(() {
      loginModel = localLoginModel;
      // telCompany = localTelCompany;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TemplatePage(
      storeName: loginModel.storeName2.isNotEmpty
          ? '${loginModel.storeName}\n${loginModel.storeName2}'
          : loginModel.storeName,
      currentIndex: Constants.INQUIRY_INDEX,
      appBarLogo: loginModel.logoMark.isEmpty
          ? ''
          : '${Common.imageUrl + loginModel.memberNum + '/' + loginModel.logoMark}',
      appBarTitle: "INQUIRY_TITLE".tr(),
      hasMenuBar: false,
      backCallBack: () {
        // Back to Search Input Page
        // Navigator.pop(context);
        Navigator.popAndPushNamed(context, AppRoutes.searchTopPage);
      },
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return BlocBuilder<InquiryBloc, InquiryState>(builder: (context, state) {
      if (EasyLoading.isShow) {
        EasyLoading.dismiss();
      }
      return Container();
    });
  }
}
