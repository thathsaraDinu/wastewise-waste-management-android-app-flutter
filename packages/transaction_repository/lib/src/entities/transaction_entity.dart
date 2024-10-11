class TransactionsEntity {
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

  TransactionsEntity({
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

  static TransactionsEntity fromDocument(Map<String, Object?> doc,
      [String? id]) {
    return TransactionsEntity(
      transactionId: id ?? '',
      requestId: doc['requestId'] as String? ?? 'Unknown Request',
      name: doc['name'] as String? ?? 'Unknown Product',
      value: (doc['value'] as num?)?.toDouble() ?? 0.0,
      note: doc['note'] as String? ?? '',
      rating: (doc['rating'] as num?)?.toDouble() ?? 0.0,
      feedback: doc['feedback'] as String? ?? '',
      status: doc['status'] as String? ?? 'pending',
      pricePerKg: (doc['pricePerKg'] as num?)?.toDouble() ?? 0.0,
      weight: (doc['weight'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
