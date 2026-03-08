import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/listing.dart';

class FirestoreService {
  FirestoreService._();
  static final instance = FirestoreService._();
  final _db = FirebaseFirestore.instance;

  Stream<List<Listing>> listingsStream() => _db
      .collection('listings')
      .orderBy('timestamp', descending: true)
      .snapshots()
      .map((snap) => snap.docs.map(Listing.fromDoc).toList());

  Stream<List<Listing>> userListingsStream(String uid) => _db
      .collection('listings')
      .where('createdBy', isEqualTo: uid)
      .snapshots()
      .map((snap) => snap.docs.map(Listing.fromDoc).toList());

  Future<void> addListing(Listing l) async =>
      await _db.collection('listings').add(l.toMap());

  Future<void> updateListing(Listing l) async =>
      await _db.collection('listings').doc(l.id).update(l.toMap());

  Future<void> deleteListing(String id) async =>
      await _db.collection('listings').doc(id).delete();
}
