import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String newItem = "";
  final TextEditingController _textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            toolbarHeight: double.minPositive,
            elevation: double.tryParse("0"),
            backgroundColor: Colors.redAccent,
          ),
          backgroundColor: const Color.fromARGB(255, 25, 25, 25),
          body: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                const Header(),
                const ToDoListItems(),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: TextField(
                    cursorColor: Colors.white,
                    controller: _textEditingController,
                    onChanged: (value) {
                      setState(() {
                        newItem = value;
                      });
                    },
                    onSubmitted: (value) {
                      if (newItem.trim().isNotEmpty) {
                        FirebaseFirestore.instance.collection("todo").add({"todoItem": newItem, "isDone": false});
                      }
                      setState(() {
                        newItem = "";
                        _textEditingController.clear();
                      });
                    },
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w300),
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white24,
                        hintText: "Add new item",
                        hintStyle: const TextStyle(color: Colors.white54),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                        contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20)),
                  ),
                )
              ],
            ),
          )),
    );
  }
}

class Header extends StatelessWidget {
  const Header({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      width: double.maxFinite,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.redAccent),
      child: const Text(
        "to do \n list",
        style: TextStyle(fontSize: 36, fontWeight: FontWeight.w300, color: Colors.white),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class ToDoListItems extends StatelessWidget {
  const ToDoListItems({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("todo").snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }
        return Expanded(
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: snapshot.data?.docs.length,
            itemBuilder: (context, index) {
              var todoItem = snapshot.data?.docs[index].data()["todoItem"];
              var isDone = snapshot.data?.docs[index].data()["isDone"];
              var docReference = snapshot.data?.docs[index].reference;
              return Item(todoItem: todoItem, isDone: isDone, docReference: docReference);
            },
          ),
        );
      },
    );
  }
}

class Item extends StatelessWidget {
  const Item({
    super.key,
    required this.todoItem,
    required this.isDone,
    required this.docReference,
  });

  final todoItem;
  final isDone;
  final DocumentReference<Map<String, dynamic>>? docReference;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ListTile(
        title: Text(todoItem),
        titleTextStyle: const TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.w300),
        trailing: Checkbox(
          shape: const CircleBorder(),
          value: isDone,
          onChanged: (value) async {
            bool updatedValue = !isDone;
            docReference?.update({"isDone": updatedValue});
          },
          activeColor: Colors.redAccent,
        ),
        onLongPress: () {
          showDialog(
            context: context,
            builder: (context) {
              return ItemLongPress(todoItem: todoItem, docReference: docReference);
            },
          );
        },
        onTap: () {
          bool updatedValue = !isDone;
          docReference?.update({"isDone": updatedValue});
        },
      ),
    );
  }
}

class ItemLongPress extends StatelessWidget {
  const ItemLongPress({
    super.key,
    required this.todoItem,
    required this.docReference,
  });

  final todoItem;
  final DocumentReference<Map<String, dynamic>>? docReference;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text(
          "Do you want to delete '$todoItem'?",
          style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w300),
        ),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ElevatedButton(
                  style: ButtonStyle(elevation: MaterialStateProperty.all(0), backgroundColor: MaterialStateProperty.all(Colors.redAccent)),
                  onPressed: () {
                    docReference?.delete();
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Delete",
                    style: TextStyle(fontWeight: FontWeight.w300, fontSize: 18, color: Colors.white),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ElevatedButton(
                  style: ButtonStyle(elevation: MaterialStateProperty.all(0), backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 25, 25, 25))),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Close",
                    style: TextStyle(fontWeight: FontWeight.w300, fontSize: 18, color: Colors.white),
                  )),
            )
          ],
        ));
  }
}
