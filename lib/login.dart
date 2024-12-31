import 'package:flutter/material.dart';
import 'homepage.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    // Dispose controllers when the widget is removed
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          // Dismiss the keyboard when tapping outside of a text field
          FocusScope.of(context).unfocus();
        },
        child: Container(
          color: Colors.pink[100], // Set the entire background color to light pink
          child: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 30), // Spacing from the top
                    Image.asset(
                      'assets/book.png',
                      height: 200,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.book, size: 100, color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Welcome Back!',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Login to your account',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 30),
                    TextField(
                      controller: _email,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.pink[200], // Use light pink color
                        labelText: 'Email',
                        labelStyle: const TextStyle(color: Colors.white),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _password,
                      obscureText: true,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.pink[200], // Use light pink color
                        labelText: 'Password',
                        labelStyle: const TextStyle(color: Colors.white),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 60),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const HomePage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink[400],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 15),
                      ),
                      child: const Text('LOGIN'),
                    ),
                    const SizedBox(height: 40),
                    const Text(
                      'Or log in with',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 60,
                          width: 60,
                          child: IconButton(
                            icon: Image.asset(
                              'assets/google.jpg',
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.error, color: Colors.white),
                            ),
                            onPressed: () {
                              // Handle Gmail login
                            },
                          ),
                        ),
                        const SizedBox(width: 30), // Add some space between icons
                        SizedBox(
                          height: 60,
                          width: 60,
                          child: IconButton(
                            icon: Image.asset(
                              'assets/x.jpg',
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.error, color: Colors.white),
                            ),
                            onPressed: () {
                              // Handle Twitter login
                            },
                          ),
                        ),
                        const SizedBox(width: 30), // Add space between icons
                        SizedBox(
                          height: 60,
                          width: 60,
                          child: IconButton(
                            icon: Image.asset(
                              'assets/facebook.png',
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.error, color: Colors.white),
                            ),
                            onPressed: () {
                              // Handle Facebook login
                            },
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
    );
  }
}
