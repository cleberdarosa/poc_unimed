class Familia {
  final String nome;
  final List<PlanoFamilia> planos;

  Familia({required this.nome, required this.planos});

  factory Familia.fromJson(Map<String, dynamic> json) {
    return Familia(
      nome: json['nm_usuario'] ?? '',
      planos: (json['planos'] as List)
          .map((item) => PlanoFamilia.fromJson(item))
          .toList(),
    );
  }
}

class PlanoFamilia {
  final String plano;
  final String carteira;
  final String statusCarteira;

  PlanoFamilia({
    required this.plano,
    required this.carteira,
    required this.statusCarteira,
  });

  factory PlanoFamilia.fromJson(Map<String, dynamic> json) {
    return PlanoFamilia(
      plano: json['Plano'] ?? '',
      carteira: json['carteira']?['carteira'] ?? '',
      statusCarteira: json['carteira']?['stcarteira'] ?? '',
    );
  }
}
