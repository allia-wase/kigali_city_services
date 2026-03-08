import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/listing_provider.dart';
import '../../services/firestore_service.dart';
import '../listing/listing_form.dart';
import '../listing/listing_detail.dart';

class MyListingsScreen extends ConsumerWidget {
  const MyListingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listingsAsync = ref.watch(userListingsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('My Listings')),
      body: listingsAsync.when(
        data: (list) {
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (_, i) {
              final l = list[i];
              return ListTile(
                title: Text(l.name),
                subtitle: Text(l.category),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => ListingForm(existing: l)),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        final ok = await showDialog<bool>(
                          context: context,
                          builder: (c) => AlertDialog(
                            title: const Text('Delete?'),
                            content: const Text('Are you sure you want to delete this listing?'),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('No')),
                              TextButton(onPressed: () => Navigator.pop(c, true), child: const Text('Yes')),
                            ],
                          ),
                        );
                        if (ok == true) {
                          await FirestoreService.instance.deleteListing(l.id!);
                        }
                      },
                    ),
                  ],
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ListingDetail(listing: l)),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ListingForm()),
        ),
      ),
    );
  }
}
