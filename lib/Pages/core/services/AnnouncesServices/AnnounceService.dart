import 'dart:convert';
import 'package:internshipapplication/Pages/core/model/AdsModels/AdsFilterModel.dart';
import 'package:internshipapplication/Pages/core/model/AdsModels/AnnounceModel.dart';
import 'package:internshipapplication/Pages/core/model/AdsModels/CreateAnnounceModel.dart';
import 'package:http/http.dart' as http;
import 'package:internshipapplication/constants.dart';

class AnnounceService{




  Future<bool> deleteData(int id) async {
    final String apiUrl = "$baseUrl/api/Ads?id=$id";

    try {
      final response = await http.delete(Uri.parse(apiUrl),);

      if (response.statusCode == 200) {

        return true;
      } else {
        print("Failed to delete Ads. Status code: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Error deleting item: $e");
      return false;
    }
  }

  Future<Map<String, dynamic>> createAd(CreateAnnounce adModel) async {

    var request = http.MultipartRequest('POST', Uri.parse("$baseUrl/api/Ads/CreateAds"));

    // Convert adModel to JSON
    Map<String, dynamic> adData = adModel.toJson();

    // Add other fields to the request
    adData.forEach((key, value) {
      request.fields[key] = value.toString();
    });

    // Send the request
    var response = await request.send();

    // Read response
    String responseString = await response.stream.bytesToString();

    // Parse the response JSON
    Map<String, dynamic> responseData = json.decode(responseString);

    return responseData;
  }



// Update announce
  Future<AnnounceModel?> updateAnnouncement(int announcementId, CreateAnnounce updatedData) async {
    try {
      var url = Uri.parse("$baseUrl/api/Ads/$announcementId");
      var headers = {'Content-Type': 'application/json'};
      var jsonBody = json.encode(updatedData.toJson());

      var response = await http.put(url, headers: headers, body: jsonBody);

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        return AnnounceModel.fromJson(responseData);
      } else {
        print('Failed to update announcement. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error updating announcement: $e');
      return null;
    }
  }


  //fileter data with pagination
  Future<Map<String, dynamic>> getFilteredAds(AdsFilterModel filter) async {
    print(filter.toJson());
    try {

      final response = await http.post(
        Uri.parse("$baseUrl/api/Test/filtered"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(filter.toJson()),
      );
      print(response.body);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData;
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }
}