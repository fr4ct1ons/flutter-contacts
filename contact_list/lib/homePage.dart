import 'package:contact_list/contact.dart';
import 'package:contact_list/contactPage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'dart:io';

import 'package:sqflite/sqflite.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _counter = 0;

  List<Contact> contacts = [];

  Future<Database>? database;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _startDatabase();
  }

  void _startDatabase() async {
    WidgetsFlutterBinding.ensureInitialized();

    database = openDatabase(path.join(await getDatabasesPath(), 'contacts.db'),
        onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE contacts(name TEXT PRIMARY KEY, image TEXT, email TEXT)');
    }, version: 1);

    final db = await database;

    final List<Map<String, dynamic>> maps = await db!.query('contacts');

    setState(() {
      contacts = List.generate(maps.length, (i) {
        return Contact(
            name: maps[i]['name'],
            phoneNumber: "",
            email: maps[i]['email'],
            image: maps[i]['image']);
      });
    });
  }

  void _addContact() async {
    //_incrementCounter();

    var tempContact = Contact(name: "", phoneNumber: "", email: "");

    await Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return ContactPage(
          contact: tempContact,
        );
      },
    ));

    setState(() {
      contacts.add(tempContact);
      _insertItem(tempContact);
    });
  }

  void _insertItem(Contact contact) async {
    final db = await database;

    await db!.insert('contacts', contact.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  void _editContact(int i) async {
    var tempContact = contacts[i];

    await Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return ContactPage(
          contact: tempContact,
        );
      },
    ));

    setState(() {
      contacts[i] = tempContact;
      _insertItem(tempContact);
    });
  }

  Widget _createContactItem(int i) {
    return Dismissible(
      key: UniqueKey(),
      child: GestureDetector(
        child: Card(
          child: Row(
            children: [
              Image(
                  height: 64,
                  width: 64,
                  image: !contacts[i].image.isEmpty
                      ? FileImage(File(contacts[i].image))
                      : const NetworkImage(
                              "https://images.emojiterra.com/google/android-11/512px/1f9cd.png")
                          as ImageProvider),
              const SizedBox(
                width: 10.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    contacts[i].name,
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                  Text(
                    contacts[i].email,
                    textAlign: TextAlign.left,
                  )
                ],
              ),
            ],
          ),
        ),
        onTap: () {
          _editContact(i);
        },
      ),
      onDismissed: (direction) {
        setState(() {
          contacts.removeAt(i);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
          itemCount: contacts.length,
          itemBuilder: (context, position) {
            return _createContactItem(position);
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: _addContact,
        tooltip: 'Add contact',
        child: const Icon(Icons.add),
      ),
    );
  }
}
