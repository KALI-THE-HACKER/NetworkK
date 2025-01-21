import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'detailed_view.dart';

class DataModel {
  final int id;
  final String name;
  final String desc;

  DataModel({required this.id, required this.name, required this.desc});

  factory DataModel.fromJson(Map<String, dynamic> json) {
    return DataModel(
      id: json['id'] ?? 1,
      name: json['name'] ?? 'No Name',
      desc: json['desc'] ?? 'No Description',
    );
  }
}

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<DataModel> _searchResults = [];
  bool _isLoading = false;
  String _error = '';

  Future<void> _performSearch(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _error = '';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      final response = await http.get(
        Uri.parse('https://networkk.onrender.com:/search?query=${Uri.encodeComponent(query)}'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        setState(() {
          _searchResults = data.map((item) => DataModel.fromJson(item)).toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'Failed to fetch results';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'An error occurred: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(235, 255, 255, 255),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search...',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () => _performSearch(_searchController.text),
                ),
                border: OutlineInputBorder(),
              ),
              onSubmitted: _performSearch,
            ),
            SizedBox(height: 16),
            if (_isLoading)
              Center(child: CircularProgressIndicator())
            else if (_error.isNotEmpty)
              Text(
                _error,
                style: TextStyle(color: Colors.red),
              )
            else
              Expanded(
  child: _searchResults.isNotEmpty
      ? ListView.builder(
          itemCount: _searchResults.length,
          itemBuilder: (context, index) {
            final result = _searchResults[index];
            return GestureDetector(
              onTap: () {
                // Handle click event here
                // For example, navigate to a new page or show more details
                print('Clicked on: ${result.name}');
                // Navigate to another screen with result details:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StartupDetailPage(startupId: result.id),
                  ),
                );
              },
              child: Card(
                margin: EdgeInsets.only(bottom: 12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                      image: NetworkImage(
                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQyKNAB33tfPkHBfJuzwsQM_TArlz4b2t19bw&s'),
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
                          result.name,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text('Description: ${result.desc}'),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        )
      : Center(
          child: Text(
            "No data",
            style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
          ),
        ),
),

          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
