import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:notes_app/change_notifiers/registration_notifier.dart';
import 'package:notes_app/colors.dart';
import 'package:notes_app/model/validation.dart';
import 'package:notes_app/widgets/note_button.dart';
import 'package:notes_app/widgets/note_form_field.dart';
import 'package:notes_app/widgets/outlined_icon_button.dart';
import 'package:provider/provider.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  late final TextEditingController _emailController = TextEditingController();
  late final TextEditingController _passwordController = TextEditingController();
  late final GlobalKey<FormState> formKey = GlobalKey();
  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        margin: EdgeInsets.only(top: 48),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Selector<RegistrationController, bool>(
              selector: (context, controller) => controller.isRegisterMode,
              builder: (_, isRegisterMode, __) => Form(
                key: formKey,
                child: Column(
                  children: [
                    Text(
                      isRegisterMode ? "Register" : "Signin",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: primary,
                        fontSize: 50,
                        fontFamily: 'Fredoka',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "In order to sync your notes to the cloud, you have to register/sign in to the app",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Fredoka',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 48),
                    NoteFormField(
                      controller: _emailController,
                      key: widget.key,
                      hintText: "Email",
                      validator: Validator.emailValidator,
                    ),
                    SizedBox(height: 8),
                    Selector<RegistrationController, bool>(
                      selector: (context, controller) =>
                          controller.isPasswordHidden,
                      builder: (_, isPasswordHidden, __) => NoteFormField(
                        controller: _passwordController,
                        key: widget.key,
                        hintText: "Password",
                        obscureText: isPasswordHidden,
                        suffix: GestureDetector(
                          onTap: () {
                            context
                                    .read<RegistrationController>()
                                    .isPasswordHidden =
                                !isPasswordHidden;
                          },
                          child: Icon(isPasswordHidden ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash),
                        ),
                        validator: Validator.passwordValidator,
                      ),
                    ),
                    SizedBox(height: 8),
                    if (!isRegisterMode) ...[
                      Text(
                        "Forgot password?",
                        style: TextStyle(color: primary, fontSize: 16),
                      ),
                      SizedBox(height: 16),
                    ],
                    SizedBox(
                      height: 48,
                      width: double.infinity,
                      child: NoteButton(
                        label: isRegisterMode ? "Create my account" : "Sign in",
                        onPressed: () {
                          formKey.currentState?.validate();
                        }
                      ),
                    ),
                    SizedBox(height: 100),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(child: Divider()),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            isRegisterMode
                                ? "Or register with"
                                : "Or sign in with",
                          ),
                        ),
                        Expanded(child: Divider()),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: NoteIconButtonOutlined(
                            icon: FontAwesomeIcons.google,
                            onPressed: () {},
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: NoteIconButtonOutlined(
                            icon: FontAwesomeIcons.facebook,
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 32),
                    Text.rich(
                      TextSpan(
                        text: isRegisterMode
                            ? "Already have an account?"
                            : "Don't have an account?",
                        style: TextStyle(color: gray700),
                        children: [
                          TextSpan(
                            text: isRegisterMode ? " Sign in" : " Register",
                            style: TextStyle(
                              color: primary,
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                context
                                        .read<RegistrationController>()
                                        .isRegisterMode =
                                    !isRegisterMode;
                              },
                          ),
                        ],
                      ),
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
