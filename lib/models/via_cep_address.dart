import 'dart:convert';

class ViaCepAddress {
  String? cep;
  String? logradouro;
  String? bairro;
  String? complemento;
  String? localidade;
  String? uf;
  String? ibge;
  ViaCepAddress({
    this.cep,
    this.logradouro,
    this.bairro,
    this.complemento,
    this.localidade,
    this.uf,
    this.ibge,
  });

  Map<String, dynamic> toMap() {
    return {
      'cep': cep,
      'logradouro': logradouro,
      'bairro': bairro,
      'complemento': complemento,
      'localidade': localidade,
      'uf': uf,
      'ibge': ibge,
    };
  }

  factory ViaCepAddress.fromMap(Map<String, dynamic> map) {
    return ViaCepAddress(
      cep: map['cep'],
      logradouro: map['logradouro'],
      bairro: map['bairro'],
      complemento: map['complemento'],
      localidade: map['localidade'],
      uf: map['uf'],
      ibge: map['ibge'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ViaCepAddress.fromJson(String source) =>
      ViaCepAddress.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ViaCepAddress(cep: $cep, logradouro: $logradouro, bairro: $bairro, complemento: $complemento, localidade: $localidade, uf: $uf, ibge: $ibge)';
  }
}
