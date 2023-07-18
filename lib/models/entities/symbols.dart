class TradeSymbol{
  final String? name;
  final int? digit;

  TradeSymbol({
    this.name, 
    this.digit,
  });

  factory TradeSymbol.fromTF2v1API(Map<String, dynamic> json) {
    return TradeSymbol(
      name: json['name'],
      digit: json['digit'],
    );
  }
}