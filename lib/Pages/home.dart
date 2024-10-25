import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:recipe_app/Pages/add_recipe.dart';
import 'package:recipe_app/Pages/category_details.dart';
import 'package:recipe_app/Pages/recipe_details.dart';
import 'package:recipe_app/Services/database_service.dart';
import 'package:recipe_app/customWidget/category_recipe.dart';
import 'package:recipe_app/customWidget/trending_recipe.dart';
import 'package:recipe_app/support_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Stream? recipeStream;

  @override
  void initState() {
    super.initState();
    loadRecipe();
  }

  loadRecipe() async {
    recipeStream = await DatabaseService().getAllRecipe();
    setState(() {});
  }

  Widget getAllRecipe() {
    return StreamBuilder(
      stream: recipeStream,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data.docs.isNotEmpty) {
          return Container(
            height: 325,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot ds = snapshot.data.docs[index];
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => RecipeDetails(
                        imagePath: ds['Image'],
                        recipeName: ds['Name'],
                        recipeDetails: ds['Details'],
                      ),
                    ));
                  },
                  child: TrendingRecipe(
                    imagePath: ds['Image'],
                    recipeName: ds['Name'],
                  ),
                );
              },
            ),
          );
        } else {
          return const Center(
            child: Text('No Recipe Found'),
          );
        }
      },
    );
  }

  //Search Functionality
  bool search = false;
  var queryResultSet = [];
  var tempSearchStore = [];

  initiateSearch(String value) {
    if (value.isEmpty) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
        search = false;
      });
      return;
    }

    final searchKey = value.toUpperCase();

    DatabaseService().search(searchKey).then((QuerySnapshot docs) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];

        for (var doc in docs.docs) {
          queryResultSet.add(doc.data());
        }

        tempSearchStore = queryResultSet
            .where((element) => element['searchName'].contains(searchKey))
            .toList();

        search = tempSearchStore.isNotEmpty;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 30, left: 20, right: 20),
        width: MediaQuery.sizeOf(context).width,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text and Profile Picture
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Looking for your\nfavorite Meal',
                    style: AppWidget.boldStyle(),
                    textScaler: const TextScaler.linear(1.2),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      'images/profile.jpg',
                      height: 60,
                      width: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Search Bar
              Container(
                padding: const EdgeInsets.only(left: 10),
                width: MediaQuery.sizeOf(context).width,
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Search Recipe',
                    suffixIcon: Icon(Icons.search_outlined),
                    border: InputBorder.none,
                  ),
                  onChanged: (value) {
                    initiateSearch(value);
                  },
                ),
              ),
              const SizedBox(height: 20),
              search
                  ? tempSearchStore.isEmpty
                      ? const Center(
                          child: Text('No Recipe Found'),
                        )
                      : ListView(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          shrinkWrap: true,
                          children: tempSearchStore.map((element) {
                            return buildRecipeCard(element);
                          }).toList(),
                        )
                  : SizedBox(
                      height: 200,
                      child: ListView(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const CategoryDetails(
                                    category: 'Soup Recipe'),
                              ));
                            },
                            child: const RecipeCard(
                              imagePath: 'images/soup.jpg',
                              text: 'Soup Recipe',
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const CategoryDetails(
                                    category: 'Main Recipe'),
                              ));
                            },
                            child: const RecipeCard(
                              imagePath: 'images/main.jpg',
                              text: 'Main Recipe',
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const CategoryDetails(
                                    category: 'Indian Recipe'),
                              ));
                            },
                            child: const RecipeCard(
                              imagePath: 'images/indian.jpg',
                              text: 'Indian Recipe',
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const CategoryDetails(
                                    category: 'Chinese Recipe'),
                              ));
                            },
                            child: const RecipeCard(
                              imagePath: 'images/chineese.jpg',
                              text: 'Chinese Recipe',
                            ),
                          ),
                        ],
                      ),
                    ),
              const SizedBox(height: 10),
              Text(
                'Trending Recipes',
                style: AppWidget.fullBold(),
              ),
              const SizedBox(height: 10),
              if (!search) getAllRecipe(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => const AddRecipe()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget buildRecipeCard(data) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => RecipeDetails(
            imagePath: data['Image'],
            recipeName: data['Name'],
            recipeDetails: data['Details'],
          ),
        ));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(60),
                  child: Image.network(
                    data['Image'],
                    height: 70,
                    width: 70,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 20),
                Text(
                  data['Name'],
                  style: AppWidget.boldStyle(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
