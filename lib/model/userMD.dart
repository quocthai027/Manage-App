class ApiResponse {
  late String success;
  late Data data;

  ApiResponse({required this.success, required this.data});

  ApiResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = Data.fromJson(json['data']);
  }
}

class Data {
  late String iss;
  late String aud;
  late int iat;
  late int nbf;
  late int exp;
  late UserData userData;

  Data({
    required this.iss,
    required this.aud,
    required this.iat,
    required this.nbf,
    required this.exp,
    required this.userData,
  });

  Data.fromJson(Map<String, dynamic> json) {
    iss = json['iss'];
    aud = json['aud'];
    iat = json['iat'];
    nbf = json['nbf'];
    exp = json['exp'];
    userData = UserData.fromJson(json['data']);
  }
}

class UserData {
  late int id;
 // late String username;
  late String name;
  late String role;
  late int status;

  UserData({
    required this.id,
  //  required this.username,
    required this.name,
    required this.role,
    required this.status,
  });

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
   // username = json['username'];
    name = json['name'];
    role = json['role'];
    status = json['status'];
  }
}
class UserDataPayment {
  late int id;
  late String username;
  late String name;
  late String role;
  late int status;

  UserDataPayment({
    required this.id,
    required this.username,
    required this.name,
    required this.role,
    required this.status,
  });

  UserDataPayment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    name = json['name'];
    role = json['role'];
    status = json['status'];
  }
}