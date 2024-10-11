import '../entities/entities.dart';

class TransactionsModel {
  String transactionId;
  String requestId;
  String name;
  double value;
  String note;
  double rating;
  String feedback;
  String status;
  double pricePerKg;
  double weight;

  TransactionsModel({
    required this.transactionId,
    required this.requestId,
    required this.name,
    required this.value,
    required this.note,
    this.rating = 0.0,
    this.feedback = '',
    this.status = 'pending',
    this.pricePerKg = 0.0,
    this.weight = 0.0,
  });

  static final TransactionsModel empty = TransactionsModel(
    transactionId: '',
    requestId: '',
    name: '',
    value: 0.0,
    note: '',
    status: 'pending',
    pricePerKg: 0.0,
    weight: 0.0,
  );

  // Convert TransactionsEntity to TransactionsModel
  static TransactionsModel fromEntity(TransactionsEntity entity) {
    return TransactionsModel(
      transactionId: entity.transactionId,
      requestId: entity.requestId,
      name: entity.name,
      value: entity.value,
      note: entity.note,
      rating: entity.rating,
      feedback: entity.feedback,
      status: entity.status,
      pricePerKg: entity.pricePerKg,
      weight: entity.weight,
    );
  }

  // Convert a transaction to a JSON object
  Map<String, Object?> toJson() {
    return {
      'transactionId': transactionId,
      'requestId': requestId,
      'name': name,
      'value': value,
      'note': note,
      'rating': rating,
      'feedback': feedback,
      'status': status,
      'pricePerKg': pricePerKg,
      'weight': weight,
    };
  }

  // Convert a JSON object to a TransactionsModel
  factory TransactionsModel.fromJson(Map<String, dynamic> json) {
    return TransactionsModel(
      transactionId: json['transactionId'] as String? ?? '',
      requestId: json['requestId'] as String? ?? 'Unknown Request',
      name: json['name'] as String? ?? 'Unknown Product',
      value: (json['value'] as num?)?.toDouble() ?? 0.0,
      note: json['note'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      feedback: json['feedback'] as String? ?? '',
      status: json['status'] as String? ?? 'pending',
      pricePerKg: (json['pricePerKg'] as num?)?.toDouble() ?? 0.0,
      weight: (json['weight'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
