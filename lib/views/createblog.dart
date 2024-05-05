import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutterapp/services/crud.dart';
import 'package:random_string/random_string.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CreateBlog extends StatefulWidget {
  const CreateBlog();

  @override
  State<CreateBlog> createState() => _CreateBlogState();
}

class _CreateBlogState extends State<CreateBlog> {
  File? selectedImage;
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  bool _isLoading = false;
  CrudMethods crudMethods = CrudMethods();

  Future<void> initializeFirebase() async {
    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp();
      }
    } catch (e) {
      print('Error initializing Firebase: $e');
    }
  }

  @override
  void initState() {
    initializeFirebase().then((_) {
      // Firebase initialized successfully
    });
    super.initState();
  }

  Future<void> getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    } else {
      print('No image selected.');
    }
  }

  Future<void> uploadBlog() async {
    if (selectedImage != null) {
      setState(() {
        _isLoading = true;
      });

      try {
        Reference firebaseStorageRef = FirebaseStorage.instance
            .ref()
            .child("BlogImages")
            .child("${randomAlphaNumeric(9)}.jpg");
        UploadTask uploadTask = firebaseStorageRef.putFile(selectedImage!);

        TaskSnapshot taskSnapshot = await uploadTask;
        String downloadUrl = await taskSnapshot.ref.getDownloadURL();
        print("Download URL: $downloadUrl");

        Map<String, String> blogMap = {
          "imgUrl": downloadUrl,
          "title": titleController.text,
          "desc": contentController.text,
        };

        print("Blog Map: $blogMap");

        // Store blog data in Firestore
        await crudMethods.addData(blogMap);

        Navigator.pop(context);
      } catch (e) {
        print("Error uploading blog: $e");
      }

      setState(() {
        _isLoading = false;
        selectedImage = null; // Reset selected image after upload
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'VIT',
              style: TextStyle(
                fontSize: 40,
                fontFamily: 'Raleway',
                color: Colors.black,
              ),
            ),
            Text(
              'BLOG',
              style: TextStyle(fontSize: 40, color: Colors.blue),
            ),
          ],
        ),
        backgroundColor: Colors.amber,
        elevation: 0.0,
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              uploadBlog();
            },
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.file_upload,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        getImage();
                      },
                      child: selectedImage != null
                          ? Container(
                              margin: EdgeInsets.only(top: 20),
                              height: 200,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(color: Colors.black, width: 2),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(selectedImage!,
                                    fit: BoxFit.cover),
                              ),
                            )
                          : Container(
                              margin: EdgeInsets.only(top: 20),
                              height: 200,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(color: Colors.black, width: 2),
                              ),
                              child: Center(
                                child: Icon(Icons.add_a_photo,
                                    size: 50, color: Colors.black),
                              ),
                            ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        hintText: 'Enter Blog Title',
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: contentController,
                      decoration: InputDecoration(
                        hintText: 'Enter Blog Content',
                      ),
                      maxLines: null,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Add your submit button functionality here
                      },
                      child: Text('Submit Blog'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

