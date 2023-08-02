import 'package:internshipapplication/Pages/core/model/CitiesModel.dart';
import  'package:http/http.dart' as http;
import 'dart:convert';


class CityService {

  // get cities data by country id
  Future<List<CitiesModel>> GetData(int countryId) async {
    http.Response response;
    response = await http.get(Uri.parse("https://10.0.2.2:7058/api/CitiesControler/$countryId"));
    if (response.statusCode == 200) {
      List<CitiesModel> citiesList = (jsonDecode(response.body) as List)
          .map((json) => CitiesModel.fromJson(json))
          .toList();
      //print(response.body);
      return citiesList;
    } else {
      print(response.body);
      throw Exception('Failed to fetch Cities');
    }
  }
}