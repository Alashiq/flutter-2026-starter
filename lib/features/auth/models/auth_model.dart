import 'package:starter/features/city/models/city_model.dart';

class AuthModel {
  final int id;
  final String name;
  final String? description;
  final double? latitude;
  final double? longitude;
  final int status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  AuthModel({
    required this.id,
    required this.name,
    this.description,
    this.latitude,
    this.longitude,
    required this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'بدون اسم',
      description: json['description'],
      latitude: double.tryParse(json['latitude']?.toString() ?? ''),
      longitude: double.tryParse(json['longitude']?.toString() ?? ''),
      status: json['status'] ?? 0,
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? ''),
      updatedAt: DateTime.tryParse(json['updated_at']?.toString() ?? ''),
    );
  }
}
