import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:recipe_app/Pages/recipe_details.dart';
import 'package:recipe_app/Services/database_service.dart';

import '../support_widget.dart';

class CategoryDetails extends StatefulWidget {
  final String category;

  const CategoryDetails({super.key, required this.category});

  @override
  State<CategoryDetails> createState() => _CategoryDetailsState();
}

class _CategoryDetailsState extends State<CategoryDetails> {
  Stream? categoryStream;

  loadCategory() async {
    categoryStream = await DatabaseService().getCategory(widget.category);
    setState(() {});
  }

  Widget showCategory() {
    return StreamBuilder(
        stream: categoryStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.docs[index];
                    return InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => RecipeDetails(
                                recipeName: ds["Name"],
                                recipeDetails: ds['Details'],
                                imagePath: ds['Image'],
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 20),
                          child: ListView(
                            children: [
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    ds['Image'],
                                    height: 120,
                                    width: 120,
                                    fit: BoxFit.fill,
                                  )),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                ds['Name'],
                                style: AppWidget.lightStyle(),
                              ),
                            ],
                          ),
                        ));
                  })
              : const Center(
                  child: Text('No category found'),
                );
        });
  }

  @override
  void initState() {
    loadCategory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          margin: const EdgeInsets.only(top: 30),
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Center(
                child: Text(widget.category),
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(child: showCategory()),
            ],
          ),
        ),
      ),
    );
  }
}
