import 'package:first_sql/notes.dart';
import 'package:first_sql/sql_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:restart_app/restart_app.dart';
import 'notes.dart';
import 'sql_helper.dart';

void main() async {
  ErrorWidget.builder = (FlutterErrorDetails errorDetails) => MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline_outlined,
                  size: 100,
                  color: Colors.red,
                ),
                const SizedBox(height: 25),
                Text(
                  kDebugMode
                      ? errorDetails.exception.toString()
                      : "Something went wrong",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 25),
                ElevatedButton(
                  onPressed: () {
                    Restart.restartApp();
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                    minimumSize: const Size(200, 50),
                  ),
                  child: const Text(
                    "Restart App",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  WidgetsFlutterBinding.ensureInitialized();
  SqlHelper().getDatabase();
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const notes_App(),
    );
  }
}
