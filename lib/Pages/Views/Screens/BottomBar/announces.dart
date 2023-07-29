import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:internshipapplication/Pages/Views/Screens/searchPage.dart';
import 'package:internshipapplication/Pages/Views/widgets/FilterForm.dart';
import 'package:internshipapplication/Pages/Views/widgets/dummy_search_widget1.dart';
import 'package:internshipapplication/Pages/core/model/AnnounceModel.dart';
import 'dart:convert';
import '../../widgets/GridAnnounces.dart';
import '../../widgets/custom_icon_button_widget.dart';
import '../messagePage.dart';

class Announces extends StatefulWidget {

  const Announces({super.key});

  @override
  State<Announces> createState() => _AnnouncesState();
}

class _AnnouncesState extends State<Announces> {

  String country="All Countrys";
  String category="All Categorys";
  double minprice=0;
  double maxprice=100;

    List<AnnounceModel> gridMap = [];
    int MaxPage =0;
    int page=0;

  Future<List<AnnounceModel>> apicall() async {
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
      MaxPage = x ~/ 4; // Perform integer division

      if (x % 4 > 0) { // Check if there is a remainder
        MaxPage += 1; // Add 1 to MaxPage
      }

      print(MaxPage);
      return gridMap;
    } else {
      print(response.body);
      throw Exception('Failed to fetch data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
      AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushNamed("LandingPage"); // Redirect to previous screen
          },
        ),
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.indigo,
        title: Text("Announces",
          style: TextStyle(
              color: Colors.white
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 5.0, 5.0, 0),
            child: CustomIconButtonWidget(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => MessagePage()));
              },
              value: 2,
              icon: Icon(
                Icons.mark_unread_chat_alt_outlined,
                color:Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 5.0, 15.0, 0),
            child: CustomIconButtonWidget(
              onTap: () {
                AwesomeDialog(
                    context: context,
                    dialogBackgroundColor: Colors.indigo,
                    dialogType: DialogType.INFO,
                    animType: AnimType.TOPSLIDE,
                    title:"Diamond",
                    descTextStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                    ),
                    desc: "Hello, welcome to ADS & Deals.\n \n What are diamonds?!\n Diamonds are the currency within our application.\n With diamonds, you can add your products to the application and enhance their visibility. If you would like to refill your wallet and purchase diamonds, please click OK",
                    btnCancelColor: Colors.grey,
                    btnCancelOnPress:(){},

                    btnOkOnPress: (){}
                ).show();
              },
              value: 122,

              icon: Icon(
                Icons.diamond_outlined,
                color:Colors.white,
              ),

            ),
          ),
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
                    child:Padding(
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
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(25)
                                ),
                              ),
                              backgroundColor: Colors.white,
                              context: context,
                              isScrollControlled: true,
                              builder: (context) {
                                return FilterForm(category: category,country: country,minprice: minprice,maxprice: maxprice,);
                              }
                          ).then((value){
                            setState(() {
                              country = (value as Map)['country'];
                              category = (value as Map)['category'];
                              minprice = (value as Map)['minprice'];
                              maxprice = (value as Map)['maxprice'];
                            });

                          });
                        },
                        icon: Icon(Icons.filter_alt_rounded ,color: Colors.lightBlue,size: 30,)
                    ),
                    Text('Filter')
                  ],
                ),
              ],
            ),
            /** Show filters **/
            country.isNotEmpty&&country !="All Countrys"||category.isNotEmpty&&category !="All Categorys"||minprice!=0||maxprice!=100? Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                country.isNotEmpty&&country!="All Countrys"?
                ElevatedButton(

                  onPressed: () {
                    setState(() {
                      country="All Countrys";
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.lightBlue[100],
                    padding: EdgeInsets.all(10),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        country,
                        style: TextStyle(fontSize: 16,color: Colors.black),
                      ),
                      SizedBox(width: 3),
                      Icon(Icons.close,color: Colors.black,),
                    ],
                  ),
                ):SizedBox(height: 0,),
                category.isNotEmpty&&category!="All Categorys"?
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      category="All Categorys";
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.lightBlue[100],
                    padding: EdgeInsets.all(10),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      Text(
                        category,
                        style: TextStyle(fontSize: 16,color: Colors.black),
                      ),
                      SizedBox(width: 3),
                      Icon(Icons.close,color: Colors.black,),

                    ],
                  ),
                ):SizedBox(height: 0,),
                
                minprice!=0?
                ElevatedButton(

                  onPressed: () {
                    setState(() {
                      minprice=0;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.lightBlue[100],
                    padding: EdgeInsets.all(10),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        minprice.toStringAsFixed(2),
                        style: TextStyle(fontSize: 16,color: Colors.black),
                      ),
                      SizedBox(width: 3),
                      Icon(Icons.close,color: Colors.black,),
                    ],
                  ),
                ):SizedBox(height: 0,),
                maxprice!=100?
                ElevatedButton(

                  onPressed: () {
                    setState(() {
                      maxprice=100;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.lightBlue[100],
                    padding: EdgeInsets.all(10),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        maxprice.toStringAsFixed(2),
                        style: TextStyle(fontSize: 16,color: Colors.black),
                      ),
                      SizedBox(width: 3),
                      Icon(Icons.close,color: Colors.black,),
                    ],
                  ),
                ):SizedBox(height: 0,),
              ],
            )
                :SizedBox(height: 0,),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 8.0),
              child: FutureBuilder<List<AnnounceModel>>(
                future: apicall(),
                builder: (BuildContext context, AsyncSnapshot<List<AnnounceModel>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Display a loading indicator while waiting for data
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    // Handle the error case
                    return Text('Failed to fetch data');
                  } else {
                    return
                      Column(
                      children: [
                        GridB(data: gridMap),
                        gridMap.length != 0 && page<MaxPage-1?
                        ElevatedButton(
                            onPressed: () async {
                              if (page < MaxPage) {
                                setState(() {
                                  page = page + 1;
                                });

                                //await apicall();
                              }
                            },
                            child: Text("Show More"),
                          )
                        :
                          SizedBox(height: 0),
                      ],
                    );
                    //
                  }
                },
              ),
            ),
            SizedBox(height: 30,)
          ],
        ),
      ),
      //
    );
  }
}