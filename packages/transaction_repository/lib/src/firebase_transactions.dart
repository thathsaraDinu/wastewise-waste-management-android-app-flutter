import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:transaction_repository/transaction_repository.dart';

class FirebaseTransactions {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final CollectionReference transactionsCollection =
      FirebaseFirestore.instance.collection('transactions');

  // Get a specific document reference by transaction ID
  DocumentReference getTransactionDocument(String transactionId) {
    return transactionsCollection.doc(transactionId);
  }

  Future<List<TransactionsModel>> _fetchTransactions() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('transactions').get();
    return snapshot.docs
        .map((doc) => TransactionsModel.fromDocument(
            doc.data() as Map<String, Object?>, doc.id))
        .toList();
  }

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

  // Update feedback, ratings, and status of a transaction
  Future<void> updateTransaction(
    String transactionId, {
    String? feedback,
    double? rating,
    String? status,
  }) async {
    try {
      // Get a reference to the document with the given transactionId
      DocumentReference docRef =
          _firestore.collection('transactions').doc(transactionId);

      // Prepare the data to update
      Map<String, dynamic> updatedData = {};
      if (feedback != null) {
        updatedData['feedback'] = feedback; // Update feedback
      }
      if (rating != null) {
        updatedData['rating'] = rating; // Update rating
      }
      if (status != null) {
        updatedData['status'] = status; // Update status
      }

      // Update the document
      await docRef.update(updatedData);
    } catch (e) {
      throw Exception('Failed to update transaction: $e');
    }
  }
}
