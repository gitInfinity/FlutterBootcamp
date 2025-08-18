import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:notesapp/change_notifiers/note_provider.dart';
import 'package:notesapp/change_notifiers/registration_notifier.dart';
import 'package:notesapp/change_notifiers/reminder_provider.dart';
import 'package:notesapp/colors.dart';
import 'package:notesapp/firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:notesapp/main_page/main_page.dart';
import 'package:notesapp/model/auth.dart';
import 'package:notesapp/signup/signup.dart';
import 'package:provider/provider.dart';
import 'package:notesapp/services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().initialize();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => NoteProvider()),
        ChangeNotifierProvider(create: (context) => RegistrationController()),
        ChangeNotifierProvider(create: (context) => ReminderProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: primary),
          useMaterial3: true,
          fontFamily: 'Poppins',
          scaffoldBackgroundColor: background,
          appBarTheme: Theme.of(context).appBarTheme.copyWith(
            backgroundColor: Colors.transparent,
            titleTextStyle: TextStyle(
              color: primary,
              fontSize: 32,
              fontFamily: 'Fredoka',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        debugShowCheckedModeBanner: false,
        home: StreamBuilder<User?>(
          stream: Auth.userStream,
          builder: (context, asyncSnapshot) {
            return asyncSnapshot.hasData ? const MainPage() : const Signup();
          },
        ),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          FlutterQuillLocalizations.delegate,
        ],
      ),
    );
  }
}
