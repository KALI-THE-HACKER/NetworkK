import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'login_page.dart';
import 'home_page.dart';
import 'search_page.dart';
import 'profile_page.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('userDataBox');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NetworkK',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 17, 179, 168)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'NetworkK'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  // Dynamic pages
  Widget get dynamicPage {
    switch (_selectedIndex) {
      case 0:
        return HomePage();
      case 1:
        return SearchPage();
      case 2:
        return ProfilePage();
      default:
        return HomePage(); // Default page in case of an unknown index
    }
  }

  void _onItemClicked(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var box = Hive.box('userDataBox');
    String? uname = box.get('username');

    // If username is null, navigate to the login page, else show home page
    if (uname == null) {
      return Scaffold(
      body: Center(child: LoginPage()),  // Display login page if username is not set
    );
    } else {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Center(child: Text(widget.title)),
        ),
        body: dynamicPage, // Use the dynamic page based on selected index
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search_outlined),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Color.fromARGB(255, 17, 179, 168),
          onTap: _onItemClicked,
        ),
      );
    }
  }
}
/*
// Example dynamic pages
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Home Page Content'));
  }
}

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Search Page Content'));
  }
}

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Profile Page Content'));
  }
}*/
