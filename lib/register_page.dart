import 'package:flutter/material.dart';
import 'package:networkk/main.dart';
import 'login_page.dart';
import 'package:http/http.dart' as http;
import 'package:hive_flutter/hive_flutter.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> with SingleTickerProviderStateMixin {
  bool _obscureTextPassword = true;
  bool _obscureTextConfirmPassword = true;
  final _formKey = GlobalKey<FormState>();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureTextPassword = !_obscureTextPassword;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _obscureTextConfirmPassword = !_obscureTextConfirmPassword;
    });
  }

  void _handleRegister() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Passwords do not match')),
        );
        return;
      }

      final response = await http.post(
        Uri.parse('https://networkk.onrender.com/register/'),
        body: {
          'username': _usernameController.text,
          'email': _emailController.text,
          'password': _passwordController.text,
        },
      );

      if (response.statusCode == 200) {
        var box = Hive.box('userDataBox');
        await box.put('username', _usernameController.text);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registration Successful!'),
          ),
        );
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MyHomePage(title: "NetworkK")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration failed')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
            Color.fromARGB(255, 57, 170, 234), // Start color
            Color.fromARGB(255, 30, 36, 48),  // End color
          ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Center(
              child: SingleChildScrollView(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Hero(
                          tag: 'logo',
                          child: Container(
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.transparent,
                              backgroundImage: NetworkImage(
                                'https://i.ibb.co/T2NMWdQ/networkk.png',
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        TextFormField(
                          controller: _usernameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your username';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            labelText: 'Username',
                            hintText: 'Enter your username',
                            prefixIcon: Icon(Icons.person_outline),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _emailController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            hintText: 'Enter your email',
                            prefixIcon: Icon(Icons.email_outlined),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                          obscureText: _obscureTextPassword,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            hintText: 'Enter your password',
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureTextPassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                              onPressed: _togglePasswordVisibility,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _confirmPasswordController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please confirm your password';
                            }
                            if (value != _passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                          obscureText: _obscureTextConfirmPassword,
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            hintText: 'Re-enter your password',
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureTextConfirmPassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                              onPressed: _toggleConfirmPasswordVisibility,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _handleRegister,
                            child: const Text(
                              'Register',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already have an account? ',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => const LoginPage(),
                                  ),
                                );
                              },
                              child: const Text(
                                'Log In',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
