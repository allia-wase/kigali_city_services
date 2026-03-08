import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/listing_provider.dart';
import '../listing/listing_detail.dart';

class MapViewScreen extends ConsumerWidget {
  const MapViewScreen({super.key});

  static const _kigaliCenter = LatLng(-1.9441, 30.0619);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final list = ref.watch(filteredListingsProvider);
    final markers = list
        .where((l) => l.latitude != 0 && l.longitude != 0)
        .map((l) => Marker(
              point: LatLng(l.latitude, l.longitude),
              width: 40,
              height: 40,
              child: GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ListingDetail(listing: l)),
                ),
                child: Icon(
                  Icons.location_on,
                  color: Theme.of(context).colorScheme.primary,
                  size: 40,
                ),
              ),
            ))
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Map View')),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: _kigaliCenter,
          initialZoom: 12,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.kigali_city_services',
          ),
          MarkerLayer(markers: markers),
          RichAttributionWidget(
            attributions: [
              TextSourceAttribution(
                'OpenStreetMap contributors',
                onTap: () =>
                    launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
