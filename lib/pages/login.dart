import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:qrcode/routes/router.dart';
import 'package:qrcode/bloc/bloc.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final TextEditingController emailC =
      TextEditingController(text: "admin@gmail.com");
  final TextEditingController passC = TextEditingController(text: "123123");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Warung Kholis"),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          Gap(50),
          Lottie.asset(
            'assets/svg/login.json',
            width: 200,
            height: 200,
            fit: BoxFit.cover,
          ),
          Gap(150),
          TextField(
            autocorrect: false,
            controller: emailC,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          SizedBox(height: 20),
          TextField(
            autocorrect: false,
            controller: passC,
            obscureText: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // mengirim text login
              context
                  .read<AuthBloc>()
                  .add(AuthEventLogin(emailC.text, passC.text));
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor: Colors.blueAccent,
            ),
            child: BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthStateLogin) {
                  context.goNamed(Routes.home);
                }
                if (state is AuthStateError) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(state.message),
                    duration: Duration(seconds: 2),
                  ));
                }
              },
              builder: (context, state) {
                if (state is AuthStateLoading) {
                  return Text(
                    "Loading...",
                    style: TextStyle(color: Colors.white),
                  );
                }
                return Text(
                  "Login",
                  style: TextStyle(color: Colors.white),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
