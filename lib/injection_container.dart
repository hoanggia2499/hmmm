import 'package:get_it/get_it.dart';
import 'package:mirukuru/core/config/common.dart';
import 'package:mirukuru/core/db/db_service.dart';
import 'package:mirukuru/core/network/state.dart';
import 'package:mirukuru/core/secure_storage/share_preferences.dart';
import 'package:mirukuru/core/secure_storage/user_secure_storage.dart';
import 'package:mirukuru/core/util/connection_util.dart';
import 'package:mirukuru/core/util/helper_function.dart';
import 'package:mirukuru/core/util/logger_util.dart';
import 'package:mirukuru/core/util/process_util.dart';
import 'package:mirukuru/features/about/data/repositories/about_repository_impl.dart';
import 'package:mirukuru/features/about/domain/repositories/about_repository.dart';
import 'package:mirukuru/features/about/domain/usecases/get_about.dart';
import 'package:mirukuru/features/about/presentation/bloc/about_bloc.dart';
import 'package:mirukuru/features/agreement/domain/usecases/get_agreement.dart';
import 'package:mirukuru/features/body_list/data/datasources/body_list_remote_data_source.dart';
import 'package:mirukuru/features/body_list/data/repositories/body_list_repository_impl.dart';
import 'package:mirukuru/features/body_list/domain/repositories/body_list_repository.dart';
import 'package:mirukuru/features/body_list/domain/usecases/get_body_list.dart';
import 'package:mirukuru/features/body_list/presentation/bloc/body_list_bloc.dart';
import 'package:mirukuru/features/car_regist/data/datasources/car_regist_remote_data_source.dart';
import 'package:mirukuru/features/car_regist/data/repositories/car_regist_repository_impl.dart';
import 'package:mirukuru/features/car_regist/domain/repositories/car_regist_repository.dart';
import 'package:mirukuru/features/car_regist/domain/usecases/delete_own_car.dart';
import 'package:mirukuru/features/car_regist/domain/usecases/get_car_images.dart';
import 'package:mirukuru/features/car_regist/domain/usecases/post_own_car.dart';
import 'package:mirukuru/features/car_regist/domain/usecases/upload_photo.dart';
import 'package:mirukuru/features/car_regist/presentation/bloc/car_regist_bloc.dart';
import 'package:mirukuru/features/carlist/data/datasources/car_list_local_data_source.dart';
import 'package:mirukuru/features/carlist/data/datasources/car_list_remote_data_source.dart';
import 'package:mirukuru/features/carlist/data/repositories/car_list_repository_impl.dart';
import 'package:mirukuru/features/carlist/domain/repositories/carList_repository.dart';
import 'package:mirukuru/features/carlist/domain/usecases/add_car_list.dart';
import 'package:mirukuru/features/carlist/domain/usecases/delete_car_list.dart';
import 'package:mirukuru/features/carlist/domain/usecases/get_carList.dart';
import 'package:mirukuru/features/carlist/presentation/bloc/carList_bloc.dart';
import 'package:mirukuru/features/favorite_detail/data/datasources/favorite_detail_remote_data_source.dart';
import 'package:mirukuru/features/favorite_detail/data/repositories/favorite_detail_repository_impl.dart';
import 'package:mirukuru/features/favorite_detail/domain/repositories/favorite_detail_repository.dart';
import 'package:mirukuru/features/favorite_detail/domain/usecases/get_favorite_detail.dart';
import 'package:mirukuru/features/favorite_detail/presentation/bloc/favorite_detail_bloc.dart';
import 'package:mirukuru/features/favorite_list/data/datasources/favorite_list_remote_data_source.dart';
import 'package:mirukuru/features/favorite_list/data/repositories/favorite_list_repository_impl.dart';
import 'package:mirukuru/features/favorite_list/domain/repositories/favorite_list_repository.dart';
import 'package:mirukuru/features/favorite_list/domain/usecases/delete_favorite_by_position.dart';
import 'package:mirukuru/features/favorite_list/domain/usecases/get_car_object_list.dart';
import 'package:mirukuru/features/favorite_list/domain/usecases/get_car_pic1.dart';
import 'package:mirukuru/features/favorite_list/domain/usecases/get_favorite_list.dart';
import 'package:mirukuru/features/favorite_list/presentation/bloc/favorite_list_bloc.dart';
import 'package:mirukuru/features/history/data/datasources/history_local_data_source.dart';
import 'package:mirukuru/features/history/data/repositories/history_repository_impl.dart';
import 'package:mirukuru/features/history/domain/repositories/history_repository.dart';
import 'package:mirukuru/features/history/domain/usecases/add_car_object_list.dart';
import 'package:mirukuru/features/history/domain/usecases/delete_favorite.dart';
import 'package:mirukuru/features/history/domain/usecases/get_car_object_list.dart';
import 'package:mirukuru/features/history/domain/usecases/get_item_search_history_list.dart';
import 'package:mirukuru/features/history/domain/usecases/get_search_history_list.dart';
import 'package:mirukuru/features/history/domain/usecases/get_search_input_history_list.dart';
import 'package:mirukuru/features/history/domain/usecases/remove_car.dart';
import 'package:mirukuru/features/history/presentation/bloc/history_bloc.dart';
import 'package:mirukuru/features/inform_detail/domain/usecases/move_to_car_detail.dart';
import 'package:mirukuru/features/inform_list/data/datasources/inform_list_remote_data_souce.dart';
import 'package:mirukuru/features/inform_list/presentation/bloc/inform_list_bloc.dart';
import 'package:mirukuru/features/inquiry/bloc/inquiry_bloc.dart';
import 'package:mirukuru/features/invite/data/datasources/invite_remote_data_source.dart';
import 'package:mirukuru/features/invite/data/repositories/invite_repository_impl.dart';
import 'package:mirukuru/features/invite/domain/repositories/invite_repository.dart';
import 'package:mirukuru/features/invite/domain/usecases/invite_friend.dart';
import 'package:mirukuru/features/invite/presentation/bloc/invite_bloc.dart';
import 'package:mirukuru/features/login/data/datasources/login_remote_data_source.dart';
import 'package:mirukuru/features/login/domain/usecases/check_user_available.dart';
import 'package:mirukuru/features/login/domain/usecases/post_push_id.dart';
import 'package:mirukuru/features/maker/data/datasources/maker_list_remote_data_source.dart';
import 'package:mirukuru/features/maker/data/repositories/makerList_repository_impl.dart';
import 'package:mirukuru/features/maker/domain/repositories/makerList_repository.dart';
import 'package:mirukuru/features/maker/domain/usecases/get_makerList.dart';
import 'package:mirukuru/features/maker/presentation/bloc/makerList_bloc.dart';
import 'package:mirukuru/features/message_board/data/datasources/message_board_remote_data_source.dart';
import 'package:mirukuru/features/message_board/data/datasources/photo_remote_data_source.dart';
import 'package:mirukuru/features/message_board/data/repositories/message_board_repository_impl.dart';
import 'package:mirukuru/features/message_board/data/repositories/photo_repository_impl.dart';
import 'package:mirukuru/features/message_board/domain/repositories/message_board_repository.dart';
import 'package:mirukuru/features/message_board/domain/repositories/photo_repository.dart';
import 'package:mirukuru/features/message_board/domain/usecases/delete_photo.dart';
import 'package:mirukuru/features/message_board/domain/usecases/get_color_name.dart';
import 'package:mirukuru/features/message_board/domain/usecases/get_message_board.dart';
import 'package:mirukuru/features/message_board/domain/usecases/send_new_comment.dart';
import 'package:mirukuru/features/message_board/domain/usecases/upload_photo_use_case.dart';
import 'package:mirukuru/features/message_board/presentation/bloc/message_board_bloc.dart';
import 'package:mirukuru/features/my_page/data/datasources/my_page_local_data_source.dart';
import 'package:mirukuru/features/my_page/data/datasources/my_page_remote_data_source.dart';
import 'package:mirukuru/features/my_page/data/repositories/my_page_repository_impl.dart';
import 'package:mirukuru/features/my_page/domain/repositories/my_page_repository.dart';
import 'package:mirukuru/features/my_page/domain/usecases/get_my_page_information.dart';
import 'package:mirukuru/features/my_page/domain/usecases/get_user_car_name_list.dart';
import 'package:mirukuru/features/my_page/domain/usecases/save_my_page_information.dart';
import 'package:mirukuru/features/new_question/data/responsitories/new_question_responsitory_impl.dart';
import 'package:mirukuru/features/new_question/domain/responsitories/new_question_reponsitory.dart';
import 'package:mirukuru/features/new_question/domain/usecases/get_car_name.dart';
import 'package:mirukuru/features/new_question/domain/usecases/get_local_data.dart';
import 'package:mirukuru/features/new_question/domain/usecases/get_user_info.dart';
import 'package:mirukuru/features/new_question/domain/usecases/post_question.dart';
import 'package:mirukuru/features/new_question/domain/usecases/upload_photo.dart';
import 'package:mirukuru/features/new_question/presentation/bloc/new_question_bloc.dart';
import 'package:mirukuru/features/new_user_authentication/data/datasources/new_user_authentication_remote_data_source.dart';
import 'package:mirukuru/features/new_user_authentication/data/repositories/new_user_authentication_repository_impl.dart';
import 'package:mirukuru/features/new_user_authentication/domain/repositories/new_user_authentication_repository.dart';
import 'package:mirukuru/features/new_user_authentication/domain/usecases/new_user_authentication.dart';
import 'package:mirukuru/features/question/data/datasources/question_remote_data_source.dart';
import 'package:mirukuru/features/question/data/repositories/question_repository_impl.dart';
import 'package:mirukuru/features/question/domain/repositories/question_repository.dart';
import 'package:mirukuru/features/question/domain/usecases/delete_question.dart';
import 'package:mirukuru/features/question/domain/usecases/get_question.dart';
import 'package:mirukuru/features/question/presentation/bloc/question_bloc.dart';
import 'package:mirukuru/features/quotation/data/datasources/quotation_remote_data_source.dart';
import 'package:mirukuru/features/quotation/data/repositories/quotation_repository_impl.dart';
import 'package:mirukuru/features/quotation/domain/repositories/quotation_repository.dart';
import 'package:mirukuru/features/quotation/domain/usecases/make_an_inquiry.dart';
import 'package:mirukuru/features/quotation/presentation/bloc/quotation_bloc.dart';
import 'package:mirukuru/features/quotation_list/data/datasources/quotation_list_remote_data_source.dart';
import 'package:mirukuru/features/quotation_list/data/repositories/quotation_list_repository_impl.dart';
import 'package:mirukuru/features/quotation_list/domain/repositories/quotation_list_repository.dart';
import 'package:mirukuru/features/quotation_list/domain/usecases/get_quotation_list.dart';
import 'package:mirukuru/features/quotation_list/presentation/bloc/quotation_list_bloc.dart';
import 'package:mirukuru/features/search_detail/data/datasources/search_detail_remote_data_source.dart';
import 'package:mirukuru/features/search_detail/data/repositories/search_detail_repository_impl.dart';
import 'package:mirukuru/features/search_detail/domain/repositories/search_detail_repository.dart';
import 'package:mirukuru/features/search_detail/domain/usecases/get_search_detail.dart';
import 'package:mirukuru/features/search_detail/presentation/bloc/search_detail_bloc.dart';
import 'package:mirukuru/features/search_input/data/datasources/search_input_local_data_source.dart';
import 'package:mirukuru/features/search_input/domain/repositories/search_input_repository.dart';
import 'package:mirukuru/features/search_input/domain/usecases/get_car_list_search.dart';
import 'package:mirukuru/features/search_input/presentation/bloc/search_input_bloc.dart';
import 'package:mirukuru/features/search_list/data/datasources/search_list_local_data_source.dart';
import 'package:mirukuru/features/search_list/data/datasources/search_list_remote_data_source.dart';
import 'package:mirukuru/features/search_list/data/repositories/search_list_repository_impl.dart';
import 'package:mirukuru/features/search_list/domain/repositories/search_list_repository.dart';
import 'package:mirukuru/features/search_list/domain/usecases/add_car.dart';
import 'package:mirukuru/features/search_list/domain/usecases/delete_favorite_by_position.dart';
import 'package:mirukuru/features/search_list/domain/usecases/get_car_object_list.dart';
import 'package:mirukuru/features/search_list/domain/usecases/get_car_pic1.dart';
import 'package:mirukuru/features/search_list/domain/usecases/get_favorite_access.dart';
import 'package:mirukuru/features/search_list/domain/usecases/get_list_search_local.dart';
import 'package:mirukuru/features/search_list/domain/usecases/get_number_of_quotation_today.dart';
import 'package:mirukuru/features/search_list/domain/usecases/get_search_list.dart';
import 'package:mirukuru/features/search_list/domain/usecases/remove_car.dart';
import 'package:mirukuru/features/search_list/domain/usecases/update_search.dart';
import 'package:mirukuru/features/search_list/presentation/bloc/search_list_bloc.dart';
import 'package:mirukuru/features/search_top/data/datasources/search_top_local_data_source.dart';
import 'package:mirukuru/features/search_top/domain/repositories/search_top_repository.dart';
import 'package:mirukuru/features/sell_car/data/datasources/sell_car_remote_data_source.dart';
import 'package:mirukuru/features/sell_car/data/repositories/sell_car_repository_impl.dart';
import 'package:mirukuru/features/sell_car/domain/repositories/sell_car_repository.dart';
import 'package:mirukuru/features/sell_car/domain/usecases/post_sell_car.dart';
import 'package:mirukuru/features/sell_car/presentation/bloc/sell_car_bloc.dart';
import 'package:mirukuru/features/store_information/data/datasources/store_remote_data_source.dart';
import 'package:mirukuru/features/store_information/data/repositories/store_repository_impl.dart';
import 'package:mirukuru/features/store_information/domain/repositories/store_repository.dart';
import 'package:mirukuru/features/store_information/domain/usecases/get_store_information.dart';
import 'package:mirukuru/features/store_information/presentation/bloc/store_bloc.dart';

import 'core/db/boxes.dart';
import 'core/network/dio_base.dart';
import 'core/util/input_converter.dart';
import 'features/agreement/data/datasources/agreement_remote_data_source.dart';
import 'features/agreement/data/repositories/agreement_repository_impl.dart';
import 'features/agreement/domain/repositories/agreement_repository.dart';
import 'features/agreement/domain/usecases/send_mail_new_user.dart';
import 'features/agreement/presentation/bloc/bloc.dart';
import 'features/body_list/data/datasources/body_list_local_data_source.dart';
import 'features/body_list/domain/usecases/add_all_car_body_list.dart';
import 'features/body_list/domain/usecases/delete_car_body_list.dart';
import 'features/car_regist/data/datasources/car_regist_local_data_source.dart';
import 'features/car_regist/data/datasources/car_regist_photo_remote_data_source.dart';
import 'features/car_regist/domain/usecases/delete_photo.dart';
import 'features/car_regist/domain/usecases/get_local_data.dart';
import 'features/favorite_detail/data/datasources/favorite_detail_local_data_source.dart';
import 'features/favorite_detail/domain/usecases/add_car_object.dart';
import 'features/favorite_detail/domain/usecases/delete_favorite_by_position.dart';
import 'features/favorite_detail/domain/usecases/get_car_object_list.dart';
import 'features/favorite_list/data/datasources/favorite_list_local_data_source.dart';
import 'features/favorite_list/domain/usecases/add_car_seen.dart';
import 'features/favorite_list/domain/usecases/remove_car_seen.dart';
import 'features/history/data/datasources/history_remote_data_source.dart';
import 'features/history/domain/usecases/get_favorite_access.dart';
import 'features/inform_detail/data/datasources/inform_detail_remote_data_souce.dart';
import 'features/inform_detail/data/repositories/inform_detail_repository_impl.dart';
import 'features/inform_detail/domain/repositories/inform_detail_repository.dart';
import 'features/inform_detail/domain/usecases/update_status_inform.dart';
import 'features/inform_detail/presentation/bloc/inform_detail_bloc.dart';
import 'features/inform_list/data/repositories/inform_list_repository_impl.dart';
import 'features/inform_list/domain/repositories/inform_list_repository.dart';
import 'features/inform_list/domain/usecases/get_inform_list.dart';
import 'features/login/data/repositories/login_repository_impl.dart';
import 'features/login/domain/repositories/login_repository.dart';
import 'features/login/domain/usecases/post_login.dart';
import 'features/login/presentation/bloc/login_bloc.dart';
import 'features/message_board/data/datasources/message_board_local_data_source.dart';
import 'features/message_board/domain/usecases/add_favorite.dart';
import 'features/message_board/domain/usecases/delete_favorite.dart';
import 'features/message_board/domain/usecases/get_favorite_list.dart';
import 'features/my_page/presentation/bloc/my_page_bloc.dart';
import 'features/new_question/data/datasources/new_question_local_data_source.dart';
import 'features/new_question/data/datasources/new_question_remote_data_source.dart';
import 'features/new_question/domain/usecases/delete_photo_after_posted.dart';
import 'features/new_user_authentication/presentation/bloc/new_user_authentication_bloc.dart';
import 'features/new_user_registration/data/datasources/user_registration_remote_data_source.dart';
import 'features/new_user_registration/data/repositories/user_registration_repository_impl.dart';
import 'features/new_user_registration/domain/repositories/user_registration_repository.dart';
import 'features/new_user_registration/domain/usecases/new_user_registration.dart';
import 'features/new_user_registration/domain/usecases/personal_register.dart';
import 'features/new_user_registration/domain/usecases/request_register.dart';
import 'features/new_user_registration/presentation/bloc/user_registration_bloc.dart';
import 'features/quotation/data/datasources/quotation_local_data_source.dart';
import 'features/quotation/domain/usecases/add_favorite.dart';
import 'features/quotation/domain/usecases/delete_favorite.dart';
import 'features/quotation/domain/usecases/get_car_model.dart';
import 'features/search_detail/data/datasources/search_detail_local_data_source.dart';
import 'features/search_detail/domain/usecases/add_favorite.dart';
import 'features/search_detail/domain/usecases/delete_favorite.dart';
import 'features/search_detail/domain/usecases/get_favorite_access.dart';
import 'features/search_detail/domain/usecases/get_favorite_list.dart';
import 'features/quotation/domain/usecases/get_favorite_list.dart';
import 'features/search_input/data/repositories/search_input_repository_impl.dart';
import 'features/search_input/domain/usecases/get_name_bean.dart';
import 'features/search_list/domain/usecases/add_search.dart';
import 'features/search_list/domain/usecases/get_search_history.dart';
import 'features/search_top/data/datasources/search_top_remote_data_source.dart';
import 'features/search_top/data/repositories/search_top_repository_impl.dart';
import 'features/search_top/domain/usecases/company_get.dart';
import 'features/search_top/domain/usecases/get_name.dart';
import 'features/search_top/domain/usecases/get_number_of_unread.dart';
import 'features/search_top/presentation/bloc/search_top_bloc.dart';
import 'features/sell_car/data/datasources/sell_car_local_data_source.dart';
import 'features/sell_car/data/datasources/sell_car_photo_data_source.dart';
import 'features/sell_car/domain/usecases/delete_photo.dart';
import 'features/sell_car/domain/usecases/get_car_images.dart';
import 'features/sell_car/domain/usecases/get_local_data.dart';
import 'features/sell_car/domain/usecases/upload_photo.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Login bloc
  sl.registerFactory(
    () => LoginBloc(sl(), sl(), sl()),
  );

  // Agreement bloc
  sl.registerFactory(
    () => AgreementBloc(
      sl(),
      sl(),
    ),
  );

  // User registration bloc
  sl.registerFactory(
    () => UserRegistrationBloc(
      sl(),
      sl(),
      sl(),
      sl(),
    ),
  );

  // About bloc
  sl.registerFactory(
    () => AboutBloc(
      sl(),
    ),
  );

  // User authentication
  sl.registerFactory(
    () => NewUserAuthenticationBloc(sl(), sl(), sl()),
  );

  // Top
  sl.registerFactory(
    () => SearchTopBloc(
      sl(),
      sl(),
      sl(),
    ),
  );

  // MakerList
  sl.registerFactory(
    () => MakerListBloc(sl()),
  );

  // CarList
  sl.registerFactory(
    () => CarListBloc(sl()),
  );

  sl.registerFactory(
    () => BodyListBloc(
      sl(),
    ),
  );

  sl.registerFactory(
    () => SearchListBloc(
        sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl()),
  );

  sl.registerFactory(
    () => SearchDetailBloc(sl(), sl(), sl(), sl(), sl()),
  );

  sl.registerFactory(
    () => FavoriteDetailBloc(sl(), sl(), sl(), sl()),
  );

  sl.registerFactory(
    () => FavoriteListBloc(sl(), sl(), sl(), sl(), sl(), sl()),
  );

  sl.registerFactory(
    () => InquiryBloc(),
  );

  sl.registerFactory(
    () => SearchInputBloc(sl(), sl()),
  );

  sl.registerFactory(
    () => QuestionBloc(sl(), sl()),
  );

  /// inject [MyPageBloc]
  sl.registerFactory(() => MyPageBloc(sl(), sl(), sl()));

  /// RequestQuotationBloc
  sl.registerFactory(() => QuotationListBloc(sl()));

  /// Quotation Detail Bloc
  sl.registerFactory(() =>
      MessageBoardBloc(sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl()));

  /// inject [InviteFriendBloc]
  sl.registerFactory(() => InviteBloc(sl()));

  /// Sell Car Bloc
  sl.registerFactory(() => SellCarBloc(sl(), sl(), sl(), sl(), sl()));

  /// inject [StoreBloc]
  sl.registerFactory(() => StoreBloc(sl()));

  /// inject [QuotationBloc]
  sl.registerFactory(() => QuotationBloc(sl(), sl(), sl(), sl(), sl(), sl()));

  /// inject [NewAQuestionBloc]
  sl.registerFactory(() => NewQuestionBloc(sl(), sl(), sl(), sl(), sl(), sl()));

  /// inject [CarInformationBloc]
  sl.registerFactory(() => CarRegisBloc(
        sl(),
        sl(),
        sl(),
        sl(),
        sl(),
        sl(),
        sl(),
        sl(),
      ));

  /// inject [Inform list]
  sl.registerFactory(() => InformListBloc(sl()));

  /// inject [Inform Detail]
  sl.registerFactory(() => InformDetailBloc(sl(), sl()));

//History
  sl.registerFactory(
    () => HistoryBloc(sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => PostLogin(sl()));
  sl.registerLazySingleton(() => CheckUserAvailable(sl()));
  sl.registerLazySingleton(() => GetAgreement(sl()));
  sl.registerLazySingleton(() => SendMailNewUser(sl()));
  sl.registerLazySingleton(() => NewUserRegistration(sl()));
  sl.registerLazySingleton(() => GetAbout(sl()));
  sl.registerLazySingleton(() => NewUserAuthentication(sl()));
  sl.registerLazySingleton(() => RequestRegister(sl()));
  sl.registerLazySingleton(() => PersonalRegister(sl()));
  sl.registerLazySingleton(() => GetName(sl()));
  sl.registerLazySingleton(() => GetMakerList(sl()));
  sl.registerLazySingleton(() => GetCarList(sl()));
  sl.registerLazySingleton(() => GetNumberOfUnread(sl()));
  sl.registerLazySingleton(() => CompanyGet(sl()));
  sl.registerLazySingleton(() => GetBodyList(sl()));
  sl.registerLazySingleton(() => GetSearchList(sl()));
  sl.registerLazySingleton(() => GetCarPic1(sl()));
  sl.registerLazySingleton(() => GetNumberOfQuotationToday(sl()));
  sl.registerLazySingleton(() => GetFavoriteAccess(sl()));
  sl.registerLazySingleton(() => GetSeachDetail(sl()));
  sl.registerLazySingleton(() => GetFavoriteDetail(sl()));
  sl.registerLazySingleton(() => GetFavoriteList(sl()));
  sl.registerLazySingleton(() => GetFavoriteHistoryAccess(sl()));
  sl.registerLazySingleton(() => GetCarPic1InFavorite(sl()));
  sl.registerLazySingleton(() => GetQuestion(sl()));
  sl.registerLazySingleton(() => DeleteQuestion(sl()));
  sl.registerLazySingleton(() => GetMyPageInformation(sl()));
  sl.registerLazySingleton(() => SaveMyPageInformation(sl()));
  sl.registerLazySingleton(() => GetUserCarNameList(sl()));
  sl.registerLazySingleton(() => GetQuotationList(sl()));
  sl.registerLazySingleton(() => GetCarDetail(sl()));
  sl.registerLazySingleton(() => GetMessageBoard(sl()));
  sl.registerLazySingleton(() => GetListImageSellCar(sl()));
  sl.registerLazySingleton(() => PostSellCar(sl()));
  sl.registerLazySingleton(() => DeletePhotoAfterPostedSellCar(sl()));
  sl.registerLazySingleton(() => UploadPhotoSellCar(sl()));
  sl.registerLazySingleton(() => SellCarGetLocalData(sl()));
  sl.registerLazySingleton(() => InviteFriend(sl()));
  sl.registerLazySingleton(() => GetStoreInformation(sl()));
  sl.registerLazySingleton(() => MakeAnInquiry(repository: sl()));
  sl.registerLazySingleton(() => PostNewQuestionNow(sl()));
  sl.registerLazySingleton(() => GetUserInfo(sl()));
  sl.registerLazySingleton(() => GetLocalData(sl()));
  sl.registerLazySingleton(() => GetNewQuestionCarList(sl()));
  sl.registerLazySingleton(() => DeletePhotoAfterPosted(sl()));
  sl.registerLazySingleton(() => UploadPhoto(sl()));
  sl.registerLazySingleton(() => UploadPhotoUseCase(sl()));
  sl.registerLazySingleton(() => UploadPhotoCarRegis(sl()));
  sl.registerLazySingleton(() => DeletePhotoCarRegis(sl()));
  sl.registerLazySingleton(() => SendNewComment(sl()));
  sl.registerLazySingleton(() => DeletePhoto(sl()));
  sl.registerLazySingleton(() => GetInformList(sl()));
  sl.registerLazySingleton(() => UpdateStatusInform(sl()));
  sl.registerLazySingleton(() => MoveToCarDetail(sl()));
  sl.registerLazySingleton(() => PostPushId(sl()));
  sl.registerLazySingleton(() => GetListImage(sl()));
  sl.registerLazySingleton(() => PostOwnCar(sl()));
  sl.registerLazySingleton(() => DeleteOwnCar(sl()));
  sl.registerLazySingleton(() => GetListRIKUJI(sl()));
  sl.registerLazySingleton(() => GetItemSearchHistoryList(sl()));
  sl.registerLazySingleton(() => GetSearchInputHistoryList(sl()));
  sl.registerLazySingleton(() => AddFavoriteSearchDetail(sl()));
  sl.registerLazySingleton(() => DeleteFavoriteSearchDetail(sl()));
  sl.registerLazySingleton(() => GetFavoriteListSeachDetail(sl()));
  sl.registerLazySingleton(() => AddFavoriteQuotation(sl()));
  sl.registerLazySingleton(() => DeleteFavoriteQuotation(sl()));
  sl.registerLazySingleton(() => GetFavoriteListQuotation(sl()));
  sl.registerLazySingleton(() => AddFavoriteMessageBoard(sl()));
  sl.registerLazySingleton(() => DeleteFavoriteMessageBoard(sl()));
  sl.registerLazySingleton(() => GetFavoriteListLocalMessageBoard(sl()));
  sl.registerLazySingleton(() => AddAllCarList(sl()));
  sl.registerLazySingleton(() => AddAllCarBodyList(sl()));
  sl.registerLazySingleton(() => DeleteCarList(sl()));
  sl.registerLazySingleton(() => DeleteCarBodyList(sl()));
  sl.registerLazySingleton(() => AddCar(sl()));
  sl.registerLazySingleton(() => DeleteFavoriteByPosition(sl()));
  sl.registerLazySingleton(() => GetCarObjectList(sl()));
  sl.registerLazySingleton(() => RemoveCar(sl()));
  sl.registerLazySingleton(() => GetListSearchLocal(sl()));
  sl.registerLazySingleton(() => GetSearchHistory(sl()));
  sl.registerLazySingleton(() => UpdateSearch(sl()));
  sl.registerLazySingleton(() => AddSearch(sl()));
  sl.registerLazySingleton(() => AddCarObjectHistory(sl()));
  sl.registerLazySingleton(() => DeleteFavoriteByPositionHistory(sl()));
  sl.registerLazySingleton(() => GetCarObjectListHistory(sl()));
  sl.registerLazySingleton(() => GetSearchListHistory(sl()));
  sl.registerLazySingleton(() => RemoveCarHistory(sl()));
  sl.registerLazySingleton(() => AddCarSeenFavorite(sl()));
  sl.registerLazySingleton(() => DeleteFavoriteDetailByPosition(sl()));
  sl.registerLazySingleton(() => GetCarSeenFavoriteObjectList(sl()));
  sl.registerLazySingleton(() => GetCarFavoriteList(sl()));
  sl.registerLazySingleton(() => DeleteFavoriteListByPosition(sl()));
  sl.registerLazySingleton(() => GetCarListSearchFavorite(sl()));
  sl.registerLazySingleton(() => GetNameBeanFavorite(sl()));
  sl.registerLazySingleton(() => AddCarSeenFavoriteList(sl()));
  sl.registerLazySingleton(() => RemoveCarSeenFavoriteList(sl()));
  sl.registerLazySingleton(() => GetColorName(sl()));
  sl.registerLazySingleton(() => GetFavoriteSearchDetailAccess(sl()));

//History Repository
  sl.registerLazySingleton<HistoryRepository>(
      () => HistoryRepositoryImpl(sl(), sl()));

  // Login Repository
  sl.registerLazySingleton<LoginRepository>(
    () => LoginRepositoryImpl(
      loginDataSource: sl(),
    ),
  );

  // Agreement Repository
  sl.registerLazySingleton<AgreementRepository>(
    () => AgreementRepositoryImpl(
      agreementDataSource: sl(),
    ),
  );

  // User registration Repository
  sl.registerLazySingleton<UserRegistrationRepository>(
    () => UserRegistrationRepositoryImpl(
      userRegistrationDataSource: sl(),
    ),
  );

  // About repository
  sl.registerLazySingleton<AboutRepository>(
    () => AboutRepositoryImpl(
      aboutDataSource: sl(),
    ),
  );

  // User authentication repository
  sl.registerLazySingleton<NewUserAuthenticationRepository>(
    () => NewUserAuthenticationRepositoryImpl(
      aboutDataSource: sl(),
    ),
  );

  // Top repository
  sl.registerLazySingleton<SearchTopRepository>(
    () => SearchTopRepositoryImpl(
      topRemoteDataSource: sl(),
      topLocalDataSource: sl(),
    ),
  );
  // User MakerList repository
  sl.registerLazySingleton<MakerListRepository>(
    () => MakerListRepositoryImpl(
      makerListDataSource: sl(),
    ),
  );

  // User CarList repository
  sl.registerLazySingleton<CarListRepository>(
    () => CarListRepositoryImpl(
        carListLocalDataSource: sl(), carListRemoteDataSource: sl()),
  );
  // CarRegist repository
  sl.registerLazySingleton<CarRegistRepository>(
    () => CarRegisRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      carRegisPhotoRemoteDataSource: sl(),
    ),
  );
// Body List repository
  sl.registerLazySingleton<BodyListRepository>(
    () => BodyListRepositoryImpl(
        bodyListRemoteDataSource: sl(), bodyListLocalDataSource: sl()),
  );

  // Search List repository
  sl.registerLazySingleton<SearchListRepository>(
    () => SearchListRepositoryImpl(
        searchListRemoteDataSource: sl(), searchListLocalDataSource: sl()),
  );
  sl.registerLazySingleton<SearchInputRepository>(
    () => SearchInputRepositoryImpl(searchInputLocalDataSource: sl()),
  );
  // Search Detail repository
  sl.registerLazySingleton<SearchDetailRepository>(
    () => SearchDetailRepositoryImpl(
        seachDetailDataSource: sl(), searchDetailLocalDataSource: sl()),
  );

  // Favorite Detail repository
  sl.registerLazySingleton<FavoriteDetailRepository>(
    () => FavoriteDetailRepositoryImpl(
        favoriteDetailDataSource: sl(), favoriteDetailLocalDataSource: sl()),
  );

  // Favorite List repository
  sl.registerLazySingleton<FavoriteListRepository>(
    () => FavoriteListRepositoryImpl(
        favoriteListDataSource: sl(), favoriteListLocalDataSource: sl()),
  );

  // Question repository
  sl.registerLazySingleton<QuestionRepository>(
    () => QuestionRepositoryImpl(
      agreementDataSource: sl(),
    ),
  );

  /// inject [MyPageRepository]
  sl.registerLazySingleton<MyPageRepository>(
    () => MyPageRepositoryImpl(dataSource: sl(), localDataSource: sl()),
  );

  /// Request Quotation Repository
  sl.registerLazySingleton<QuotationListRepository>(
    () => QuotationListImpl(
      quotationListDataSource: sl(),
    ),
  );

  ///
  sl.registerLazySingleton<MessageBoardRepository>(
    () => MessageBoardRepositoryImpl(
      photoRemoteDataSource: sl(),
      messageBoardLocalDataSource: sl(),
      dataSource: sl(),
    ),
  );

  ///
  sl.registerLazySingleton<InviteRepository>(
    () => InviteRepositoryImpl(
      dataSource: sl(),
    ),
  );

  ///
  sl.registerLazySingleton<SellCarRepository>(
    () => SellCarRepositoryImpl(
      sellCarRemoteDataSource: sl(),
      sellCarLocalDataSource: sl(),
      sellCarPhotoDataSource: sl(),
    ),
  );

  /// inject [StoreRepository]
  sl.registerLazySingleton<StoreRepository>(
    () => StoreRepositoryImpl(
      remoteDataSource: sl(),
    ),
  );

  /// inject [QuotationRepository]
  sl.registerLazySingleton<QuotationRepository>(
    () => QuotationRepositoryImpl(
        quotationDataSource: sl(), quotationLocalDataSource: sl()),
  );

  /// inject [NewQuestionRepository]
  sl.registerLazySingleton<NewQuestionRepository>(
    () => NewQuestionRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  /// inject [InformListRepository]
  sl.registerLazySingleton<InformListRepository>(
    () => InformListRepositoryImpl(
      dataSource: sl(),
    ),
  );

  /// inject [InformListRepository]
  sl.registerLazySingleton<InformDetailRepository>(
    () => InformDetailRepositoryImpl(
      dataSource: sl(),
    ),
  );

  /// inject [PhotoRepository]
  sl.registerLazySingleton<PhotoRepository>(() => PhotoRepositoryImpl(sl()));

  // Login data source
  sl.registerLazySingleton<LoginDataSource>(
    () => LoginDataSourceImpl(),
  );

  // Agreement data source
  sl.registerLazySingleton<AgreementDataSource>(
    () => AgreementDataSourceImpl(),
  );

  // User registration data source
  sl.registerLazySingleton<UserRegistrationDataSource>(
    () => UserRegistrationDataSourceImpl(),
  );

  // sl.registerLazySingleton<AboutDataSource>(
  //       () => AboutDataSourceImpl(),
  // );

  // User authentication data source
  sl.registerLazySingleton<NewUserAuthenticationDataSource>(
    () => NewUserAuthenticationDataSourceImpl(),
  );

  // User authentication data source
  sl.registerLazySingleton<SearchTopRemoteDataSource>(
    () => TopRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<SearchTopLocalDataSource>(
    () => SearchTopLocalDataSourceImpl(),
  );
  sl.registerLazySingleton<MakerListDataSource>(
    () => MakerListDataSourceImpl(),
  );

  sl.registerLazySingleton<CarListRemoteDataSource>(
    () => CarListRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<CarListLocalDataSource>(
    () => CarListLocalDataSourceImpl(),
  );

  sl.registerLazySingleton<BodyListRemoteDataSource>(
    () => BodyListRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<BodyListLocalDataSource>(
    () => BodyListLocalDataSourceImpl(),
  );

  sl.registerLazySingleton<SearchListRemoteDataSource>(
    () => SearchListRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<SearchListLocalDataSource>(
    () => SearchListLocalDataSourceImpl(),
  );
  sl.registerLazySingleton<SearchDetailDataSource>(
    () => SearchDetailDataSourceImpl(),
  );
  sl.registerLazySingleton<SearchDetailLocalDataSource>(
      () => SearchDetailLocalDataSourceImpl());
  sl.registerLazySingleton<SearchInputLocalDataSource>(
    () => SearchInputLocalDataSourceImpl(),
  );
  sl.registerLazySingleton<FavoriteDetailDataSource>(
    () => FavoriteDetailDataSourceImpl(),
  );
  sl.registerLazySingleton<FavoriteDetailLocalDataSource>(
    () => FavoriteDetailLocalDataSourceImpl(),
  );
  sl.registerLazySingleton<FavoriteListDataSource>(
    () => FavoriteListDataSourceImpl(),
  );
  sl.registerLazySingleton<FavoriteListLocalDataSource>(
    () => FavoriteListLocalDataSourceImpl(),
  );
  sl.registerLazySingleton<QuestionDataSource>(
    () => QuestionDataSourceImpl(),
  );

  sl.registerLazySingleton<MyPageDataSource>(
    () => MyPageDataSourceImpl(),
  );
  sl.registerLazySingleton<MyPageLocalDataSource>(
    () => MyPageLocalDataSourceImpl(),
  );
  sl.registerLazySingleton<CarRegisDataSource>(
    () => CarRegisRepositoryDataSourceImpl(),
  );
  sl.registerLazySingleton<CarRegisLocalDataSource>(
    () => CarRegisLocalDataSourceImpl(),
  );
  sl.registerLazySingleton<QuotationListDataSource>(
    () => QuotationListDataSourceImpl(),
  );

  sl.registerLazySingleton<MessageBoardRemoteDataSource>(
    () => MessageBoardRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<MessageBoardLocalDataSource>(
    () => MessageBoardLocalDataSourceImpl(),
  );
  sl.registerLazySingleton<InviteDataSource>(
    () => InviteDataSourceImpl(),
  );

  sl.registerLazySingleton<SellCarRemoteDataSource>(
    () => SellCarRemoteDataSourceImpl(),
  );

  sl.registerLazySingleton<SellCarPhotoDataSource>(
    () => SellCarPhotoDataSourceImpl(),
  );

  sl.registerLazySingleton<SellCarLocalDataSource>(
    () => SellCarLocalDataSourceImpl(),
  );

  sl.registerLazySingleton<StoreRemoteDataSource>(
    () => StoreRemoteDataSourceImpl(),
  );

  sl.registerLazySingleton<QuotationDataSource>(
    () => QuotationDataSourceImpl(),
  );
  sl.registerLazySingleton<QuotationLocalDataSource>(
    () => QuotationLocalDataSourceImpl(),
  );

  sl.registerLazySingleton<NewQuestionRemoteDataSource>(
    () => NewQuestionRemoteDataSourceImpl(),
  );

  sl.registerLazySingleton<NewQuestionLocalDataSource>(
    () => NewQuestionLocalDataSourceImpl(),
  );

  sl.registerLazySingleton<PhotoRemoteDataSource>(
    () => PhotoRemoteDataSourceImpl(),
  );

  sl.registerLazySingleton<CarRegisPhotoRemoteDataSource>(
    () => CarRegisPhotoRemoteDataSourceImpl(),
  );

  sl.registerLazySingleton<InformListRemoteDataSource>(
    () => InformListRemoteDataSourceImpl(),
  );

  sl.registerLazySingleton<InformDetailRemoteDataSource>(
    () => InformDetailRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<HistoryLocalDataSource>(
    () => HistoryLocalDataSourceImpl(),
  );

  sl.registerLazySingleton<HistoryRemoteDataSource>(
    () => HistoryRemoteDataSourceImpl(),
  );
  //! Core
  sl.registerLazySingleton(() => InputConverter());
  sl.registerLazySingleton(() => NetworkResponse());
  sl.registerLazySingleton(() => UserSecureStorage());
  sl.registerLazySingleton(() => HelperFunction());
  sl.registerLazySingleton(() => InternetConnection());
  sl.registerLazySingleton(() => Logging());

  //! External
  sl.registerLazySingleton(() => BaseStorage()); // SharedPreferences
  await BaseStorage.instance.init(); // init SharedPreferences
  sl.registerLazySingleton(() => Boxes()); // HiveDb Box
  sl.registerLazySingleton(() => DbService()); // HiveDb Service
  await DbService.instance.initHiveDB(); // Init HiveDB
  BaseDio(hostUrl: Common.serverUrl);
  ProcessUtil(); // SharedPreferences
}
