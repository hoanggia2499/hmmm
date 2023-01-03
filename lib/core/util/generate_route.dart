import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mirukuru/core/db/car_search_hive.dart';
import 'package:mirukuru/core/util/constants.dart';
import 'package:mirukuru/features/about/presentation/pages/about_page.dart';
import 'package:mirukuru/features/agreement/presentation/pages/agreement_page.dart';
import 'package:mirukuru/features/body_list/presentation/bloc/body_list_bloc.dart';
import 'package:mirukuru/features/body_list/presentation/pages/body_list_page.dart';
import 'package:mirukuru/features/car_regist/presentation/pages/car_regist_page.dart';
import 'package:mirukuru/features/carlist/presentation/pages/carList_page.dart';
import 'package:mirukuru/features/favorite_detail/presentation/bloc/favorite_detail_bloc.dart';
import 'package:mirukuru/features/favorite_detail/presentation/pages/favorite_detail_page.dart';
import 'package:mirukuru/features/favorite_list/presentation/bloc/favorite_list_bloc.dart';
import 'package:mirukuru/features/favorite_list/presentation/pages/favorite_list_page.dart';
import 'package:mirukuru/features/history/presentation/bloc/history_bloc.dart';
import 'package:mirukuru/features/history/presentation/pages/history_page.dart';
import 'package:mirukuru/features/inform_list/presentation/bloc/inform_list_bloc.dart';
import 'package:mirukuru/features/inquiry/bloc/inquiry_bloc.dart';
import 'package:mirukuru/features/inquiry/presentation/pages/inquiry_page.dart';
import 'package:mirukuru/features/invite/presentation/bloc/invite_bloc.dart';
import 'package:mirukuru/features/invite/presentation/pages/invite_page.dart';
import 'package:mirukuru/features/login/presentation/bloc/login_bloc.dart';
import 'package:mirukuru/features/login/presentation/pages/login_page.dart';
import 'package:mirukuru/features/login/presentation/pages/unavailable_user_page.dart';
import 'package:mirukuru/features/maker/presentation/pages/makerList_page.dart';
import 'package:mirukuru/features/my_page/data/models/my_page_user_car_model.dart';
import 'package:mirukuru/features/my_page/presentation/bloc/my_page_bloc.dart';
import 'package:mirukuru/features/my_page/presentation/pages/car_ownership_settings_screen.dart';
import 'package:mirukuru/features/my_page/presentation/pages/my_page_page.dart';
import 'package:mirukuru/features/new_question/presentation/bloc/new_question_bloc.dart';
import 'package:mirukuru/features/new_question/presentation/page/new_question_page.dart';
import 'package:mirukuru/features/new_user_authentication/presentation/bloc/new_user_authentication_bloc.dart';
import 'package:mirukuru/features/new_user_authentication/presentation/pages/new_user_authentication_page.dart';
import 'package:mirukuru/features/new_user_registration/presentation/bloc/user_registration_bloc.dart';
import 'package:mirukuru/features/new_user_registration_notice/presentation/pages/new_user_registration_notice_page.dart';
import 'package:mirukuru/features/question/presentation/bloc/question_bloc.dart';
import 'package:mirukuru/features/question/presentation/pages/question_page.dart';
import 'package:mirukuru/features/quotation/presentation/pages/quotation_page.dart';
import 'package:mirukuru/features/quotation/presentation/bloc/quotation_bloc.dart';
import 'package:mirukuru/features/message_board/presentation/bloc/message_board_bloc.dart';
import 'package:mirukuru/features/message_board/presentation/pages/message_board_page.dart';
import 'package:mirukuru/features/quotation_list/presentation/bloc/quotation_list_bloc.dart';
import 'package:mirukuru/features/quotation_list/presentation/pages/quotation_list_page.dart';
import 'package:mirukuru/features/search_detail/presentation/bloc/search_detail_bloc.dart';
import 'package:mirukuru/features/search_detail/presentation/pages/search_detail_page.dart';
import 'package:mirukuru/features/search_input/data/models/search_input_model.dart';
import 'package:mirukuru/features/search_input/presentation/bloc/search_input_bloc.dart';
import 'package:mirukuru/features/search_input/presentation/pages/search_input_page.dart';
import 'package:mirukuru/features/search_list/presentation/bloc/search_list_bloc.dart';
import 'package:mirukuru/features/search_list/presentation/pages/search_list_page.dart';
import 'package:mirukuru/features/search_top/presentation/bloc/search_top_bloc.dart';
import 'package:mirukuru/features/search_top/presentation/pages/search_top_page.dart';
import 'package:mirukuru/features/sell_car/presentation/bloc/sell_car_bloc.dart';
import 'package:mirukuru/features/sell_car/presentation/pages/sell_car_page.dart';
import 'package:mirukuru/features/store_information/presentation/bloc/store_bloc.dart';
import 'package:mirukuru/features/store_information/presentation/pages/store_information_page.dart';
import '../../features/agreement/presentation/bloc/agreement_bloc.dart';
import '../../features/about/presentation/bloc/about_bloc.dart';

import '../../features/car_regist/presentation/bloc/car_regist_bloc.dart';
import '../../features/inform_detail/presentation/bloc/inform_detail_bloc.dart';
import '../../features/inform_detail/presentation/pages/inform_detail_page.dart';
import '../../features/inform_list/presentation/pages/inform_list_page.dart';
import '../../features/new_user_registration/presentation/pages/new_user_registration_page.dart';
import 'package:mirukuru/features/maker/presentation/bloc/makerList_bloc.dart';
import 'package:mirukuru/features/carlist/presentation/bloc/carList_bloc.dart';

import '../../injection_container.dart';
import 'app_route.dart';

class RouteGenerator {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  static Route<dynamic> generateRoute(RouteSettings settings) {
    var args = settings.arguments;
    switch (settings.name) {
      case AppRoutes.loginPage:
        return MaterialPageRoute(
            settings: settings,
            // Import bloc sample
            builder: (context) => BlocProvider(
                  create: (_) => sl<LoginBloc>(),
                  child: LoginPage(),
                ));
      case AppRoutes.newUserRegistrationPage:
        return CupertinoPageRoute(
            builder: (context) => BlocProvider(
                  create: (_) => sl<UserRegistrationBloc>(),
                  child: NewUserRegistrationPage(),
                ));
      case AppRoutes.newUserRegistrationNoticePage:
        return CupertinoPageRoute(
            builder: (context) => BlocProvider(
                  create: (_) => sl<UserRegistrationBloc>(),
                  child: NewUserRegistrationNoticePage(),
                ));
      case AppRoutes.newUserAuthenticationPage:
        args = args as Map<String, dynamic>?;
        int id = 0;
        String tel = '';
        String name = '';
        String nameKana = '';

        if (args != null) {
          id = args['id'] as int? ?? 0;
          tel = args['tel'] ?? '';
          name = args['name'] ?? '';
          nameKana = args['nameKana'] ?? '';
        }

        return CupertinoPageRoute(
            builder: (context) => BlocProvider(
                  create: (_) => sl<NewUserAuthenticationBloc>(),
                  child: NewUserAuthenticationPage(
                      id: id, tel: tel, name: name, nameKana: nameKana),
                ));
      case AppRoutes.aboutPage:
        //var loginModel = args as LoginModel;
        return CupertinoPageRoute(
            builder: (context) => BlocProvider(
                  create: (_) => sl<AboutBloc>(),
                  child: AboutPage(),
                ));
      case AppRoutes.searchTopPage:
        return CupertinoPageRoute(
            builder: (context) => BlocProvider(
                  create: (_) => sl<SearchTopBloc>(),
                  child: SearchTopPage(),
                ));
      case AppRoutes.makerListPage:
        return CupertinoPageRoute(
            settings: settings,
            // Import bloc sample
            builder: (context) => BlocProvider(
                  create: (_) => sl<MakerListBloc>(),
                  child: MakerListPage(),
                ));
      case AppRoutes.carListPage:
        args = args as Map<String, dynamic>?;
        String makerCode = '';
        String makerName = '';
        String caller = '';
        String from = '';

        if (args != null) {
          makerCode = args['makerCode'] ?? '';
          makerName = args['makerName'] ?? '';
          caller = args['caller'] ?? '';
          from = args['from'] ?? '';
        }

        return CupertinoPageRoute(
            settings: settings,
            // Import bloc sample
            builder: (context) => BlocProvider(
                  create: (_) => sl<CarListBloc>(),
                  child: CarListPage(
                      makerCode: makerCode,
                      makerName: makerName,
                      caller: caller,
                      from: from),
                ));
      case AppRoutes.bodyListPage:
        args = args as Map<String, dynamic>?;
        int id = 0;
        String bodyType = '';

        if (args != null) {
          id = args['id'] as int? ?? 0;
          bodyType = args['bodyType'] ?? '';
        }

        return CupertinoPageRoute(
            settings: settings,
            // Import bloc sample
            builder: (context) => BlocProvider(
                  create: (_) => sl<BodyListBloc>(),
                  child: BodyListPage(id: id, bodyType: bodyType),
                ));

      case AppRoutes.searchInputPage:
        args = args as Map<String, dynamic>?;

        String nameScreen = '';
        List<CarSearchHive> listDataCarName = [];
        if (args != null) {
          nameScreen = args['nameScreen'] ?? '';
          listDataCarName = args['listDataCarName'] ?? [];
        }

        return CupertinoPageRoute(
            settings: settings,
            // Import bloc sample
            builder: (context) => BlocProvider(
                  create: (_) => sl<SearchInputBloc>(),
                  child: SearchInputPage(
                    previousNameScreen: nameScreen,
                    listDataCarName: listDataCarName,
                  ),
                ));
      case AppRoutes.searchListPage:
        args = args as Map<String, dynamic>?;

        var searchListModel = SearchInputModel();
        int type = 0;
        if (args != null) {
          searchListModel = args['searchListModel'];
          type = args['type'];
        }

        return CupertinoPageRoute(
            settings: settings,
            // Import bloc sample
            builder: (context) => BlocProvider(
                  create: (_) => sl<SearchListBloc>(),
                  child: SearchListPage(
                    searchListModel: searchListModel,
                    typeScreen: type,
                  ),
                ));
      case AppRoutes.favoriteListPage:
        args = args as Map<String, dynamic>?;

        var pic1Map;

        if (args != null) {
          pic1Map = args['pic1Map'];
        }

        return CupertinoPageRoute(
            settings: settings,
            // Import bloc sample
            builder: (context) => BlocProvider(
                  create: (_) => sl<FavoriteListBloc>(),
                  child: FavoriteListPage(pic1Map: pic1Map),
                ));

      case AppRoutes.searchDetailPage:
        args = args as Map<String, dynamic>?;

        var itemSearchModel;

        if (args != null) {
          itemSearchModel = args[Constants.ITEM_SEARCH_MODEL];
        }
        return CupertinoPageRoute(
            settings: settings,
            // Import bloc sample
            builder: (context) => BlocProvider(
                  create: (_) => sl<SearchDetailBloc>(),
                  child: SearchDetailPage(itemSearchModel: itemSearchModel),
                ));
      case AppRoutes.favoriteDetailPage:
        args = args as Map<String, dynamic>?;

        var itemSearchModel;

        if (args != null) {
          itemSearchModel = args[Constants.ITEM_SEARCH_MODEL];
        }
        return CupertinoPageRoute(
            settings: settings,
            // Import bloc sample
            builder: (context) => BlocProvider(
                  create: (_) => sl<FavoriteDetailBloc>(),
                  child: FavoriteDetailPage(itemSearchModel: itemSearchModel),
                ));
      case AppRoutes.historyPage:
        return CupertinoPageRoute(
            settings: settings,
            // Import bloc sample
            builder: (context) => BlocProvider(
                  create: (_) => sl<HistoryBloc>(),
                  child: HistoryPage(),
                ));
      case AppRoutes.informListPage:
        return CupertinoPageRoute(
            settings: settings,
            // Import bloc sample
            builder: (context) => BlocProvider(
                  create: (_) => sl<InformListBloc>(),
                  child: InformListPage(),
                ));
      case AppRoutes.informDetailPage:
        args = args as Map<String, dynamic>?;

        var informListResponseModel;

        if (args != null) {
          informListResponseModel = args['informListResponseModel'];
        }
        return CupertinoPageRoute(
            settings: settings,
            // Import bloc sample
            builder: (context) => BlocProvider(
                  create: (_) => sl<InformDetailBloc>(),
                  child: InformDetailPage(
                    informListResponseModel: informListResponseModel,
                  ),
                ));
      case AppRoutes.inquiryPage:
        return CupertinoPageRoute(
            builder: (context) => BlocProvider(
                  create: (_) => sl<InquiryBloc>(),
                  child: InquiryPage(),
                ));
      case AppRoutes.quotationPage:
        args = args as Map<String, dynamic>?;

        var itemSearchModel;

        if (args != null) {
          itemSearchModel = args[Constants.ITEM_SEARCH_MODEL];
        }
        return CupertinoPageRoute(
            builder: (context) => BlocProvider(
                  create: (_) => sl<QuotationBloc>(),
                  child: QuotationPage(itemSearchModel: itemSearchModel),
                ));
      case AppRoutes.questionPage:
        args = args as Map<String, dynamic>?;

        var itemSearchModel;

        if (args != null) {
          itemSearchModel = args[Constants.ITEM_SEARCH_MODEL];
        }

        return CupertinoPageRoute(
            builder: (context) => BlocProvider(
                  create: (_) => sl<QuestionBloc>(),
                  child: QuestionPage(),
                ));

      case AppRoutes.carRegistPage:
        UserCarModel? userCarModel;
        if (args != null) {
          userCarModel = args as UserCarModel;
        }

        return CupertinoPageRoute(
            builder: (context) => BlocProvider(
                  create: (_) => sl<CarRegisBloc>(),
                  child: CarRegistPage(
                    userCarModel: userCarModel,
                  ),
                ));
      case AppRoutes.myPagePage:
        return CupertinoPageRoute(
            builder: (context) => BlocProvider(
                  create: (_) => sl<MyPageBloc>(),
                  child: MyPagePage(),
                ));
      case AppRoutes.myPagePage_CarOwnershipSettingsScreen:
        args as Map<String, dynamic>;
        var userCarList = <UserCarModel>[];
        var selectedIndex = 0;

        if (args != null) {
          userCarList = args['userCarList'];
          selectedIndex = args['selectedIndex'];
        }

        return CupertinoPageRoute(
          builder: (context) => BlocProvider(
            create: (_) => sl<MyPageBloc>(),
            child: CarOwnerShipSettingsScreen(
                userCarList: userCarList, selectedIndex: selectedIndex),
          ),
        );
      case AppRoutes.requestQuotationPage:
        return CupertinoPageRoute(
            builder: (context) => BlocProvider(
                  create: (_) => sl<QuotationListBloc>(),
                  child: QuotationListPage(),
                ));
      case AppRoutes.messageBoardPage:
        args = args as Map<String, dynamic>?;

        var kubunId;
        var questionKbn;
        var exhNum;
        var userCarNum;
        var questionDate;
        var question;
        var makerName;
        var carName;

        if (args != null) {
          kubunId = args['KubunId'];
          questionKbn = args['QuestionKbn'];
          exhNum = args['ExhNum'];
          userCarNum = args['UserCarNum'];
          questionDate = args['QuestionDate'];
          question = args['Question'];
          makerName = args['MakerName'];
          carName = args['CarName'];
        }

        return CupertinoPageRoute(
            builder: (context) => BlocProvider(
                  create: (_) => sl<MessageBoardBloc>(),
                  child: MessageBoardPage(
                    kubunId: kubunId,
                    questionKbn: questionKbn,
                    exhNum: exhNum,
                    question: question,
                    questionDate: questionDate,
                    userCarNum: userCarNum,
                    carName: carName,
                    makerName: makerName,
                  ),
                ));
      case AppRoutes.invitePage:
        return CupertinoPageRoute(
            builder: (context) => BlocProvider(
                  create: (_) => sl<InviteBloc>(),
                  child: InvitePage(),
                ));
      case AppRoutes.sellCarPage:
        args = args as Map<String, dynamic>?;
        var userCarModel;
        if (args != null) {
          userCarModel = args['userCarModel'] ?? UserCarModel();
        }
        return CupertinoPageRoute(
            builder: (context) => BlocProvider(
                  create: (_) => sl<SellCarBloc>(),
                  child: SellCarPage(
                    userCarModel: userCarModel,
                  ),
                ));
      case AppRoutes.agreementPage:
        args = args as Map<String, dynamic>?;
        bool isNewUser = false;
        String memberNum = '';
        int userNum = 0;
        bool isLoginAgreement = true;

        if (args != null) {
          isNewUser = args['isNewUser'] ?? false;
          memberNum = args['memberNum'] ?? '';
          userNum = args['userNum'] ?? 0;
          isLoginAgreement = args['isLoginAgreement'] ?? true;
        }

        return CupertinoPageRoute(
            builder: (context) => BlocProvider(
                create: (_) => sl<AgreementBloc>(),
                child: AgreementPage(
                  isNewUser: isNewUser,
                  memberNum: memberNum,
                  userNum: userNum,
                  isLoginAgreement: isLoginAgreement,
                )));
      case AppRoutes.storeInformationPage:
        return CupertinoPageRoute(
            builder: (context) => BlocProvider(
                  create: (_) => sl<StoreBloc>(),
                  child: StoreInformationPage(),
                ));
      case AppRoutes.newQuestion:
        return CupertinoPageRoute(
            builder: (context) => BlocProvider(
                  create: (_) => sl<NewQuestionBloc>(),
                  child: NewQuestionPage(),
                ));
      case AppRoutes.unAvailableUserPage:
        return CupertinoPageRoute(
            builder: (context) => BlocProvider(
                  create: (_) => sl<StoreBloc>(),
                  child: UnavailableUserPage(),
                ));
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
          centerTitle: true,
        ),
        body: const Center(
          child: Text('Page not found'),
        ),
      );
    });
  }
}
