import 'package:cloud_firestore/cloud_firestore.dart';
import 'interfaces/i_usage_service.dart';

class ClickService implements IUsageService {
  static final ClickService instance = ClickService._();
  ClickService._();

  @override
  Future<void> incrementUsage(String hexId) async {
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
