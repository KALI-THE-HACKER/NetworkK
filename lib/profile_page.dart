import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'data_model.dart';
import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';

class ProfilePage extends StatefulWidget {
   final String initialBio;
  final Function(String) onSave;

  const ProfilePage({
    Key? key,
    required this.initialBio,
    required this.onSave,
  }) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<Map<String, dynamic>> _futureData;
    late TextEditingController _bioController;
  bool _isEditing = false;
  bool _hasChanges = false;
  String _originalBio = '';

  @override
  void initState() {
    super.initState();
    _originalBio = widget.initialBio;
    _bioController = TextEditingController(text: widget.initialBio);
    _bioController.addListener(_onTextChanged);
    _futureData = fetchData();
  }

  void _onTextChanged() {
    setState(() {
      _hasChanges = _bioController.text != _originalBio;
    });
  }

  @override
  void dispose() {
    _bioController.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
      if (!_isEditing) {
        _bioController.text = _originalBio;
        _hasChanges = false;
      }
    });
  }

  void _saveBio() {
    widget.onSave(_bioController.text);
    setState(() {
      _originalBio = _bioController.text;
      _isEditing = false;
      _hasChanges = false;
    });
  }



  Future<Map<String, dynamic>> fetchData() async {
    final response = await http.get(Uri.parse('https://networkk.onrender.com:/profile/'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      final userdata = jsonData.map((e) => UserData.fromJson(e as Map<String, dynamic>)).toList();

      // Retrieve username from Hive
      var box = await Hive.openBox('userDataBox');
      String? username = box.get('username');

      // Find user index
      final userIndex = userdata.indexWhere((user) => user.username == username);
      if (userIndex == -1) throw Exception("User not found");

      return {'userdata': userdata, 'userIndex': userIndex};
    } else {
      throw Exception('Failed to fetch user data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(235, 255, 255, 255),
      body: SafeArea(
        child: FutureBuilder<Map<String, dynamic>>(
          future: _futureData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              final userdata = snapshot.data!['userdata'] as List<UserData>;
              final userIndex = snapshot.data!['userIndex'] as int;
              final ud = userdata[userIndex];

              return CustomScrollView(
                slivers: [
                  // Profile Header Section
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(30),
                            height: 130,
                            width: 350,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),),
                            child: Column(
                              children : [ Text(
                              '${ud.username}'.toUpperCase(),
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: const Color.fromARGB(172, 0, 0, 0),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '${ud.email}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          )]
                            
                      ))],
                      ),
                    ),
                  ),

                  // Bio Section
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(50, 86, 142, 245),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Bio',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: Icon(_isEditing ? Icons.close : Icons.edit),
                onPressed: _toggleEdit,
                splashRadius: 20,
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (_isEditing) ...[
            TextField(
              controller: _bioController,
              maxLines: 4,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter your bio...',
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _hasChanges ? _saveBio : null,
              child: const Text('Save'),
            ),
          ] else
            Text(_originalBio),
        ],
      ),
                      ),
                    ),
                  ),

                  // My Startups Section
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'My Startups',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),

                  // Startups List Section
                  SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final startup = ud.foundedStartups![index];
                          return Card(
                            margin: EdgeInsets.only(bottom: 12.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                image: DecorationImage(
                                  image: NetworkImage(
                                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQyKNAB33tfPkHBfJuzwsQM_TArlz4b2t19bw&s',
                                  ),
                                  opacity: 0.5,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      startup.name,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text('Description: ${startup.description}'),
                                    SizedBox(height: 4),
                                    // Text('Founder: ${startup.founder}'),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        childCount: ud.foundedStartups?.length ?? 0,
                      ),
                    ),
                  ),

                  SliverPadding(
                    padding: EdgeInsets.only(bottom: 80),
                  ),
                ],
              );
            }

            return Center(child: Text('No data available'));
          },
        ),
      ),
    );
  }
}
