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
      theme: ThemeData(
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: Colors.deepPurple,
          onPrimary: Colors.white, 
          secondary: Colors.deepPurpleAccent,
          onSecondary: Colors.white,
          surface: Colors.deepPurple.shade50,
          onSurface: Colors.deepPurple.shade800,
          error: Colors.red,
          onError: Colors.white,
          background: Colors.deepPurple.shade100,
          onBackground: Colors.deepPurple.shade900,
        ),
        useMaterial3: true,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.deepPurple.shade50,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: Colors.deepPurple.shade200),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: Colors.deepPurple, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.deepPurple,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
          ),
        ),
      ),
      title: 'NetworkK',
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
    // uname = null;

    // If username is null, navigate to the login page, else show home page
    if (uname == null) {
      return Scaffold(
      body: Center(child: LoginPage()),  // Display login page if username is not set
    );
    } else {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 255, 254, 242),
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
          iconSize: 35,
          currentIndex: _selectedIndex,
          selectedItemColor: Color.fromARGB(255, 101, 11, 237),
          onTap: _onItemClicked,
        ),
      );
    }
  }
}