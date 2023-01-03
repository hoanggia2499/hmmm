class ItemCarPic1Model {
  String corner;
  String pic1;

  ItemCarPic1Model({this.corner = '', this.pic1 = ''});

  factory ItemCarPic1Model.fromJson(Map<String, dynamic> json) {
    return ItemCarPic1Model(
      corner: json['corner'] ?? '',
      pic1: json['pic1'] ?? '',
    );
  }
}
