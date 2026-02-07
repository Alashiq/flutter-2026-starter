class CityListModel {
  final int id;
  final String name;
  final String? description;
  final int status;

  CityListModel({
    required this.id,
    required this.name,
    this.description,
    required this.status,
  });

  factory CityListModel.fromJson(Map<String, dynamic> json) {
    return CityListModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'بدون اسم',
      description: json['description'],
      status: json['status'] ?? 0,
    );
  }
}
