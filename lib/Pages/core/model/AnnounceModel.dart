import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:internshipapplication/Pages/core/model/CategoryModel.dart';
import 'package:internshipapplication/Pages/core/model/CitiesModel.dart';
import 'package:internshipapplication/Pages/core/model/CountriesModel.dart';

class AnnounceModel {
  int? id;
  String? title;
  String? description;
  String? details;
  int? price;
  String? imagePrinciple;
  String? videoName;
  int? idCateg;
  Categories? categories;
  int? idCountrys;
  Countries? countries;
  int? idCity;
  Cities? cities;
  String? locations;
  int? active;
  bool? like;
  bool? boosted;

  AnnounceModel({
    this.id,
    this.title,
    this.description,
    this.details,
    this.price,
    this.imagePrinciple,
    this.videoName,
    this.idCateg,
    this.categories,
    this.idCountrys,
    this.countries,
    this.idCity,
    this.cities,
    this.locations,
    this.active,
    this.like,
    this.boosted
  });

  factory AnnounceModel.fromJson(Map<String, dynamic> json) {
    return AnnounceModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      details: json['details'],
      price: json['price'],
      imagePrinciple: json['imagePrinciple'],
      videoName: json['videoName'],
      idCateg: json['idCateg'],
      categories: json['categories'] != null ? Categories.fromJson(json['categories']) : null,
      idCountrys: json['idCountrys'],
      countries: json['countries'] != null ? Countries.fromJson(json['countries']) : null,
      idCity: json['idCity'],
      cities: json['cities'] != null ? Cities.fromJson(json['cities']) : null,
      locations: json['locations'],
      active: json['active'],
      boosted: json['boosted'],
      like: false,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['details'] = details;
    data['price'] = price;
    data['imagePrinciple'] = imagePrinciple;
    data['videoName'] = videoName;
    data['idCateg'] = idCateg;
    if (categories != null) {
      data['categories'] = categories?.toJson();
    }
    data['idCountrys'] = idCountrys;
    if (countries != null) {
      data['countries'] = countries?.toJson();
    }
    data['idCity'] = idCity;
    if (cities != null) {
      data['cities'] = cities?.toJson();
    }
    data['locations'] = locations;
    data['active'] = active;
    return data;
  }
}
