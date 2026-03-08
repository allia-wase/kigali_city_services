import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/listing_provider.dart';
import '../listing/listing_detail.dart';

class DirectoryScreen extends ConsumerWidget {
  const DirectoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allAsync = ref.watch(listingListProvider);
    final filtered = ref.watch(filteredListingsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Directory')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search by name',
                prefixIcon: Icon(Icons.search, color: Theme.of(context).colorScheme.primary),
              ),
              onChanged: (q) => ref.read(searchQueryProvider.notifier).state = q,
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
                children: [null, 'Hospital', 'Police Station', 'Library', 'Restaurant', 'Café', 'Park', 'Tourist Attraction']
                    .map((cat) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: ChoiceChip(
                            avatar: ref.watch(categoryFilterProvider) == cat
                                ? Icon(Icons.check, size: 18, color: Theme.of(context).colorScheme.onPrimary)
                                : null,
                            label: Text(cat ?? 'All'),
                            selected: ref.watch(categoryFilterProvider) == cat,
                            onSelected: (_) => ref.read(categoryFilterProvider.notifier).state = cat,
                          ),
                        ))
                    .toList()),
          ),
          Expanded(
            child: allAsync.when(
              data: (_) {
                return ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (_, i) {
                    final l = filtered[i];
                    return ListTile(
                      title: Text(l.name),
                      subtitle: Text(l.category),
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
          ),
        ],
      ),
    );
  }
}
