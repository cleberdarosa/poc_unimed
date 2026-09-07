import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/bottom_nav_item_model.dart';

abstract interface class BottomNavDataSource {
  Future<BottomNavigationResponseModel> getBottomNavigation();
}

class AssetBottomNavDataSource implements BottomNavDataSource {
  final String assetPath;

  const AssetBottomNavDataSource({
    this.assetPath = 'assets/mocks/bottom_navigation.json',
  });

  @override
  Future<BottomNavigationResponseModel> getBottomNavigation() async {
    final jsonString = await rootBundle.loadString(assetPath);
    final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;

    return BottomNavigationResponseModel.fromJson(jsonMap);
  }
}

class ApiBottomNavDataSource implements BottomNavDataSource {
  final Future<Map<String, dynamic>> Function() requestBottomNavigation;

  const ApiBottomNavDataSource({required this.requestBottomNavigation});

  @override
  Future<BottomNavigationResponseModel> getBottomNavigation() async {
    final responseJson = await requestBottomNavigation();
    return BottomNavigationResponseModel.fromJson(responseJson);
  }
}
