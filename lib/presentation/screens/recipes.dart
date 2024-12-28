import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../widgets/custom_route.dart';
import 'meal_details.dart';
import '../../data/models/recipes_model.dart';

class Meals extends StatefulWidget {
  const Meals({super.key});

  @override
  State<Meals> createState() => _MealsState();
}

class _MealsState extends State<Meals> with TickerProviderStateMixin {
  List<RecipesModel> _allRecipes = [];
  List<RecipesModel> _filteredRecipes = [];
  Future<List<RecipesModel>> getApiData() async {
    try {
      final response = await http.get(
          Uri.parse('https://edcorp-specifit.github.io/APIs/recipes_api.json'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List<dynamic>;
        final recipes =
            data.map((json) => RecipesModel.fromJson(json)).toList();
        return recipes;
      } else {
        throw Exception('Failed to fetch recipes');
      }
    } catch (e) {
      throw Exception('Failed to fetch recipes: $e');
    }
  }

  performSearch(value) {
    if (mounted) {
      setState(() {
        _filteredRecipes = _allRecipes
            .where((recipe) =>
                recipe.name.toLowerCase().contains(value.toLowerCase()))
            .toList();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getApiData().then((recipes) {
      if (mounted) {
        setState(() {
          _allRecipes = recipes;
          _filteredRecipes = recipes;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    animationController?.dispose();
  }

  Future<bool> getAnimationData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 400));
    return true;
  }

  AnimationController? animationController;
  final ScrollController _scrollController = ScrollController();

  bool isDarkMode(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    return brightness == Brightness.dark;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 70),
        child: FloatingActionButton(
          // splashColor: bgcolor.withOpacity(0.6),
          onPressed: () {
            _scrollController.animateTo(
              0,
              duration: const Duration(milliseconds: 1600),
              curve: Curves.easeInOut,
            );
          },
          child: const Icon(
            Icons.keyboard_double_arrow_up_rounded,
          ),
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Recipes"),
        actions: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: const BorderRadius.all(
                Radius.circular(32.0),
              ),
              onTap: () {},
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.calendar_month_outlined,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8)
        ],
      ),
      body: FutureBuilder(
          future: getApiData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Stack(
                children: [
                  Column(
                    children: [
                      Expanded(
                        child: NestedScrollView(
                          controller: _scrollController,
                          headerSliverBuilder:
                              (BuildContext context, bool innerBoxIsScrolled) {
                            return [
                              SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index) {
                                    return Column(
                                      children: [
                                        getSearchBarUI(),
                                      ],
                                    );
                                  },
                                  childCount: 1,
                                ),
                              ),
                            ];
                          },
                          body: SizedBox(
                            height: MediaQuery.of(context).size.height,
                            child: GridView.builder(
                              physics: const BouncingScrollPhysics(),
                              padding: const EdgeInsets.only(
                                  left: 16, right: 16, top: 20, bottom: 100),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.92,
                                mainAxisSpacing: 14,
                                crossAxisSpacing: 14,
                              ),
                              itemCount: _filteredRecipes.length > 500
                                  ? 500
                                  : _filteredRecipes.length,
                              itemBuilder: (context, index) {
                                return Stack(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          createRoute(
                                            MealDetails(
                                              description:
                                                  _filteredRecipes[index]
                                                      .description,
                                              keywords: _filteredRecipes[index]
                                                  .keywords,
                                              name:
                                                  _filteredRecipes[index].name,
                                              slug:
                                                  _filteredRecipes[index].slug,
                                              videoUrl: _filteredRecipes[index]
                                                  .videoUrl,
                                              thumbnailUrl:
                                                  _filteredRecipes[index]
                                                      .thumbnailUrl,
                                              cookTime: _filteredRecipes[index]
                                                  .cookTime,
                                              prepTime: _filteredRecipes[index]
                                                  .prepTime,
                                              totalTime: _filteredRecipes[index]
                                                  .totalTime,
                                              score:
                                                  _filteredRecipes[index].score,
                                              protein: _filteredRecipes[index]
                                                  .protein,
                                              fat: _filteredRecipes[index].fat,
                                              calories: _filteredRecipes[index]
                                                  .calories,
                                              sugar:
                                                  _filteredRecipes[index].sugar,
                                              carbohydrates:
                                                  _filteredRecipes[index]
                                                      .carbohydrates,
                                              fiber:
                                                  _filteredRecipes[index].fiber,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 12),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).cardColor,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          border: Border.all(
                                            width: 1.5,
                                            color: isDarkMode(context)
                                                ? Theme.of(context)
                                                    .colorScheme
                                                    .outlineVariant
                                                : Colors.grey.withOpacity(0.3),
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: 130,
                                              width: double.maxFinite,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image:
                                                        CachedNetworkImageProvider(
                                                            _filteredRecipes[
                                                                    index]
                                                                .thumbnailUrl)),
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                border: Border.all(
                                                  color: Colors.grey
                                                      .withOpacity(0.3),
                                                  width: 1.5,
                                                ),
                                                color:
                                                    Theme.of(context).cardColor,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(_filteredRecipes[index].name,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleSmall),
                                            Text(
                                              '${_filteredRecipes[index].calories} kcal',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelMedium,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }

  Widget getFilterBarUI() {
    return Stack(
      children: [
        Container(
          color: Theme.of(context).cardColor,
          child: Padding(
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 4),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                        'Search result: ${_filteredRecipes.length} items',
                        style: Theme.of(context).textTheme.labelLarge),
                  ),
                ),
                Material(
                  child: InkWell(
                    borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                    onTap: () {},
                    child: const Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Row(
                        children: [
                          // Text('Filter',
                          //     style: Theme.of(context).textTheme.bodyLarge),
                          // Padding(
                          //   padding: const EdgeInsets.all(8.0),
                          //   child: Icon(
                          //     Icons.sort,
                          //     color: Theme.of(context).primaryColor,
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Divider(
            height: 1,
          ),
        )
      ],
    );
  }

  Widget getSearchBarUI() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(38.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: Theme.of(context).colorScheme.outlineVariant,
                        offset: const Offset(0, 1),
                        blurRadius: 8.0),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 4, bottom: 4),
                  child: TextField(
                    onChanged: performSearch,
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                    decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 10),
                      border: InputBorder.none,
                      hintText: 'Search any recipe...',
                      hintStyle: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: const BorderRadius.all(
                Radius.circular(38),
              ),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.outlineVariant,
                  offset: const Offset(0, 1),
                  blurRadius: 8.0,
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: const BorderRadius.all(
                  Radius.circular(32),
                ),
                onTap: () {},
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Icon(
                    CupertinoIcons.search,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
