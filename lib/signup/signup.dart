import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:notesapp/change_notifiers/registration_notifier.dart';
import 'package:notesapp/colors.dart';
import 'package:notesapp/model/validation.dart';
import 'package:notesapp/recover_password/recover_password.dart';
import 'package:notesapp/widgets/note_button.dart';
import 'package:notesapp/widgets/note_form_field.dart';
import 'package:notesapp/widgets/outlined_icon_button.dart';
import 'package:provider/provider.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  late final TextEditingController _emailController = TextEditingController();
  late final TextEditingController _passwordController =
      TextEditingController();
  late final GlobalKey<FormState> formKey = GlobalKey();
  late final RegistrationController registrationNotifier;
  late final RegistrationController registrationController;
  @override
  void initState() {
    super.initState();
    registrationNotifier = context.read<RegistrationController>();
    registrationController = context.read<RegistrationController>();
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
                      onChanged: (p0) {
                        registrationNotifier.email = p0;
                      },
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
                          child: Icon(
                            isPasswordHidden
                                ? FontAwesomeIcons.eye
                                : FontAwesomeIcons.eyeSlash,
                          ),
                        ),
                        validator: Validator.passwordValidator,
                        onChanged: (p0) {
                          registrationNotifier.password = p0;
                        },
                      ),
                    ),
                    SizedBox(height: 8),
                    if (!isRegisterMode) ...[
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RecoverPassword(),
                            ),
                          );
                        },
                        child: Text(
                          "Forgot password?",
                          style: TextStyle(color: primary, fontSize: 16),
                        ),
                      ),
                      SizedBox(height: 16),
                    ],
                    SizedBox(
                      height: 48,
                      width: double.infinity,
                      child: Selector<RegistrationController, bool>(
                        selector: (_, controller) => controller.isLoading,
                        builder: (_, isLoading, _) => NoteButton(
                          onPressed: isLoading
                              ? null
                              : () {
                                  if (formKey.currentState?.validate() ??
                                      false) {
                                    registrationNotifier.authenticate(
                                      context: context,
                                    );
                                  }
                                },
                          child: isLoading
                              ? SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: white,
                                  ),
                                )
                              : Text(
                                  isRegisterMode
                                      ? "Create my account"
                                      : "Sign in",
                                ),
                        ),
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
                            onPressed: () {
                              registrationController.authenticateWithGoogle(context: context);
                            },
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
