class AuthModel {
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? photo;
  final String? city;
  final String? token;
  final int? point;
  final num? balance;
  final int? notifications;
  final int status;

  AuthModel({
    this.firstName,
    this.lastName,
    this.phone,
    this.photo,
    this.city,
    this.token,
    this.point,
    this.balance,
    this.notifications,
    required this.status,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      firstName: json['firstname'],
      lastName: json['lastname'],
      phone: json['phone'],
      photo: json['photo'],
      city: json['city'],
      token: json['token'],
      point: json['point'] != null
          ? int.tryParse(json['point'].toString())
          : null,
      balance: json['balance'] != null
          ? num.tryParse(json['balance'].toString())
          : null,
      notifications: json['notifications'] != null
          ? int.tryParse(json['notifications'].toString())
          : null,
      status: json['status'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstname': firstName,
      'lastname': lastName,
      'phone': phone,
      'photo': photo,
      'token': token,
      'point': point,
      'balance': balance,
      'notifications': notifications,
      'status': status,
    };
  }
}
