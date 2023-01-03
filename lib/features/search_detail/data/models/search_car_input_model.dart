class SearchCarInputModel {
  String memberNum;
  int userNum;
  String corner;
  int aACount;
  String exhNum;
  String carNo;
  int makerCode;

  SearchCarInputModel(
      {this.corner = '',
      this.exhNum = '',
      this.makerCode = 0,
      this.memberNum = '',
      this.userNum = 0,
      this.aACount = 0,
      this.carNo = ''});
}
