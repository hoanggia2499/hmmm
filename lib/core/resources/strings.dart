class UI {
  static const String prefix = "key_ui";

  static const String app_name = "$prefix.app_name";
}

class ErrorMessage {
  static const String prefix = "key_error";

  static const String msg_error_change_language =
      "$prefix.msg_error_change_language";
}

class Message {
  static const String prefix = "key_message";

  static const String remove_message = "$prefix.remove_message";
}

class MyPageValues {
  static const List<String> genderValues = ['男性', '女性', '法人'];

  static const List<String> budgetValues = [
    '50万未満',
    '100万未満',
    '200万未満',
    '300万未満',
    '400万未満',
    '400万以上'
  ];

  static const List<String> jobCodeValues = [
    '会社員',
    '会社役員・経営',
    '公務員（教職員を除く）',
    '教職員',
    '医師・医療関係者（病院経営・開業医含む）',
    '自営業',
    '学生',
    '主婦/主夫',
    'フリーター（パート・アルバイト）',
    '無職',
    'その他'
  ];

  static const List<String> familyValues = [
    '単身',
    '２人',
    '３人',
    '４人',
    '５人',
    '６人以上'
  ];
}

class QuestionPageValues {
  static const List<String> itemsSortOrder = [
    "日付順",
    "見積依頼日付順",
    "来店予約日付順",
    "車両問合せ日付順",
    "査定依頼日付順",
    "修理・整備日付順",
    "車検日付順",
    "パーツ購入・取付日付順",
    "その他日付順"
  ];
}

class MakerCodeValues {
  static const Map<String, String> hiraganaAlphabetRegexList = <String, String>{
    'ア': r'ア|イ|ウ|ヴ|エ|オ',
    'カ': r'カ|ガ|キ|ギ|ク|グ|ケ|ゲ|グ|コ|ゴ',
    'サ': r'サ|ザ|シ|ジ|ス|ズ|セ|ゼ|ソ|ゾ|そ',
    'タ': r'タ|ダ|チ|ツ|テ|デ|ト|ド',
    'ナ': r'ナ|ニ|ヌ|ネ|ノ',
    'ハ': r'ハ|バ|パ|ヒ|ビ|ピ|フ|ブ|プ|ヘ|ベ|ペ|ホ|ボ|ポ',
    'マ': r'マ|ミ|ム|メ|モ',
    'ヤ': r'ヤ|ユ|ヨ',
    'ラ': r'ラ|リ|ル|レ|ロ',
    'ワ': r'ワ|ヲ|ン',
    '英数': r"[0-9a-zA-Z].*"
  };
}
