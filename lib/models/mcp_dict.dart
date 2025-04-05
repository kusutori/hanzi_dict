class McpDict {
  final String? unicode;
  final String? mc;
  final String? pu;
  final String? ct;
  final String? sh;
  final String? mn;
  final String? kr;
  final String? vn;
  final String? jpGo;
  final String? jpKan;
  final String? jpTou;
  final String? jpKwan;
  final String? jpOther;

  McpDict({
    this.unicode,
    this.mc,
    this.pu,
    this.ct,
    this.sh,
    this.mn,
    this.kr,
    this.vn,
    this.jpGo,
    this.jpKan,
    this.jpTou,
    this.jpKwan,
    this.jpOther,
  });

  // 从 JSON 创建对象
  factory McpDict.fromJson(Map<String, dynamic> json) {
    return McpDict(
      unicode: json['unicode'] as String?,
      mc: json['mc'] as String?,
      pu: json['pu'] as String?,
      ct: json['ct'] as String?,
      sh: json['sh'] as String?,
      mn: json['mn'] as String?,
      kr: json['kr'] as String?,
      vn: json['vn'] as String?,
      jpGo: json['jp_go'] as String?,
      jpKan: json['jp_kan'] as String?,
      jpTou: json['jp_tou'] as String?,
      jpKwan: json['jp_kwan'] as String?,
      jpOther: json['jp_other'] as String?,
    );
  }

  // 转换为 JSON
  Map<String, dynamic> toJson() {
    return {
      'unicode': unicode,
      'mc': mc,
      'pu': pu,
      'ct': ct,
      'sh': sh,
      'mn': mn,
      'kr': kr,
      'vn': vn,
      'jp_go': jpGo,
      'jp_kan': jpKan,
      'jp_tou': jpTou,
      'jp_kwan': jpKwan,
      'jp_other': jpOther,
    };
  }
}
