import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final usernameController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isLoading = false;
  String error = "";
  bool isLogin = true;

  //final auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(252, 218, 218, 1),
              Color.fromRGBO(233, 181, 181, 1),
              Color.fromRGBO(206, 137, 137, 1),
              Color.fromRGBO(224, 136, 136, 1),
            ],
            stops: [0.0, 0.2, 0.3, 1.0,], // make bottom color more domintate
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 30),
              const Text(
                "Innerscape",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                isLogin ? "Welcome Back" : "Create Account",
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (!isLogin) ...[
                const SizedBox(height: 6),
                const Text(
                  "Start your wellness journey with Innerscape ",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Color.fromRGBO(117, 117, 117, 1),
                  ),
                ),
              ],
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Image.asset(
                  'assets/images/tree.png',
                  width: 280,
                  fit: BoxFit.contain,
                ),
              ),

              //white form section
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(174, 0, 0, 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),

                  child: Column(
                    children: [
                      //toogle between registration & log in
                      Container(
                        height: 45,
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => setState(() => isLogin = true),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: isLogin ? Colors.white : Colors.transparent,
                                    borderRadius: BorderRadius.circular(30),
                                    boxShadow: isLogin ? [ 
                                      BoxShadow( color: const Color.fromRGBO(0, 0, 0, 0.3), 
                                      blurRadius: 8, 
                                      offset: const Offset(0, 3),)
                                    ] : [],
                                  ),
                                  alignment: Alignment.center,
                                  child: const Text("Log In"),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => setState(() => isLogin = false),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  decoration: BoxDecoration(
                                    color: !isLogin ? Colors.white : Colors.transparent,
                                    borderRadius: BorderRadius.circular(30),
                                    boxShadow:!isLogin ? [ 
                                      BoxShadow( color: const Color.fromRGBO(0, 0, 0, 0.3), 
                                      blurRadius: 8, 
                                      offset: const Offset(0, 3),)
                                    ] : [],
                                  ),
                                  alignment: Alignment.center,
                                  child: const Text("Sign Up"),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 25),
                      
                      //form
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              if (!isLogin) ...[
                                _buildInput("Name", "Name"),
                                const SizedBox(height: 12),
                                _buildInput("Username", "Value"),
                                const SizedBox(height: 12),
                              ],
                              _buildInput("Email", "example@gmail.com", icon: Icons.mail,),
                              const SizedBox(height: 12),
                              _buildInput("Password", "Value", isPassword: true,icon: Icons.lock,),

                              if (!isLogin) ...[
                                const SizedBox(height: 12),
                                _buildInput("Confirm Password", "Value", isPassword: true,icon: Icons.lock,),
                              ],

                              const SizedBox(height: 20,),
                              //cta-btn
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromRGBO(139, 178, 245, 1),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: () {},
                                  child: Text(
                                    isLogin ? "Sign In" : "Get Started",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),

                              if (isLogin) ...[
                                const SizedBox(height: 10),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: InkWell(
                                    onTap: () {
                                      // TODO: navigate to reset password
                                    },
                                    child: const Text(
                                      "Forgot password?",
                                      style: TextStyle(
                                        color: Colors.black87,
                                        decoration: TextDecoration.underline,
                                        decorationThickness: 2,
                                        height:1.5,
                                      ),
                                    ),
                                  ),
                                ),
                              ]
                            ],
                          ),
                        ),
                    
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInput(String label, String hint, {bool isPassword = false, IconData? icon,}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 6),
        TextField(
          obscureText: isPassword,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              fontSize: 12,
              color: Color.fromRGBO(179, 179, 179, 1),
            ),

            prefixIcon: icon != null ? Icon(icon, color: Colors.grey, size: 20) : null,
           
            filled: true,
            fillColor: Colors.transparent,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color.fromARGB(255, 206, 205, 205),
                width: 1.0,
              )
            ),
          ),
        ),
      ],
    );
  }
}