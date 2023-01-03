import 'package:mirukuru/core/db/user_car_list_hive.dart';
import '../../../../core/db/boxes.dart';

abstract class MyPageLocalDataSource {
  Future<void> addUserCar(UserCarHive userCarHive, String tableName);
  Future<void> addAllUserCar(
      List<UserCarHive> userCarHiveList, String mobilePhone, String tableName);
  Future<List<UserCarHive>> getUserCarList(String tableName);
}

class MyPageLocalDataSourceImpl implements MyPageLocalDataSource {
  @override
  Future<void> addUserCar(UserCarHive userCarHive, String tableName) async {
    var box = await Boxes.instance.getBox(tableName);
    await box.add(userCarHive);
  }

  @override
  Future<void> addAllUserCar(List<UserCarHive> userCarHiveList,
      String mobilePhone, String tableName) async {
    for (UserCarHive userCarHive in userCarHiveList) {
      UserCarHive userCar = UserCarHive(
          memberNum: userCarHive.memberNum,
          userNum: userCarHive.userNum,
          userCarNum: userCarHive.userCarNum,
          carGrade: userCarHive.carGrade,
          plateNo1: userCarHive.plateNo1,
          plateNo2: userCarHive.plateNo2,
          plateNo3: userCarHive.plateNo3,
          plateNo4: userCarHive.plateNo4,
          platformNum: userCarHive.platformNum,
          makerCode: userCarHive.makerCode,
          carCode: userCarHive.carCode,
          nHokenInc: userCarHive.nHokenInc,
          carModel: userCarHive.carModel,
          sellTime: userCarHive.sellTime,
          inspectionDate: userCarHive.inspectionDate,
          nHokenEndDay: userCarHive.nHokenEndDay,
          colorName: userCarHive.colorName,
          mileage: userCarHive.mileage,
          mobilePhone: mobilePhone);

      await addUserCar(userCar, tableName);
    }
  }

  @override
  Future<List<UserCarHive>> getUserCarList(String tableName) async {
    return await Boxes.instance
        .getBox(tableName)
        .then((box) => box.values.toList().cast<UserCarHive>());
  }
}
