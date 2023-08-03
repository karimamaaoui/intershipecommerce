import  'package:http/http.dart' as http;
import 'dart:convert';
import 'package:internshipapplication/Pages/core/model/CategoriesModel.dart';
import 'package:internshipapplication/constants.dart';

class CategoryService {

  Future<List<CategoriesModel>> GetData() async {
    http.Response response;
    response = await http.get(Uri.parse("$baseUrl/api/CategoriesControler/GetAllCategories"));
    if (response.statusCode == 200) {
      List<CategoriesModel> categoryList = (jsonDecode(response.body) as List)
          .map((json) => CategoriesModel.fromJson(json))
          .toList();
      return categoryList;
    } else {
      print(response.body);
      throw Exception('Failed to fetch Categories');
    }
  }

  Future<CategoriesModel> GetCategoryById( int id) async {
    http.Response response;
    response = await http.get(Uri.parse("$baseUrl/api/CategoriesControler/$id"));
    print(response.body);
    if (response.statusCode == 200) {
      CategoriesModel categ = (jsonDecode(response.body));

      return categ;
    } else {
      print(response.body);
      throw Exception('Failed to fetch Categorie by ID');
    }
  }



}