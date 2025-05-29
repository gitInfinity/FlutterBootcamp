import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyWidgetState();
}

int increment_val = 0;

class _MyWidgetState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 242, 162, 162),
        appBar: AppBar(
          title: Text('Counter Button'),
          centerTitle: true,
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: (){
              setState(() {
                increment_val++;
              });
            }
          ),
          
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
            Text(
              'Counter Value: $increment_val',
              style: TextStyle(fontSize: 24, color: const Color.fromARGB(255, 24, 18, 18)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 193, 139, 139),
                foregroundColor: const Color.fromARGB(255, 255, 252, 252),
              ),
              onPressed: () {
                setState(() {
                  increment_val = 0;
                });
              },
              child: const Text('Reset'),
            )
           ]
          )
        )
      ),
    );
  }
}