import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'data_model.dart';
import 'package:networkk/home_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? uname;
  String responseMessage = '';

  @override
  void initState() {
    super.initState();
    var box = Hive.box('userDataBox');
    uname =box.get('username');
    fetchData();
  }

  Future<List<StartupData>> fetchData() async {
    final response = await http.get(Uri.parse('http://10.53.15.225:8000/home/'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((e) => StartupData.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load album');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(235, 255, 255, 255),
      body: SafeArea(
        child: FutureBuilder<List<StartupData>>(
          future: fetchData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              final startups = snapshot.data!;
              
              return CustomScrollView(
                slivers: [
                  // Header Section as SliverToBoxAdapter
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Hi, $uname',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                '👋',
                                style: TextStyle(fontSize: 24),
                              ),
                            ],
                          ),
                          Text(
                            'Explore the Startups around campus',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // List Section as SliverList
                  SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final startup = startups[index];
                          return Card(
                            margin: EdgeInsets.only(bottom: 12.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                image: DecorationImage(
                                  image: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQyKNAB33tfPkHBfJuzwsQM_TArlz4b2t19bw&s'),
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
                        childCount: startups.length,
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return Center(child: Text('No data found'));
            }
          },
        ),
      ),
    );
  }
}