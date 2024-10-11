import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:transaction_repository/transaction_repository.dart';

class FirebaseTransactions {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Save a transaction to Firebase
  Future<void> saveTransaction(TransactionsModel transaction) async {
    try {
      // Add the transaction and get the reference of the new document
      DocumentReference docRef =
          await _firestore.collection('transactions').add(transaction.toJson());

      // After the transaction is saved, update the transactionId with the document ID
      transaction.transactionId = docRef.id;

      // Optionally, update the document in Firestore with the newly assigned transactionId
      await docRef.update({'transactionId': docRef.id});
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
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return TransactionsModel.fromJson(data);
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch transactions: $e');
    }
  }
}
