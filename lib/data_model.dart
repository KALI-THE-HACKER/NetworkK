class StartupData {
  final String name;
  final String description;
  final String founder;

  StartupData({
    required this.name,
    required this.description,
    required this.founder,
  });

  factory StartupData.fromJson(Map<String, dynamic> json) {
    return StartupData(
      name: json['name'] ?? 'No name available',
      description: json['desc'] ?? 'No description available',
      founder: json['founder'] ?? 'Unknown',
    );
  }
}
