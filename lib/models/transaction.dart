import '../entities/transaction_entity.dart';

class TransactionsModel {
  String transactionId;
  String requestId;
  String name;
  double value;
  String note;
  double rating;
  String feedback;

  TransactionsModel({
    required this.transactionId,
    required this.requestId,
    required this.name,
    required this.value,
    required this.note,
    // Ratings and feedback are optional
    this.rating = 0.0,
    this.feedback = '',
  });

  // Static method for creating an empty ProductModel
  static final TransactionsModel empty = TransactionsModel(
    transactionId: '',
    requestId: '',
    name: '',
    value: 0.0,
    note: '',
  );

  // Convert ProductEntity to ProductModel
  static TransactionsModel fromEntity(TransactionsEntity entity) {
    return TransactionsModel(
      transactionId: entity.transactionId,
      requestId: entity.requestId,
      name: entity.name,
      value: entity.value,
      note: entity.note,
      rating: entity.rating,
      feedback: entity.feedback,
    );
  }
}
