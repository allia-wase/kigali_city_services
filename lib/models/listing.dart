import 'package:cloud_firestore/cloud_firestore.dart';

class Listing {
  String? id;
  final String name;
  final String category;
  final String address;
  final String contact;
  final String description;
  final double latitude;
  final double longitude;
  final String createdBy;
  final Timestamp timestamp;

  Listing({
    this.id,
    required this.name,
    required this.category,
    required this.address,
    required this.contact,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.createdBy,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() => {
        'name': name,
        'category': category,
        'address': address,
        'contact': contact,
        'description': description,
        'latitude': latitude,
        'longitude': longitude,
        'createdBy': createdBy,
        'timestamp': timestamp,
      };

  factory Listing.fromDoc(DocumentSnapshot doc) {
    final m = doc.data() as Map<String, dynamic>;
    return Listing(
      id: doc.id,
      name: m['name'],
      category: m['category'],
      address: m['address'],
      contact: m['contact'],
      description: m['description'],
      latitude: m['latitude'],
      longitude: m['longitude'],
      createdBy: m['createdBy'],
      timestamp: m['timestamp'],
    );
  }
}
