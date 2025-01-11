// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget{
  const ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

  class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("Profile page"),
    );
  }
  }
