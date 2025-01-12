import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'login_page.dart';
import 'home_page.dart';
import 'search_page.dart';
import 'profile_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'newpost_page.dart';
import 'package:flutter/cupertino.dart';

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
      title: 'Network.K',
      home: const MyHomePage(title: 'Network.K'),
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
        return NewpostPage();
      case 3:
        return ProfilePage(initialBio: 'Add your bio here', onSave: (String ) {  },);
      default:
        return HomePage(); // Default page in case of an unknown index
    }
  }

  void _onItemClicked(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void deleteUserData() async{
    var box = Hive.box('userDataBox');
    await box.delete('username');
    Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
  }

  @override
  Widget build(BuildContext context) {
    var box = Hive.box('userDataBox');
    String? uname = box.get('username');
    print("##################");
    print(uname);
    // uname = null;

    // If username is null, navigate to the login page, else show home page
    if (uname == null) {
      print("Routing to login page");
      return Scaffold(
      body: Center(child: LoginPage()),  // Display login page if username is not set
    );
    } else {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          title: Center(child: Text(widget.title, style: GoogleFonts.exo2(color: const Color.fromARGB(255, 0, 0, 0), fontSize: 32, fontWeight: FontWeight.bold),)),
        ),
        body: dynamicPage,
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor:Color.fromARGB(255, 255, 255, 255),
          elevation: 0,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.house_fill),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.create),
              label: 'Create Post',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.person),
              label: 'Profile',
            ),
          ],
          iconSize: 25,
          currentIndex: _selectedIndex,
          selectedItemColor: Color.fromARGB(255, 86, 142, 245),
          unselectedItemColor: Colors.blueGrey,
          onTap: _onItemClicked,
        ),

        floatingActionButton: 
          FloatingActionButton(
            onPressed: deleteUserData,
            child: Icon(Icons.logout_outlined),
            backgroundColor: Color.fromARGB(255, 86, 142, 245),
            ),
      );
    }
  }
}