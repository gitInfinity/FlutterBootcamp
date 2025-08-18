import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:notesapp/change_notifiers/registration_notifier.dart';
import 'package:notesapp/colors.dart';
import 'package:notesapp/model/validation.dart';
import 'package:notesapp/widgets/note_button.dart';
import 'package:notesapp/widgets/note_form_field.dart';
import 'package:notesapp/widgets/outlined_icon_button.dart';
import 'package:provider/provider.dart';

class RecoverPassword extends StatefulWidget {
  const RecoverPassword({super.key});

  @override
  State<RecoverPassword> createState() => _RecoverPasswordState();
}

class _RecoverPasswordState extends State<RecoverPassword> {
  late final TextEditingController _emailController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Recover Password"),
        leading: Padding(
          padding: const EdgeInsets.all(6.0),
          child: NoteIconButtonOutlined(
            icon: FontAwesomeIcons.chevronLeft,
            onPressed: () {
              Navigator.maybePop(context);
            },
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Oops! you forgot your password",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: primary,
                fontSize: 30,
                fontFamily: 'Fredoka',
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 48),
            Form(
              key: _formKey,
              child: NoteFormField(
                hintText: "Enter email",
                controller: _emailController,
                validator: Validator.emailValidator,
              ),
            ),
            SizedBox(height: 48),
            Selector<RegistrationController, bool>(
              selector: (context, controller) => controller.isLoading,
              builder: (_, isLoading, _) => isLoading
                  ? CircularProgressIndicator(color: white)
                  : NoteButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              if (_formKey.currentState?.validate() ?? false) {
                                context
                                    .read<RegistrationController>()
                                    .resetPassword(
                                      context: context,
                                      email: _emailController.text.trim(),
                                    );
                              }
                            },
                      child: Text("Send recovery link"),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
