// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'data_model.dart';

class NetworkTheme {
  static ThemeData get theme => ThemeData(
        primaryColor: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          showSelectedLabels: true,
          showUnselectedLabels: true,
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          headlineMedium: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
          titleLarge: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.deepPurple,
          ),
        ),
      );
}

class NewpostPage extends StatefulWidget{

  

  const NewpostPage({super.key});
  @override
  State<NewpostPage> createState() => _NewpostPageState();
  
}

  class _NewpostPageState extends State<NewpostPage> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;


  void _submitPost() {
    var box = Hive.box('userDataBox');
    String uname = box.get('username');

    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      Future.delayed(const Duration(seconds: 2), () async{
        setState(() => _isLoading = false);
        // Show success message

        //Post request to send the content to the database
        Map<String, String> header = {'Content-Type': 'application/json; charset=UTF-8',
              };

        Map body = {
          'name' : _titleController.text ,
          'desc' :_descriptionController.text,
          'founder' : uname
          };

        var body_json = jsonEncode(body);

        var uri = Uri.parse('https://networkk.onrender.com/create/');

        try {
          await http.post(uri, body: body_json, headers: header);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Post created successfully!'),
                    backgroundColor: Colors.green,
                  ),
          );
        } on Exception catch (e) {throw Exception(e);
  // TODO
}
        // Clear form
        _titleController.clear();
        _descriptionController.clear();
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(data: NetworkTheme.theme,
      child: Scaffold(
      backgroundColor: Color.fromARGB(235, 255, 255, 255),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                const Text(
                  'Share Your Startup With Expert Minds of NITK',
                  style: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Connect with the community, find team members, find investors!',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 32),

                // Title Field
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    hintText: 'Give your post a compelling title',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.title),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                  maxLength: 100,
                ),
                const SizedBox(height: 24),

                // Description Field
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    hintText: 'Tell us about your startup...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.description),
                    alignLabelWithHint: true,
                  ),
                  maxLines: 8,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                  maxLength: 2000,
                ),
                const SizedBox(height: 32),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submitPost,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text(
                            'Post',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
