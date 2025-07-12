// lib/services/usage_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class ClickService {
  static Future<void> incrementUsage(String hexId) async {
    final docRef = FirebaseFirestore.instance.collection('clicks').doc(hexId);

    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final snapshot = await transaction.get(docRef);

        if (!snapshot.exists) {
          transaction.set(docRef, {'usage': 1});
        } else {
          final currentUsage = snapshot.data()?['usage'] ?? 0;
          transaction.update(docRef, {'usage': currentUsage + 1});
        }
      });
    } on FirebaseException catch (e) {
      if (e.code == 'resource-exhausted') {}
    }
  }
}
