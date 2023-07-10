import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../constants/colors.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Container(
        padding:
            const EdgeInsets.only(top: 80, left: 40, right: 40, bottom: 20),
        child: Column(
          children: [
            const Text("App membership",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                )),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Select shopping list",
              style: TextStyle(fontSize: 22),
            ),
            const SizedBox(
              height: 60,
            ),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                hintText: "Username",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                hintText: "Password",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(height: 40,),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text("Forgot password", style: TextStyle(fontSize: 22),),
                SizedBox(width: 10,),
                Text("Login", style: TextStyle(fontSize: 25),),
              ],
            ),
            const SizedBox(height: 70,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("Don't have account?", style: TextStyle(fontSize: 25),),
                Text("Sign up", style: TextStyle(fontSize: 25),),
              ],
            ),
          ],
        ),
      ),
    );
  }

  buildAppBar() {
    return AppBar(
      backgroundColor: tdBlue,
      elevation: 2,
      actions: [
        IconButton(
          icon: const Icon(Icons.person),
          color: Colors.white,
          iconSize: 30,
          onPressed: () => {},
        ),
      ],
    );
  }
}
