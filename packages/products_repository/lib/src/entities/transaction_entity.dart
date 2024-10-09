class TransactionsEntity {
  String transactionId;
  String requestId;
  String name;
  double value;
  String note;
  double rating;
  String feedback;

  TransactionsEntity({
    required this.transactionId,
    required this.requestId,
    required this.name,
    required this.value,
    required this.note,
    // Ratings and feedback are optional
    this.rating = 0.0,
    this.feedback = '',
  });

  static TransactionsEntity fromDocument(Map<String, Object?> doc,
      [String? id]) {
    return TransactionsEntity(
      transactionId: id ?? '', // Provide default empty string if null
      requestId:
          doc['requestId'] as String? ?? 'Unknown Request', // Handle null case
      name: doc['name'] as String? ?? 'Unknown Product', // Handle null case
      value:
          (doc['value'] as num?)?.toDouble() ?? 0.0, // Default to 0.0 if null
      note: doc['note'] as String? ?? '',
      rating: (doc['rating'] as num?)?.toDouble() ?? 0.0, // Handle null case
      feedback: doc['feedback'] as String? ?? '',
    );
  }
}
