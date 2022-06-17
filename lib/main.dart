import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'dart:ui';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  PageController pageController = PageController();

  void onTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    pageController.animateToPage(index,
        duration: Duration(milliseconds: 1000), curve: Curves.ease);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ask A Task'),
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: (page) {
          setState(() {
            _selectedIndex = page;
          });
        },
        children: [
          const Home_List(),
          AddPage(),
          const Your_Profile(),
          Container(
            color: Colors.blueGrey,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 25,
        selectedFontSize: 10,
        unselectedFontSize: 5,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(color: Colors.green),
        unselectedLabelStyle: const TextStyle(color: Colors.black),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.apps), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Add Task'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_outlined), label: 'Your Profile'),
          BottomNavigationBarItem(
              icon: Icon(Icons.list_alt_outlined), label: 'Shopping list'),
        ],
        currentIndex: _selectedIndex,
        onTap: onTapped,
      ),
    );
  }
}

class Home_List extends StatelessWidget {
  const Home_List({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection("tasks").snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text('Unexpected fail');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text('Loading');
            }

            final documents = snapshot.data!.docs;
            return ListView(
              children: [
                for (final document in documents) ...[
                  TaskButton(
                    document['title'],
                    document['description'],
                    document.id,
                  ),
                ],
              ],
            );
          }),
    );
  }
}

class TaskButton extends StatelessWidget {
  const TaskButton(
    this.title,
    this.description,
    this.documentId, {
    Key? key,
  }) : super(key: key);

  final String title;
  final String description;
  final String documentId;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (_) => TaskPage(
                    title,
                    description,
                    documentId,
                  )),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(width: 4.0, color: Colors.green),
          color: Colors.amber[900],
          borderRadius: const BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        margin: EdgeInsets.all(20),
        height: 250,
        width: 150,
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Text(title),
        ]),
      ),
    );
  }
}

class TaskPage extends StatelessWidget {
  const TaskPage(this.title, this.description, this.documentId, {Key? key})
      : super(key: key);

  final String title;
  final String description;
  final documentId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(primary: true),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("tasks").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Unexpected fail');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('Loading');
          }

          // final documents = snapshot.data!.docs;
          return Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 4.0, color: Colors.green),
                      color: Colors.white54,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10.0)),
                    ),
                    height: 50,
                    width: 350,
                    child: Text(title,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.lato(fontSize: 40)),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 4.0, color: Colors.green),
                      color: Colors.white54,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10.0)),
                    ),
                    height: 250,
                    width: 350,
                    child: Text(description,
                        style: GoogleFonts.lato(fontSize: 20)),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 4.0, color: Colors.green),
                      color: Colors.white54,
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    height: 50,
                    width: 350,
                    child: Text('sugested_executor'),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 4.0, color: Colors.green),
                      color: Colors.white54,
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    height: 50,
                    width: 350,
                    child: Text('ask date'),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 4.0, color: Colors.green),
                      color: Colors.white54,
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    height: 50,
                    width: 350,
                    child: Text('execution date'),
                  ),
                  Container(
                    height: 100,
                    width: 300,
                    child: ElevatedButton(
                      onPressed: () {
                        FirebaseFirestore.instance
                            .collection('tasks')
                            .doc(documentId)
                            .delete();

                        Navigator.of(context).pop();
                      },
                      child: const Text('Done'),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Return'),
                  ),
                ]),
          );
        },
      ),
    );
  }
}

class AddPage extends StatelessWidget {
  AddPage({
    Key? key,
  }) : super(key: key);

  final controllerTitle = TextEditingController();
  final controllerDescription = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        SizedBox(height: 20),
        Container(
          width: 360,
          margin: EdgeInsets.all(20),
          child: TextField(
            controller: controllerTitle,
            obscureText: false,
            decoration: const InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.green),
              ),
              labelText: 'Title',
            ),
          ),
        ),
        SizedBox(height: 20),
        Container(
          width: 360,
          margin: EdgeInsets.all(20),
          child: TextField(
            controller: controllerDescription,
            maxLines: 6,
            obscureText: false,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.green),
              ),
              labelText: 'Description',
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            FirebaseFirestore.instance.collection("tasks").add({
              'title': controllerTitle.text,
              'description': controllerDescription.text,
            });
            controllerDescription.clear();
            controllerTitle.clear();
          },
          child: Text('Add task'),
        ),
      ]),
    );
  }
}

class Your_Profile extends StatelessWidget {
  const Your_Profile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text('Your profile'), backgroundColor: Colors.green),
      body: ListView(
        children: [
          Column(children: [
            SizedBox(height: 20),
            Container(
              width: 360,
              child: TextField(
                obscureText: false,
                decoration: InputDecoration(
                  icon: Icon(Icons.account_circle),
                  border: OutlineInputBorder(),
                  labelText: 'Your Name',
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: 360,
              child: TextField(
                obscureText: false,
                decoration: InputDecoration(
                  icon: Icon(Icons.assignment_ind_outlined),
                  border: OutlineInputBorder(),
                  labelText: 'Nickname',
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: 360,
              child: TextField(
                obscureText: false,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  icon: Icon(Icons.mail),
                  border: OutlineInputBorder(),
                  labelText: 'E-mail adress',
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.all(30),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size.fromHeight(60),
                      textStyle: TextStyle(fontSize: 30, letterSpacing: 2)),
                  onPressed: () {},
                  child: Text('Submit')),
            ),
          ]),
        ],
      ),
    );
  }
}
