import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/listing_provider.dart';
import '../../services/firestore_service.dart';
import '../listing/listing_form.dart';
import '../listing/listing_detail.dart';

class MyListingsScreen extends ConsumerStatefulWidget {
  const MyListingsScreen({super.key});

  @override
  ConsumerState<MyListingsScreen> createState() => _MyListingsScreenState();
}

class _MyListingsScreenState extends ConsumerState<MyListingsScreen> {
  String? _deletingId;

  Future<void> _deleteListing(BuildContext context, String id) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Delete?'),
        content: const Text('Are you sure you want to delete this listing?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c, false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(c, true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    setState(() => _deletingId = id);
    try {
      await FirestoreService.instance.deleteListing(id);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _deletingId = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final listingsAsync = ref.watch(userListingsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('My Listings')),
      body: Stack(
        children: [
          listingsAsync.when(
            data: (list) {
              return ListView.builder(
                itemCount: list.length,
                itemBuilder: (_, i) {
                  final l = list[i];
                  final isDeleting = _deletingId == l.id;
                  return ListTile(
                    title: Text(l.name),
                    subtitle: Text(l.category),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: isDeleting ? null : () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => ListingForm(existing: l)),
                          ),
                        ),
                        IconButton(
                          icon: isDeleting
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Icon(Icons.delete),
                          onPressed: isDeleting ? null : () => _deleteListing(context, l.id!),
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
        ],
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
