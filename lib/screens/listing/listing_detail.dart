import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/listing.dart';

class ListingDetail extends StatelessWidget {
  final Listing listing;
  const ListingDetail({required this.listing, super.key});

  @override
  Widget build(BuildContext context) {
    final initial = LatLng(listing.latitude, listing.longitude);
    return Scaffold(
      appBar: AppBar(title: Text(listing.name)),
      body: Column(
        children: [
          SizedBox(
            height: 200,
            child: FlutterMap(
              options: MapOptions(
                initialCenter: initial,
                initialZoom: 14,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.kigali_city_services',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: initial,
                      width: 40,
                      height: 40,
                      child: Icon(
                        Icons.location_on,
                        color: Theme.of(context).colorScheme.primary,
                        size: 40,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ListTile(
              title: const Text('Category'),
              subtitle: Text(listing.category)),
          ListTile(
              title: const Text('Address'),
              subtitle: Text(listing.address)),
          ListTile(
              title: const Text('Contact'),
              subtitle: Text(listing.contact)),
          ListTile(
              title: const Text('Description'),
              subtitle: Text(listing.description)),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.directions),
              label: const Text('Navigate'),
              onPressed: () {
                final url =
                    'https://www.google.com/maps/dir/?api=1&destination=${listing.latitude},${listing.longitude}';
                launchUrl(Uri.parse(url));
              },
            ),
          )
        ],
      ),
    );
  }
}
