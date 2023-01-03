import 'app_properties.dart';

class Common {
  static final bool isDebugMode = AppProperties.instance.isDebugMode;
  //アプリケーションサーバーのURL
  static final String apSrvURL = AppProperties.instance.apSrvURL;
  //画像サーバーのURL
  static final String imgSrvURL = AppProperties.instance.imgSrvURL;
  // サーバーのURL
  static final String serverUrl = apSrvURL + '/MirukuruApi';

  static final String apiGetQuestion = serverUrl + '/Question'; //API31
  static final String apiDeleteQuestion = serverUrl + '/Comment'; //API14

  // App resource
  static final String appUrl = '/App';
  static final String apiGetAgreement = appUrl + '/Agreement'; //API01
  static final String apiGetPolicyAgreement =
      appUrl + '/PolicyAgreement'; //API02
  static final String apiLogin = appUrl + '/Login'; //API03
  static final String apiGetUserTerm = appUrl + '/UserTerm'; //API10
  static final String apiGetVersion = appUrl + '/Version'; //API22
  static final String apiGetNames = appUrl + '/Names'; //API27
  static final String apiPostVersion = appUrl + '/Version'; //API34
  static final String apiGetMailNewUser = appUrl + '/MailNewUser'; //API38
  static final String apiGetUserAuthentication =
      appUrl + '/UserAuthentication'; //API39
  static final String apiPostFile = appUrl + '/File'; //API49
  static final String apiUploadFile = appUrl + '/UploadFile'; //API49
  // ASNET resource
  static final String asNetUrl = '/ASNETCar'; //API04
  static final String apiGetCar = asNetUrl + '/Car'; //API18
  static final String apiGetPicture = asNetUrl + '/Picture'; //API19
  static final String apiGetCarPic1 = asNetUrl + '/CarPic1'; //API19
  // Master resource
  static final String masterUrl = '/Master';
  static final String apiGetBodyType = masterUrl + '/BodyType'; //API05
  static final String apiGetListCars = masterUrl + '/Cars'; //API006
  static final String apiGetCarsByMakerCode =
      masterUrl + '/CarsByMakerCode'; //API07
  static final String apiGetCarNamesV1 = masterUrl + '/CarNameV1'; //API08
  static final String apiGetCarNamesV2 = masterUrl + '/CarNameV2'; //API09
  static final String apiGetMaker = masterUrl + '/Maker'; //API25
  // Comment resource
  static final String listCommentsUrl = '/Comments'; //API11, API26
  static final String commentUrl = '/Comment'; //API12, API14,
  static final String apiNumberOfQuotationToday =
      commentUrl + '/NumberOfQuotationToday'; //API20
  static final String apiGetNumberOfUnread =
      commentUrl + '/NumberOfUnread'; //API21
  //
  static final String companyUrl = '/Company'; //API13
  static final String favoriteUrl = '/Favorite'; //API15 (GET), API16(POST)
  static final String imagesProcessUrl = '/Images'; //API17
  static final String listInformsUrl = '/Informs'; //API23
  static final String informUrl = '/Inform'; //API24
  // Question resource
  static final String listQuestionUrl = '/Question'; //API31
  static final String questionUrl = '/Question'; //API33
  static final String apiGetOwnCar = questionUrl + '/OwnCar'; //API28
  static final String apiDeleteListPhotos = questionUrl + '/Photos'; //API29
  static final String apiDeletePhoto = questionUrl + '/Photo'; //API30
  static final String apiGetEstimateRequests =
      questionUrl + '/EstimateRequests'; //API32
  // Search resource
  static final String searchUrl = '/Search';
  static final String apiGetSearchCar = searchUrl + '/Car'; //API35
  static final String apiGetFavoriteCar = searchUrl + '/FavoriteCar'; //API36
  static final String apiGetSearchCar2 = searchUrl + '/Cars'; //API37
  static final String ownCarUrl = '/OwnCar'; //API40(DELETE), API41(POST)
  // User resource
  static final String userUrl = '/User'; //API42, API43, API47, API48
  static final String apiPostPushId = userUrl + '/PushId'; //API44
  static final String apiPostPersonal = userUrl + '/Personal'; //API45
  static final String apiPostPretreatment = userUrl + '/Pretreatment'; //API46
  static final String apiPostInviteFriend = userUrl + '/Invite'; //API43
  // Other resource
  static String imageUrl = imgSrvURL + '/mirukuru/img/';
  static String imageUrlBase = imgSrvURL + '/'; //画像サーバー
  static String directoryName = 'kuruauto';
  static String userCarImagesUrl = imgSrvURL + '/UserCarImages/';
}
