class SearchInputModel {
  bool checkBox1Checked;
  bool checkBox2Checked;
  bool checkBox3Checked;
  bool checkBox4Checked;
  bool checkBox5Checked;
  String? nenshiki1;
  String? nenshiki2;
  String? distance1;
  String? distance2;
  String? haikiryou1;
  String? haikiryou2;
  String? price1;
  String? price2;
  String inspection;
  String repair;
  String mission;
  String freeword;
  String color;
  String area;

  int? callCount;
  String? makerCode1;
  String? makerCode2;
  String? makerCode3;
  String? makerCode4;
  String? makerCode5;
  String? carName1;
  String? carName2;
  String? carName3;
  String? carName4;
  String? carName5;
  SearchInputModel(
      {this.checkBox1Checked = false,
      this.checkBox2Checked = false,
      this.checkBox3Checked = false,
      this.checkBox4Checked = false,
      this.checkBox5Checked = false,
      this.nenshiki1,
      this.nenshiki2,
      this.distance1,
      this.distance2,
      this.haikiryou1,
      this.haikiryou2,
      this.price1,
      this.price2,
      this.inspection = '',
      this.mission = '',
      this.freeword = '',
      this.color = '',
      this.repair = '',
      this.area = '',
      this.callCount,
      this.makerCode1,
      this.makerCode2,
      this.makerCode3,
      this.makerCode4,
      this.makerCode5,
      this.carName1,
      this.carName2,
      this.carName3,
      this.carName4,
      this.carName5});
}
