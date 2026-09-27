import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/menu_item_model.dart';

abstract interface class MenuDataSource {
  Future<MenuResponseModel> getMenu();
}

class AssetMenuDataSource implements MenuDataSource {
  final String assetPath;

  const AssetMenuDataSource({this.assetPath = 'assets/mocks/menu.json'});

  @override
  Future<MenuResponseModel> getMenu() async {
    final jsonString = await rootBundle.loadString(assetPath);
    final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
    return MenuResponseModel.fromJson(jsonMap);
  }
}

/// Estrutura pronta para a API futura.
///
/// Quando o cliente HTTP do projeto estiver definido, implemente [getMenu]
/// fazendo GET no endpoint e convertendo o JSON com
/// `MenuResponseModel.fromJson(responseJson)`.
class ApiMenuDataSource implements MenuDataSource {
  final Future<Map<String, dynamic>> Function() requestMenu;

  const ApiMenuDataSource({required this.requestMenu});

  @override
  Future<MenuResponseModel> getMenu() async {
    final responseJson = await requestMenu();
    return MenuResponseModel.fromJson(responseJson);
  }
}
