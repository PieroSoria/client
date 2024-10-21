class SocialLogInBody {
  String? email;
  String? token;
  String? uniqueId;
  String? medium;
  String? phone;
  String? deviceToken;
  String? birthday;
  String? gender;
  String? departamentId;
  String? provinceId;
  String? districtId;
  SocialLogInBody({
    this.email,
    this.token,
    this.uniqueId,
    this.medium,
    this.phone,
    this.deviceToken,
    this.birthday,
    this.gender,
    this.departamentId,
    this.provinceId,
    this.districtId,
  });

  SocialLogInBody.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    token = json['token'];
    uniqueId = json['unique_id'];
    medium = json['medium'];
    phone = json['phone'];
    deviceToken = json['cm_firebase_token'];
    birthday = json['birthday'];
    gender = json['gender'];
    departamentId = json['departament_id'];
    provinceId = json['province_id'];
    districtId = json['district_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['token'] = token;
    data['unique_id'] = uniqueId;
    data['medium'] = medium;
    data['phone'] = phone;
    data['cm_firebase_token'] = deviceToken;
    data['birthday'] = birthday;
    data['gender'] = gender;
    data['departament_id'] = departamentId;
    data['province_id'] = provinceId;
    data['district_id'] = districtId;
    return data;
  }
}
