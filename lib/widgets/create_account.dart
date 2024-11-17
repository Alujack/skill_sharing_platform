import 'package:flutter/material.dart';
import './sigin_form.dart';
import './email_form.dart';
import './phone_form.dart';

class CreateAccount extends StatelessWidget {
  const CreateAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Create Account',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'By using our services you are agreeing to our Terms and Privacy Statement.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            SignInButton(
              text: 'Sign in with Email',
              navigateTo: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EmailForm(),
                  ),
                );
              },
            ),
            SignInButton(
              text: 'Sign in with Phone',
              navigateTo: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PhoneForm(),
                  ),
                );
              },
            ),
            SignInButton(
              text: 'Sign in with Facebook',
              navigateTo: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EmailForm(),
                  ),
                );
              },
            ),
            SignInButton(
              text: 'Sign in with Google',
              navigateTo: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EmailForm(),
                  ),
                );
              },
            ),
            const Spacer(),
            TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SigninForm()));
              },
              child: const Text(
                'Have an account? Sign in',
                style: TextStyle(color: Color.fromARGB(255, 38, 0, 209)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SignInButton extends StatelessWidget {
  final String text;
  final void Function() navigateTo;

  const SignInButton({super.key, required this.text, required this.navigateTo});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          side: const BorderSide(color: Colors.black),
        ),
        onPressed: navigateTo,
        child: Text(
          text,
          style: const TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
