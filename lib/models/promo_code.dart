class PromoCode {
  final String? id;
  final String code;
  final String discountType; 
  final double discountValue;
  final DateTime expiryDate;

  PromoCode({
     this.id,
    required this.code,
    required this.discountType,
    required this.discountValue,
    required this.expiryDate,
  });

  // for API (JSON)
  factory PromoCode.fromJson(Map<String, dynamic> json) {
    return PromoCode(
      id: json['_id'] ?? '',
      code: json['code'],
      discountType: json['discountType'],
      discountValue: (json['discountValue'] as num).toDouble(),
      expiryDate: DateTime.parse(json['expiryDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'code': code,
      'discountType': discountType,
      'discountValue': discountValue,
      'expiryDate': expiryDate.toIso8601String(),
    };
  }

  // for local database (Map)
  factory PromoCode.fromMap(Map<String, dynamic> map) {
    return PromoCode(
      id: map['id'] ?? '',
      code: map['code'],
      discountType: map['discountType'],
      discountValue: (map['discountValue'] as num).toDouble(),
      expiryDate: DateTime.parse(map['expiryDate']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'code': code,
      'discountType': discountType,
      'discountValue': discountValue,
      'expiryDate': expiryDate.toIso8601String(),
    };
  }
}
