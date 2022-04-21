import 'package:eloit/models/category.dart';
import 'package:eloit/models/competitor.dart';
import 'package:eloit/models/rivalry.dart';
import 'package:eloit/screens/vote_page.dart';
import 'package:eloit/services/database.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class addItem extends StatefulWidget {
  addItem({Key? key, required this.category}) : super(key: key);
  final Category category;
  @override
  State<addItem> createState() => _addItem();
}

class _addItem extends State<addItem> {
  double deviceHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;
  double deviceWidth(BuildContext context) => MediaQuery.of(context).size.width;
  bool validURL(String url) => Uri.parse(url).host == '' ? false : true;
  final _formKey = GlobalKey<FormState>();

  File? globalFile;
  var nameHolder = TextEditingController();

  uploadImageGallery() async {
    //final _firebaseStorage = FirebaseStorage.instance;
    final _imagePicker = ImagePicker();
    var image = await _imagePicker.pickImage(source: ImageSource.gallery);
    // ignore: unrelated_type_equality_checks
    if (image != Null) {
      globalFile = File(image!.path);
      setState(() {});
    }
    Navigator.of(context).pop();
  }

  uploadImageCamera() async {
    //final _firebaseStorage = FirebaseStorage.instance;
    final _imagePicker = ImagePicker();
    var image = await _imagePicker.pickImage(source: ImageSource.camera);
    // ignore: unrelated_type_equality_checks
    if (image != Null) {
      globalFile = File(image!.path);
      setState(() {});
    }
    Navigator.of(context).pop();
  }

  Future<void> _showChoiceDiaolog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Select Upload Option"),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: InkWell(
                      child: const Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Text("Gallery"),
                      ),
                      onTap: () {
                        uploadImageGallery();
                      },
                      highlightColor: Colors.grey,
                      splashColor: Colors.grey,
                    ),
                  ),
                  const Padding(padding: EdgeInsets.all(8.0)),
                  GestureDetector(
                    child: InkWell(
                      child: const Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Text("Camera"),
                      ),
                      onTap: () {
                        uploadImageCamera();
                      },
                      highlightColor: Colors.grey,
                      splashColor: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget decideImageView() {
    if (globalFile == null) {
      return const CircleAvatar(
        radius: 100,
        backgroundColor: Colors.grey,
        child: Padding(
          padding: EdgeInsets.all(5.0),
          child: Center(
            child: Text(
              "Tap To Upload Image",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
              ),
            ),
          ),
        ),
      );
    } else {
      return CircleAvatar(
        radius: 100,
        backgroundColor: Colors.blue,
        backgroundImage: Image.file(globalFile!).image,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Color(0xFF000452),
      appBar: AppBar(
        title: Text("Add New Item: " + widget.category.name.toString()),
      ),
      body: Center(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: deviceHeight(context) * 0.1,
            ),
            GestureDetector(
              onTap: () {
                _showChoiceDiaolog(context);
              },
              child: decideImageView(),
            ),
            Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(30, 10, 30, 10), //ltrb
                  child: Column(
                    children: [
                      TextFormField(
                        controller: nameHolder,
                        // The validator receives the text that the user has entered.
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              globalFile == null) {
                            return 'Make Sure To Have Image and Text!';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          border:
                              //UnderlineInputBorder(),
                              OutlineInputBorder(),
                          labelText: 'Enter the item name',
                          hintStyle: TextStyle(color: Colors.white),
                          //iconColor: Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 40.0),
                        child: ElevatedButton(
                          onPressed: () async {
                            // Validate returns true if the form is valid, or false otherwise.
                            if (_formKey.currentState!.validate()) {
                              // If the form is valid, display a snackbar. In the real world,
                              // you'd often call a server or save the information in a database.
                              await DatabaseService().addItem(
                                  widget.category.cid,
                                  nameHolder.text,
                                  globalFile);
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Successfully Uploaded')),
                              );
                            }
                          },
                          child: const Text('Submit'),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
