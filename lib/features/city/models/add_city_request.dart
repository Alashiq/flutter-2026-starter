class AddCityRequest {
  final String name;
  final String? description;

  AddCityRequest({required this.name, this.description});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      if (description != null && description!.isNotEmpty)
        'description': description,
    };
  }
}
