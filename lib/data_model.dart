class UserData {
  final String username;
  final String email;
  final List<StartupData> foundedStartups;
  // final List<dynamic> applications;
  

  UserData({
    required this.username,
    required this.email,
    required this.foundedStartups,
    // required this.applications,
  });


  factory UserData.fromJson(Map<String, dynamic> json) {
    var startupsList = json['founded_startups'] as List;
    List<StartupData> startupItems = startupsList.map((startup) => StartupData.fromJson(startup)).toList();

    return UserData(
      username: json['username'] ?? 'Name not found!',
      email: json['email'] ?? 'Email not found!',
      foundedStartups: startupItems,
    );
  }

  @override
    String toString() {
      return 'UserData(username: $username, email: $email, foundedStartups: $foundedStartups)';
}
}

class Founder {
  final String username;

  Founder({required this.username});

  factory Founder.fromJson(Map<String, dynamic> json) {
    return Founder(username: json['username']);
  }
  
}

class StartupData {
  final String name;
  final String description;
  // final Founder founder;

  StartupData({
    required this.name,
    required this.description,
    // required this.founder,
  });

  factory StartupData.fromJson(Map<String, dynamic> json) {
    return StartupData(
      name: json['name'] ?? 'No name available',
      description: json['desc'] ?? 'No description available',
      // founder: Founder.fromJson(json['founder']),
    );
  }
}

