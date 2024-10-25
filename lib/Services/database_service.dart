import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  Future addRecipe(Map<String, dynamic> addRecipe) async {
    return FirebaseFirestore.instance.collection('Recipe').add(addRecipe);
  }

  Future<Stream<QuerySnapshot>> getAllRecipe() async {
    return FirebaseFirestore.instance.collection("Recipe").snapshots();
  }

  Future<Stream<QuerySnapshot>> getCategory(String category) async {
    return FirebaseFirestore.instance
        .collection('Recipe')
        .where('Category', isEqualTo: category)
        .snapshots();
  }

  Future<QuerySnapshot> search(String name) async {
    return await FirebaseFirestore.instance
        .collection('Recipe')
        .where('searchName', isGreaterThanOrEqualTo: name.toUpperCase())
        .where('searchName', isLessThanOrEqualTo: '${name.toUpperCase()}\uf8ff')
        .get();
  }

}
