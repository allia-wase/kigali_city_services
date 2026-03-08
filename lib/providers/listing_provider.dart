import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/listing.dart';
import '../services/firestore_service.dart';
import 'auth_provider.dart';

final listingListProvider = StreamProvider<List<Listing>>(
  (ref) => FirestoreService.instance.listingsStream(),
);

final userListingsProvider = StreamProvider<List<Listing>>((ref) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return const Stream.empty();
  return FirestoreService.instance.userListingsStream(user.uid);
});

final searchQueryProvider = StateProvider<String>((_) => '');
final categoryFilterProvider = StateProvider<String?>((_) => null);

final filteredListingsProvider = Provider<List<Listing>>((ref) {
  final all = ref.watch(listingListProvider).value ?? [];
  final query = ref.watch(searchQueryProvider);
  final cat   = ref.watch(categoryFilterProvider);

  return all.where((l) {
    if (cat != null && l.category != cat) return false;
    if (query.isNotEmpty && !l.name.toLowerCase().contains(query.toLowerCase())) return false;
    return true;
  }).toList();
});
