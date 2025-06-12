import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyWidget(),
    );
  }
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  String? _submittedName;
  String? _submittedAge;

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _nameController.text.trim();
    final age = _ageController.text.trim();

    if (name.isEmpty || age.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter both name and age.')),
      );
      return;
    }

    setState(() {
      _submittedName = name;
      _submittedAge = age;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Submitted: Name = $name, Age = $age')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My App'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const Text("Enter name", style: TextStyle(fontSize: 20)),
              TextField(controller: _nameController),
              const SizedBox(height: 20),
              const Text("Enter age", style: TextStyle(fontSize: 20)),
              TextField(
                controller: _ageController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _submit, child: const Text('Submit')),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                height: 200,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    Image(
                      image: NetworkImage(
                        "https://appstronauts.co/wp-content/uploads/2020/03/flutter-app-examples-realtor.jpg",
                      ),
                    ),
                    Image(
                      image: NetworkImage(
                        "https://miro.medium.com/v2/resize:fit:1100/format:webp/1*-6WdIcd88w3pfphHOYln3Q.png",
                      ),
                    ),
                  ],
                ),
              ),
              Text("Your name is : $_submittedName"),
              Text("Your age is : $_submittedAge"),
            ],
          ),
        ),
      ),
    );
  }
}
