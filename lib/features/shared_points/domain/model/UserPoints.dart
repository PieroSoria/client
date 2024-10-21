class UserPoints {
  String? fName;
  String? lName;
  String? points;
  String? refCode;
  String? message;

  UserPoints({
    this.fName,
    this.lName,
    this.points,
    this.refCode,
    this.message,
  });

  UserPoints.fromJson(Map<String, dynamic> json) {
    fName = json['f_name'];
    lName = json['l_name'];
    points = json['amount'];
    refCode = json['ref_code'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['f_name'] = fName;
    data['l_name'] = lName;
    data['points'] = points;
    data['ref_code'] = refCode;
    data['message'] = message;
    return data;
  }
}
