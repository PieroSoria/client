class SignUpBodyModel {
  String? fName;
  String? lName;
  String? phone;
  String? email;
  String? password;
  String? refCode;
  String? birthday;
  String? gender;
  String? departamentId;
  String? provinceId;
  String? districtId;
  String? deviceToken;

  SignUpBodyModel({
    this.fName,
    this.lName,
    this.phone,
    this.email = '',
    this.password,
    this.refCode = '',
    this.birthday,
    this.gender,
    this.departamentId,
    this.provinceId,
    this.districtId,
    this.deviceToken,
  });

  SignUpBodyModel.fromJson(Map<String, dynamic> json) {
    fName = json['f_name'];
    lName = json['l_name'];
    phone = json['phone'];
    email = json['email'];
    password = json['password'];
    refCode = json['ref_code'];
    deviceToken = json['cm_firebase_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['f_name'] = fName;
    data['l_name'] = lName;
    data['phone'] = phone;
    data['email'] = email;
    data['password'] = password;
    data['birthday'] = birthday;
    data['gender'] = gender;
    data['departament_id'] = departamentId;
    data['province_id'] = provinceId;
    data['district_id'] = districtId;
    data['ref_code'] = refCode;
    data['cm_firebase_token'] = deviceToken;
    return data;
  }
}
