import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/models/via_cep_address.dart';

class ViaCepService {
  Future<ViaCepAddress?> getAddressFromCep(String cep) async {
    String cleanCep = cep.replaceAll('.', '').replaceAll('-', '');
    try {
      String url = 'https://viacep.com.br/ws/$cleanCep/json/';
      var response = await Dio().get(url);

      if (response.data.isEmpty) {
        return Future.error('CEP Inválido');
      }
      ViaCepAddress address =
          ViaCepAddress.fromJson(json.encode(response.data));
      return address;
    } on DioError catch (e) {
      return Future.error('Erro ao buscar CEP: $e');
    }
  }
}
