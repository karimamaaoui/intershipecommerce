
import 'package:flutter/material.dart';
import 'package:internshipapplication/Pages/Views/Screens/BottomBar/announces.dart';
import 'package:internshipapplication/Pages/Views/Screens/BottomBar/deals.dart';
import 'package:internshipapplication/Pages/Views/Screens/BottomBar/store.dart';
import 'package:internshipapplication/Pages/Views/Screens/HomePage.dart';

class LandingPage extends StatefulWidget {

  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {

  int currentTab=0;
  final List<Widget> screens=[
    HomePage(),
    Deals(),
    Store(),
    Announces()
  ];
  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = HomePage();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(
        bucket: bucket,
        child: currentScreen,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal[100],
        onPressed: () {
          Navigator.of(context).pushNamed("AddAnnounce");
        },
        child: Icon(Icons.add,color: Colors.black,),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 10,
        child: Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MaterialButton(
                    minWidth: 40,
                    onPressed: (){
                      setState(() {
                        currentScreen = HomePage();
                        currentTab=0;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.home,color: currentTab==0?Colors.indigo:Colors.grey,),
                        Text(
                          "Dashbord",
                          style: TextStyle(
                              color: currentTab==0?Colors.indigo:Colors.grey
                          ),
                        )
                      ],

                    ),
                  ),
                  //SizedBox(width: 15,),
                  MaterialButton(
                    minWidth: 40,
                    onPressed: (){
                      setState(() {
                        currentScreen = Deals();
                        currentTab=1;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.person,color: currentTab==1 ?Colors.indigo:Colors.grey,),
                        Text(
                          "Deals",
                          style: TextStyle(
                              color: currentTab==1 ?Colors.indigo:Colors.grey
                          ),
                        )
                      ],

                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  MaterialButton(
                    minWidth: 40,
                    onPressed: (){
                      setState(() {
                        currentScreen = Store();
                        currentTab=2;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.storefront_outlined,color: currentTab==2?Colors.indigo[400]:Colors.grey,),
                        Text(
                          "Stor",
                          style: TextStyle(
                              color: currentTab==2?Colors.indigo[400]:Colors.grey
                          ),
                        )
                      ],

                    ),
                  ),
                  //SizedBox(width: 15,),
                  MaterialButton(
                    minWidth: 40,
                    onPressed: (){
                      setState(() {
                        currentScreen = Announces();
                        currentTab=3;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.announcement_rounded,color: currentTab==3?Colors.indigo[400]:Colors.grey,),
                        Text(
                          "Announce",
                          style: TextStyle(
                              color: currentTab==3?Colors.indigo[400]:Colors.grey
                          ),
                        )
                      ],

                    ),
                  ),
                ],

              )
            ],
          ),
        ),

      ),
    );
  }
}
