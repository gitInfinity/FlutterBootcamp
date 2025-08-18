import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notesapp/colors.dart';
import 'package:notesapp/model/auth.dart';
import 'package:notesapp/widgets/message_dialog.dart';

class RegistrationController extends ChangeNotifier {
  bool _isRegistermode = true;
  bool get isRegisterMode => _isRegistermode;
  set isRegisterMode(bool value) {
    _isRegistermode = value;
    notifyListeners();
  }

  bool _isPasswordHidden = true;
  bool get isPasswordHidden => _isPasswordHidden;
  set isPasswordHidden(bool value) {
    _isPasswordHidden = value;
    notifyListeners();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  String _email = "";
  String get email => _email;
  set email(String value) {
    _email = value;
    notifyListeners();
  }

  String _password = "";
  String get password => _password;
  set password(String value) {
    _password = value;
    notifyListeners();
  }

  Future<void> authenticate({required BuildContext context}) async {
    isLoading = true;
    try {
      if (isRegisterMode) {
        await Auth.register(email: email, password: password);
      } else {
        await Auth.login(email: email, password: password);
      }
    } on FirebaseAuthException catch (e) {
      if (!context.mounted) return;
      showDialog(
        context: context,
        builder: (_) =>
            MessageDialog(confirmation: authExceptionMapper[e.code] ?? "Error"),
      );
    } catch (e) {
      if (!context.mounted) return;
      showDialog(
        context: context,
        builder: (_) => MessageDialog(confirmation: " unknown Error"),
      );
    } finally {
      isLoading = false;
    }
  }

  Future<void> resetPassword({
    required BuildContext context,
    required String email,
  }) async {
    try {
      await Auth.resetPassword(email: email);
      if (!context.mounted) return;
      showDialog(
        context: context,
        builder: (_) =>
            MessageDialog(confirmation: "Password reset email sent"),
      );
    } on FirebaseAuthException catch (e) {
      showDialog(
        context: context,
        builder: (_) =>
            MessageDialog(confirmation: authExceptionMapper[e.code] ?? "Error"),
      );
    } catch (e) {
      if (!context.mounted) return;
      showDialog(
        context: context,
        builder: (_) =>
            MessageDialog(confirmation: "An unknown error has occured"),
      );
    } finally {
      isLoading = false;
    }
  }
}
