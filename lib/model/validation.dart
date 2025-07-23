class Validator {
  Validator._();

  static String? emailValidator(String? email) {
    email = email?.trim() ?? "";
    return email.isEmpty
        ? "Enter an email"
        : !RegExp(
            r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
          ).hasMatch(email)
        ? "email is not in a valid format"
        : null;
  }

  static String? passwordValidator(String? password) {
    password = password?.trim() ?? "";
    return password.isEmpty
        ? "Enter an password"
        : password.length < 8
        ? "Password must be at least 8 characters long"
        : !(password.contains(RegExp(r'[a-z]')) &&
              password.contains(RegExp(r'[A-Z]')))
        ? "Password must contain both lowercase and uppercase letters"
        : !password.contains(RegExp(r'[0-9]'))
        ? "Password must contain a number"
        : null;
  }
}
