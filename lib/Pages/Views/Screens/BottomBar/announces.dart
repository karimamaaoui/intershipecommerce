import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:internshipapplication/Pages/Views/Screens/searchPage.dart';
import 'package:internshipapplication/Pages/Views/widgets/FilterForm.dart';
import 'package:internshipapplication/Pages/Views/widgets/dummy_search_widget1.dart';
import 'package:internshipapplication/Pages/core/model/AnnounceModel.dart';
import 'package:internshipapplication/Pages/core/model/CategoriesModel.dart';
import 'package:internshipapplication/Pages/core/model/CountriesModel.dart';

class Announces extends StatefulWidget {
  const Announces({Key? key}) : super(key: key);

  @override
  State<Announces> createState() => _AnnouncesState();
}

class _AnnouncesState extends State<Announces> {
  String country = "All Countrys";
  String category = "All Categorys";
  CategoriesModel? selectedCategory;
  CountriesModel? selectedCountry;
  double minprice = 0;
  double maxprice = 100;

  List<AnnounceModel> gridMap = [];
  int maxPage = 0;
  int page = 0;

  Future<List<AnnounceModel>> apiCall() async {
    print(page);
    http.Response response, nbads;
    response = await http.get(Uri.parse("https://10.0.2.2:7058/api/First/ShowMore?page=${page}"));
    nbads = await http.get(Uri.parse("https://10.0.2.2:7058/api/First/NbrAds"));

    if (response.statusCode == 200) {
      var responseBody = response.body;
      gridMap.addAll((jsonDecode(responseBody) as List)
          .map((json) => AnnounceModel.fromJson(json))
          .toList());

      int x = int.parse(nbads.body);
      maxPage = x ~/ 4; // Perform integer division

      if (x % 4 > 0) { // Check if there is a remainder
        maxPage += 1; // Add 1 to maxPage
      }

      print(maxPage);
      return gridMap;
    } else {
      print(response.body);
      throw Exception('Failed to fetch data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushNamed("LandingPage"); // Redirect to previous screen
          },
        ),
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.indigo,
        title: Text(
          "Announces",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          // Your action widgets here
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 28),
                      child: DummySearchWidget1(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => SearchPage(),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 5,),
                Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        //create a bottom model for the filter form
                        showModalBottomSheet(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                          ),
                          backgroundColor: Colors.white,
                          context: context,
                          isScrollControlled: true,
                          builder: (context) {
                            return FilterForm(
                              category: selectedCategory,
                              country: selectedCountry,
                              minprice: minprice,
                              maxprice: maxprice,
                            );
                          },
                        ).then((value) {
                          if (value != null) {
                            setState(() {
                              country = (value as Map)['country'] ?? "All Countrys";
                              category = (value as Map)['category'] ?? "All Categorys";
                              minprice = (value as Map)['minprice'] ?? 0.0;
                              maxprice = (value as Map)['maxprice'] ?? 100.0;
                            });
                          }
                        });
                      },
                      icon: Icon(Icons.filter_alt_rounded ,color: Colors.lightBlue, size: 30),
                    ),
                    Text('Filter')
                  ],
                ),
              ],
            ),
            // Show filters (country, category, minprice, maxprice) here if required

            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 8.0),
              child: FutureBuilder<List<AnnounceModel>>(
                future: apiCall(),
                builder: (BuildContext context, AsyncSnapshot<List<AnnounceModel>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Display a loading indicator while waiting for data
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    // Handle the error case
                    return Text('Failed to fetch data');
                  } else {
                    return Column(
                      children: [
                        // Your grid view or list view widget here
                        ElevatedButton(
                          onPressed: () async {
                            if (page < maxPage) {
                              setState(() {
                                page = page + 1;
                              });
                            }
                          },
                          child: Text("Show More"),
                        )
                      ],
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
