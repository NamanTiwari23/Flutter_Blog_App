import 'package:cloud_firestore/cloud_firestore.dart';

class CrudMethods {
   Future<void> addData(Map<String, dynamic> blogData) async {
    try {
      await FirebaseFirestore.instance.collection("blogs").add(blogData);
    } catch (e) {
      print("Error adding data: $e");
    }
  }

   Future<QuerySnapshot<Map<String, dynamic>>> getData() async {
    return await FirebaseFirestore.instance.collection("blogs").get();
  
  }
}

