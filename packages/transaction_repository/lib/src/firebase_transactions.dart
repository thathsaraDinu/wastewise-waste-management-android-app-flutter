import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:transaction_repository/transaction_repository.dart';

class FirebaseTransactions {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Save a transaction to Firebase
  Future<void> saveTransaction(TransactionsModel transaction) async {
    try {
      DocumentReference docRef =
          await _firestore.collection('transactions').add(transaction.toJson());
      transaction.transactionId = docRef.id;
    } catch (e) {
      throw Exception('Failed to save transaction: $e');
    }
  }

  // Fetch transactions from Firebase
  Future<List<TransactionsModel>> fetchTransactions() async {
    try {
      QuerySnapshot snapshot =
          await _firestore.collection('transactions').get();
      return snapshot.docs.map((doc) {
        // Explicitly map the data to TransactionsModel
        return TransactionsModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch transactions: $e');
    }
  }
}
