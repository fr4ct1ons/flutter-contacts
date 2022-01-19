import 'dart:io';

import 'package:contact_list/contact.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ContactPage extends StatefulWidget {
  ContactPage({Key? key, this.contact}) : super(key: key);

  Contact? contact;

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    nameController = TextEditingController(text: widget.contact!.name);
    emailController = TextEditingController(text: widget.contact!.email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Contact"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              GestureDetector(
                child: Image(
                  width: 256,
                  height: 256,
                  image: !widget.contact!.image.isEmpty
                      ? FileImage(File(widget.contact!.image))
                      : const NetworkImage(
                              "https://images.emojiterra.com/google/android-11/512px/1f9cd.png")
                          as ImageProvider,
                ),
                onTap: () {
                  ImagePicker()
                      .getImage(source: ImageSource.camera)
                      .then((value) {
                    if (value == null) {
                      return;
                    } else {
                      setState(() {
                        widget.contact!.image = value.path;
                      });
                    }
                  });
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: "Name"),
                controller: nameController,
                keyboardType: TextInputType.name,
                onChanged: (value) {
                  widget.contact!.name = value;
                },
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: "Email"),
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  widget.contact!.email = value;
                },
              )
            ],
          ),
        ));
  }
}
