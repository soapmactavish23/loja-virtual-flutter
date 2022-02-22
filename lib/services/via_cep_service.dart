import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class ViaCepService {
  Future<void> getAddressFromCep(String cep) async {
    String cleanCep = cep.replaceAll('.', '').replaceAll('-', '');

    try {
      var response =
          await Dio().get('https://viacep.com.br/ws/${cleanCep}/json/');

      if (response.data.isEmpty) {
        return Future.error('CEP Inválido');
      }
      print(response.data);
    } on DioError catch (e) {
      return Future.error('Erro ao buscar CEP: $e');
    }
  }
}
