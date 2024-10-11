import 'package:cloud_firestore/cloud_firestore.dart';

import '../entities/entities.dart';

class TransactionsModel {
  String documentId;
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
  DateTime? timestamp;

  TransactionsModel({
    this.documentId = '',
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
    this.timestamp,
  });

  static final TransactionsModel empty = TransactionsModel(
    documentId: '',
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
      documentId: entity.documentId,
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
      timestamp: entity.timestamp,
    );
  }

  // Convert a transaction to a JSON object
  Map<String, Object?> toJson() {
    return {
      'documentId': documentId,
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
      'timestamp': timestamp,
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
      // Parse the timestamp as DateTime from Firestore's Timestamp
      timestamp: (json['timestamp'] as Timestamp?)?.toDate(),
    );
  }

  // Factory method to create TransactionsModel from Firebase document
  factory TransactionsModel.fromDocument(Map<String, Object?> doc, String id) {
    return TransactionsModel(
      documentId: id,
      transactionId: doc['transactionId'] as String? ?? '',
      requestId: doc['requestId'] as String? ?? 'Unknown Request',
      name: doc['name'] as String? ?? 'Unknown Product',
      value: (doc['value'] as num?)?.toDouble() ?? 0.0,
      note: doc['note'] as String? ?? '',
      rating: (doc['rating'] as num?)?.toDouble() ?? 0.0,
      feedback: doc['feedback'] as String? ?? '',
      status: doc['status'] as String? ?? 'pending',
      pricePerKg: (doc['pricePerKg'] as num?)?.toDouble() ?? 0.0,
      weight: (doc['weight'] as num?)?.toDouble() ?? 0.0,
      timestamp: (doc['timestamp'] as Timestamp).toDate(),
    );
  }

  TransactionsModel copyWith(
      {required String feedback,
      required double rating,
      required String status}) {
    return TransactionsModel(
      transactionId: this.transactionId,
      requestId: this.requestId,
      name: this.name,
      value: this.value,
      note: this.note,
      rating: rating,
      feedback: feedback,
      status: status,
      pricePerKg: this.pricePerKg,
      weight: this.weight,
      timestamp: this.timestamp,
    );
  }
}
