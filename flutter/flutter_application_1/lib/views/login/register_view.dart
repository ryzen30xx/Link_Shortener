import 'package:flutter/material.dart';
import 'package:flutter_application_1/views/login/login_view.dart';
import 'package:flutter_application_1/widgets/navigation_bar/navigation_bar.dart';
import 'package:flutter_application_1/services/userservices.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _confirmEmailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // ✅ Register User Function with Credential Check
  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // print("🔹 Attempting registration...");
    // print("🔹 Username: ${_usernameController.text}");
    // print("🔹 Email: ${_emailController.text}");
    // print("🔹 Password: ${_passwordController.text}");

    String result = await UserService.register(
      _usernameController.text.trim(),
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    if (!mounted) return; // ✅ Prevent calling setState() after dispose

    setState(() => _isLoading = false);

    // print("🔹 Registration Result: $result");

    if (result == "success") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('✅ Account created successfully!'), backgroundColor: Colors.green),
      );
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginView())); // ✅ Redirect to Login
    } else if (result == "exists") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Username or Email already exists!'), backgroundColor: Colors.orange),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Registration failed. Try again!'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Navbar(),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.jpg'), // ✅ Background Image Restored
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(32.0),
            constraints: const BoxConstraints(maxWidth: 400),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FlutterLogo(size: 100),
                  const SizedBox(height: 16),
                  Text("Create Your Account", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

                  const SizedBox(height: 20),

                  // Username Field
                  TextFormField(
                    controller: _usernameController,
                    validator: (value) => value == null || value.isEmpty ? 'Please enter your username' : null,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      prefixIcon: Icon(Icons.person_outline),
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Email Field
                  TextFormField(
                    controller: _emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Please enter your email';
                      bool emailValid = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(value);
                      return emailValid ? null : 'Please enter a valid email';
                    },
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email_outlined),
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Confirm Email Field
                  TextFormField(
                    controller: _confirmEmailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Please confirm your email';
                      if (value != _emailController.text) return 'Emails do not match';
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Confirm Email',
                      prefixIcon: Icon(Icons.email_outlined),
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Password Field
                  TextFormField(
                    controller: _passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Please enter your password';
                      return value.length < 6 ? 'Password must be at least 6 characters' : null;
                    },
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock_outline_rounded),
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(_isPasswordVisible ? Icons.visibility_off : Icons.visibility),
                        onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Register Button
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: _isLoading ? 50 : MediaQuery.of(context).size.width * 0.8, // ✅ Fix Width Issue
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                        backgroundColor: const Color.fromARGB(255, 129, 0, 189),
                      ),
                      onPressed: _isLoading ? null : _register,
                      child: _isLoading
                          ? const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
                          : const Text(
                              'Register',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Already have an account? Sign in
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginView()), // ✅ Navigates to LoginView
                      );
                    },
                    child: const Text("Already have an account? Sign in"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
