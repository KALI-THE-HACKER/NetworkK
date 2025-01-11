// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget{
  const SearchPage({super.key});
  @override
  State<SearchPage> createState() => _SearchPageState();
}

  class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("Search"),
    );
  }
  }
