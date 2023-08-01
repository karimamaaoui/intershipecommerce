import 'package:internshipapplication/Pages/Views/Screens/AnnounceDetails.dart';
import 'package:internshipapplication/Pages/Views/Screens/AnnouncesCRUD/EditeAnnounce.dart';
import 'package:internshipapplication/Pages/Views/Screens/MyAppBAr.dart';
import 'package:internshipapplication/Pages/Views/widgets/side_bar.dart';
import 'package:internshipapplication/Pages/app_color.dart';
import 'package:internshipapplication/Pages/core/model/AdsFeaturesModel.dart';
import 'package:internshipapplication/Pages/core/model/AnnounceModel.dart';
import 'package:internshipapplication/Pages/core/model/ImageModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyAnnounces extends StatefulWidget {
  const MyAnnounces({super.key});

  @override
  State<MyAnnounces> createState() => _MyAnnouncesState();
}

class _MyAnnouncesState extends State<MyAnnounces> {
  List<AnnounceModel> announces = [];
  int MaxPage = 0;
  int page = 0;
  String? imageUrl;
//get all announces by user
  Future<List<AnnounceModel>> apicall(int iduser) async {
    try {
      http.Response response, nbads;
      response = await http.get(Uri.parse(
          "http://10.0.2.2:5055/api/Ads/getAdsByUser?iduser=20&page=1"));

      nbads = await http.get(
          Uri.parse("http://10.0.2.2:5055/api/Ads/NbrAdsByUser?iduser=20"));
      if (response.statusCode == 200) {
        var responseBody = response.body;
        announces = (jsonDecode(responseBody) as List)
            .map((json) => AnnounceModel.fromJson(json))
            .toList();

        int x = int.parse(nbads.body);
        print("response ********************** ${x}");
        MaxPage = x ~/ 4;
        if (x % 4 > 0) {
          MaxPage += 1;
        }

        return announces;
      } else {
        // Handle the case when the API call returns an error status code
        throw Exception(
            'Failed to fetch data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any exceptions that may occur during the API call
      print('Error fetching data: $e');
      throw Exception('Failed to fetch data. Error: $e');
    }
  }

  //delete announce
  void deleteItem(int id) async {
    bool imgdel = await ImageModel().deleteData(id);
    bool Af = await AdsFeature().deleteData(id);
    if (imgdel && Af) {
      bool isDeleted = await AnnounceModel().deleteData(id);
      if (isDeleted) {
        print("Item with ID $id deleted successfully.");
        announces.removeWhere((element) => element.idAds == id);
        setState(() {
          announces;
        });
      } else {
        print("Failed to delete item with ID $id.");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    apicall(1).then((data) {
      setState(() {
        announces = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideBar(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        onPressed: () {
          Navigator.of(context).pushNamed("AddAnnounce");
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
      appBar: MyAppBar(
        title: "My Announces",
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 8.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: announces.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    child: Card(
                      color: Colors.white,
                      borderOnForeground: true,
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: Colors.black.withOpacity(0.20),
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(
                              width: 200,
                              height: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.black.withOpacity(0)),
                              ),
                              child: Image.network(
                                announces[index].imageUrl!,
                                fit: BoxFit.fill,
                                errorBuilder: (context, error, stackTrace) {
                                  return Center(
                                    child: Text('Image not found'),
                                  );
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(15, 10, 0, 0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        '${announces[index].title}',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(15, 10, 0, 0),
                              child: Row(
                                children: [
                                  Text(
                                    "${announces[index].description}",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(15, 10, 0, 0),
                              child: Row(
                                children: [
                                  Text(
                                    "${announces[index].price} DT",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.indigo,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Add "Details" button
                            TextButton.icon(
                              style: ButtonStyle(),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => AnounceDetails(
                                      Announce: announces[index],
                                    ),
                                  ),
                                );
                              },
                              icon: Icon(
                                Icons.details,
                                color: Colors.blue,
                              ),
                              label: Text(
                                'Details',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            SizedBox(height: 20),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextButton.icon(
                                  style: ButtonStyle(),
                                  onPressed: () {
                                    Navigator.of(context)
                                        .push(
                                      MaterialPageRoute(
                                        builder: (context) => EditeAnnounce(
                                          announce: announces[index],
                                        ),
                                      ),
                                    )
                                        .then((value) {
                                      if (value != null && value is Map) {
                                        AnnounceModel res = value['updatedAnnounce'];
                                        if (res != null) {
                                          setState(() {
                                            announces.removeWhere((a) => res.idAds == a.idAds);
                                            announces.add(res);
                                          });
                                        }
                                      }
                                    });
                                  },
                                  icon: Icon(
                                    Icons.edit,
                                    color: Colors.greenAccent,
                                  ),
                                  label: Text(
                                    'Edit',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                                SizedBox(width: 20),
                                TextButton.icon(
                                  style: ButtonStyle(),
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.flash_on,
                                    color: Colors.yellowAccent,
                                  ),
                                  label: Text(
                                    'Boost',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                                SizedBox(width: 20),
                                TextButton.icon(
                                  style: ButtonStyle(),
                                  onPressed: () {
                                    deleteItem(int.parse(announces[index].idAds.toString()));
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  label: Text(
                                    'Delete',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                                // Add more icons as needed
                              ],
                            ),
                          ],
                        ),
                      ),

                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 36, vertical: 18),
                backgroundColor: AppColor.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
                shadowColor: Colors.transparent,
              ),
              onPressed: () async {
                if (page < MaxPage) {
                  setState(() {
                    page = page + 1;
                    apicall(1).then((data) {
                      setState(() {
                        announces = data;
                      });
                    });
                  });
                }
              },
              child: Text(
                "Show More",
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


