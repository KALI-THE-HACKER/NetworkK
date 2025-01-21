import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class StartupDetailPage extends StatefulWidget {
  final int startupId;

  const StartupDetailPage({required this.startupId, Key? key}) : super(key: key);

  @override
  _StartupDetailPageState createState() => _StartupDetailPageState();
}

class _StartupDetailPageState extends State<StartupDetailPage> {
  bool isLoading = true;
  Map<String, dynamic>? startupData;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchStartupDetails();
  }

  Future<void> _fetchStartupDetails() async {
    final url = 'https://networkk.onrender.com:/details/${widget.startupId}';
    print('Fetching from URL: $url');

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      print("Response Status Code: ${response.statusCode}");
      if (response.statusCode == 200) {
        setState(() {
          startupData = json.decode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load data: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'An error occurred: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(235, 255, 255, 255),
      appBar: AppBar(
        title: const Text('Startup Details'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(
                  child: Text(
                    errorMessage!,
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Startup Name and Description
                          Text(
                            startupData!['name'] ?? 'No Name',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            startupData!['desc'] ?? 'No Description',
                            style: const TextStyle(fontSize: 16, color: Colors.black),
                          ),
                          const SizedBox(height: 16),
                          const Divider(),

                          // Founder Information
                          const Text(
                            'Founder',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Username: ${startupData!['founder']['username']}',
                            style: const TextStyle(fontSize: 16, color: Colors.black),
                          ),
                          Text(
                            'Email: ${startupData!['founder']['email'] ?? 'N/A'}',
                            style: const TextStyle(fontSize: 16, color: Colors.black),
                          ),
                          const SizedBox(height: 16),
                          const Divider(),

                          // Openings
                          const Text(
                            'Openings',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          if ((startupData!['openings'] as List).isNotEmpty)
                            ...List.generate(
                              (startupData!['openings'] as List).length,
                              (index) {
                                final opening = startupData!['openings'][index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text(
                                    '- Position: ${opening['position']}\n  Description: ${opening['pos_desc'] ?? 'No description'}',
                                    style: const TextStyle(fontSize: 16, color: Colors.black),
                                  ),
                                );
                              },
                            )
                          else
                            const Text('No Openings Available', style: TextStyle( color: Colors.black),),
                          const SizedBox(height: 16),
                          const Divider(),

                          // Applications
                          const Text(
                            'Applications',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          if ((startupData!['applications'] as List).isNotEmpty)
                            ...List.generate(
                              (startupData!['applications'] as List).length,
                              (index) {
                                final application = startupData!['applications'][index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text(
                                    '- Applicant: ${application['student_name']}\n  Position: ${application['position']}\n  Status: ${application['status']}\n  Applied At: ${application['applied_at'] ?? 'N/A'}',
                                    style: const TextStyle(fontSize: 16, color: Colors.black),
                                  ),
                                );
                              },
                            )
                          else
                            const Text('No Applications Found', style: TextStyle(color: Colors.black),),
                        ],
                      ),
                    ),
                  ),
                ),
    );
  }
}
