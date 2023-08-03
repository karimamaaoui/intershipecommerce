import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:path/path.dart' as path;

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internshipapplication/Pages/Views/Screens/MyAppBAr.dart';
import 'package:internshipapplication/Pages/Views/widgets/side_bar.dart';
import 'package:internshipapplication/Pages/app_color.dart';
import 'package:internshipapplication/constants.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;

class ProfileDetails extends StatefulWidget {
  final String token;

  ProfileDetails({required this.token});

  @override
  ProfileDetailsState createState() => ProfileDetailsState();
}

class ProfileDetailsState extends State<ProfileDetails>
    with SingleTickerProviderStateMixin {
  TextEditingController _lastnameController = TextEditingController();
  TextEditingController _firstnameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _countryController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _pictureController = TextEditingController();

  bool _status = true;
  final FocusNode myFocusNode = FocusNode();
  String email = "";
  String firstname = "";
  String lastname = "";
  String phone = "";
  String country = "";
  String address = "";
  String _selectedCountry = '';
  String selectedCountry = '';
  String id = "";
  String picture = "";
  File? _selectedImage;
  Uint8List? _selectedImageBytes;

  Future<void> _selectImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
        _selectedImageBytes = _selectedImage?.readAsBytesSync();
        String imageName = path.basename(_selectedImage!.path);
        picture = imageName;
        print("picutre $picture");
        _pictureController.text = picture;
      });
    }
  }


  Future<Map<String, dynamic>> fetchUserData() async {
    final apiUrl = '$baseUrl/User/GetUserById?id=$id';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData is Map<String, dynamic>) {
          return jsonData;
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception('Failed to fetch user data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
  @override
  void initState() {
    super.initState();
    var decodedToken = JwtDecoder.decode(widget.token);
    id = decodedToken['id'] ?? '';

    fetchUserData().then((user) {
      setState(() {
        email = user['email'];
        firstname = user['firstname'];
        lastname = user['lastname'];
        phone = user['phone'];
        address = user['address'];
        country = user['country'];
        picture = user['picture'];

        _emailController.text = email;
        _firstnameController.text = firstname;
        _lastnameController.text = lastname;
        _phoneController.text = phone;
        _addressController.text = address;
        _countryController.text = country;
        _pictureController.text = picture;
        // Add print statements to check the values
        print('Email: ${_emailController.text}');
        print('Firstname: ${_firstnameController.text}');
        print('Lastname: ${_lastnameController.text}');
        print('Phone: ${_phoneController.text}');
        print('Address: ${_addressController.text}');
        print('Country: ${_countryController.text}');
        print('Picture: ${_pictureController.text}');
      });
    });


    fetchCountries().then((List<dynamic> fetchedCountries) {
      setState(() {
        countries = fetchedCountries
            .map((country) => country['title'].toString())
            .toList();
      });
    });
  }

  Future<void> updateUserInformation(Map<String, dynamic> updatedUser) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/User/UpdateUser?id=$id'),
        headers: {
          'Content-Type': 'application/json',

        },
        body: json.encode(updatedUser),
      );

      print(json.encode(updatedUser));
      if (response.statusCode == 200) {
        print("User updated successfully!");
      } else {
        print("Failed to update user. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error while updating user: $e");
    }
  }

  Future<List<dynamic>> fetchCountries() async {
    final apiUrl = '$baseUrl/api/Country/getCountry';
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        // Ensure jsonData is a list
        if (jsonData is List<dynamic>) {
          return jsonData; // Directly return the list of countries
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception('Failed to fetch countries');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  List<String> countries = [];


  @override
  Widget build(BuildContext context) {
    String? dropdownValue =
        _selectedCountry.isNotEmpty ? _selectedCountry : null;

    return Scaffold(
      drawer: SideBar(),
      appBar: MyAppBar(Daimons: 122, title: "Profile Details"),
      body: Container(
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  height: 250.0,
                  color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child: Stack(
                          fit: StackFit.loose,
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  width: 140.0,
                                  height: 140.0,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: picture.isNotEmpty
                                        ? DecorationImage(
                                      image: NetworkImage(
                                          'http://10.0.2.2:5055/images/${picture}'),

                                      fit: BoxFit.cover,
                                    )
                                        : DecorationImage(
                                      image: AssetImage('assets/images/as.png'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),



                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 90.0, right: 100.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  InkWell(
                                    onTap: _selectImage,
                                    child: CircleAvatar(
                                      backgroundColor: AppColor.primary,
                                      radius: 25.0,
                                      child: Icon(
                                        Icons.camera_alt,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  color: Color(0xffFFFFFF),
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 25.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                            left: 25.0,
                            right: 25.0,
                            top: 25.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    'Personal Information',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  _status ? _getEditIcon() : Container(),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: 25.0,
                            right: 25.0,
                            top: 25.0,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    'FirstName',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: 25.0,
                            right: 25.0,
                            top: 2.0,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Flexible(
                                child: TextField(

                                  controller: _firstnameController,
                                  decoration: InputDecoration(
                                    hintText: firstname.isNotEmpty ? firstname : "Enter First Name",
                                  ),
                                  enabled: !_status,
                                  autofocus: !_status,
                                ),

                              ),
                            ],
                          ),
                        ),

                        //lastname
                        Padding(
                          padding: EdgeInsets.only(
                            left: 25.0,
                            right: 25.0,
                            top: 25.0,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    'LastName',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: 25.0,
                            right: 25.0,
                            top: 2.0,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Flexible(
                                child: TextField(
                                  controller: _lastnameController,
                                  decoration: InputDecoration(
                                    hintText: lastname.isEmpty
                                        ? "Enter Lastname"
                                        : lastname,
                                  ),
                                  enabled: !_status,
                                  autofocus: !_status,
                                ),
                              ),
                            ],
                          ),
                        ),
                      //email
                        Padding(
                          padding: EdgeInsets.only(
                            left: 25.0,
                            right: 25.0,
                            top: 25.0,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    'Email',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: 25.0,
                            right: 25.0,
                            top: 2.0,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Flexible(
                                child: TextField(
                                  controller: _emailController,
                                  decoration: InputDecoration(
                                    hintText:
                                        email.isEmpty ? "Enter Email " : email,
                                  ),
                                  enabled: !_status,
                                ),
                              ),
                            ],
                          ),
                        ),

                        //mobile
                        Padding(
                          padding: EdgeInsets.only(
                            left: 25.0,
                            right: 25.0,
                            top: 25.0,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    'Mobile',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: 25.0,
                            right: 25.0,
                            top: 2.0,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Flexible(
                                child: TextField(
                                  controller: _phoneController,
                                  decoration: InputDecoration(
                                    hintText: phone.isEmpty
                                        ? "Enter Mobile Number"
                                        : phone,
                                  ),
                                  enabled: !_status,
                                ),
                              ),
                            ],
                          ),
                        ),

                        //address
                        Padding(
                          padding: EdgeInsets.only(
                            left: 25.0,
                            right: 25.0,
                            top: 25.0,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    'Address',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: 25.0,
                            right: 25.0,
                            top: 2.0,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Flexible(
                                child: TextField(
                                  controller: _addressController,
                                  decoration: InputDecoration(
                                    hintText: address.isEmpty
                                        ? "Enter Address"
                                        : address,
                                  ),
                                  enabled: !_status,
                                ),
                              ),
                            ],
                          ),
                        ),

                        //country
                        Padding(
                          padding: EdgeInsets.only(
                            left: 25.0,
                            right: 25.0,
                            top: 25.0,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    'Country',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: 25.0,
                            right: 25.0,
                            top: 2.0,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Flexible(
                                child: DropdownButton<String>(
                                  value: _selectedCountry.isNotEmpty
                                      ? _selectedCountry
                                      : "",
                                  onChanged: !_status
                                      ? (String? newValue) {
                                          setState(() {
                                            _selectedCountry = newValue!;
                                          });
                                        }
                                      : null,
                                  items: [
                                    DropdownMenuItem<String>(
                                      value: "",
                                      child: Text('$country'),
                                    ),
                                    ...countries.map((country) {
                                      return DropdownMenuItem<String>(
                                        value: country,
                                        child: Text(country),
                                      );
                                    }).toList(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        /*

                            Padding(
                          padding: EdgeInsets.only(
                            left: 25.0,
                            right: 25.0,
                            top: 25.0,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  child: Text(
                                    'Pin code',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                flex: 2,
                              ),
                              Expanded(
                                child: Container(
                                  child: Text(
                                    'State',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                flex: 2,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: 25.0,
                            right: 25.0,
                            top: 2.0,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Flexible(
                                child: Padding(
                                  padding: EdgeInsets.only(right: 10.0),
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText: "Enter Pin Code",
                                    ),
                                    enabled: !_status,
                                  ),
                                ),
                                flex: 2,
                              ),
                              Flexible(
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: "Enter State",
                                  ),
                                  enabled: !_status,
                                ),
                                flex: 2,
                              ),
                            ],
                          ),
                        ),


                         */

                        !_status ? _getActionButtons() : Container(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    super.dispose();
  }

  Widget _getActionButtons() {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
                  child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _status = true;
                    FocusScope.of(context).requestFocus(FocusNode());
                  });
                  var updatedUser = {
                    'firstname': _firstnameController.text.isNotEmpty
                        ? _firstnameController.text
                        : firstname,
                    'lastname': _lastnameController.text.isNotEmpty
                        ? _lastnameController.text
                        : lastname,
                    'email': _emailController.text.isNotEmpty ? _emailController.text : email,
                    'phone': _phoneController.text.isNotEmpty ? _phoneController.text : phone,
                    'address': _addressController.text.isNotEmpty
                        ? _addressController.text
                        : address,
                    'country': _selectedCountry.isNotEmpty ? _selectedCountry : country,
                  };

                  updateUserInformation(updatedUser).then((_) {
                    setState(() {
                      _status = false;
                    });
                  });
                  _showUpdateSuccessAlert();
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                child: Text(
                  "Save",
                  style: TextStyle(color: Colors.white),
                ),
              )),
            ),
            flex: 2,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Container(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _status = true;
                      FocusScope.of(context).requestFocus(FocusNode());
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  child: Text(
                    "Cancel",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  Widget _getEditIcon() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _status = false;
        });
        FocusScope.of(context).requestFocus(myFocusNode);
      },
      child: CircleAvatar(
        backgroundColor: AppColor.primary,
        radius: 14.0,
        child: Icon(
          Icons.edit,
          color: Colors.white,
          size: 16.0,
        ),
      ),
    );
  }

  void _showUpdateSuccessAlert() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text('User updated successfully!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the alert dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
