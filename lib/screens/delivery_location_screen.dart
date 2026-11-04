
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class DeliveryLocationScreen extends StatefulWidget {
  const DeliveryLocationScreen({super.key});

  @override
  State<DeliveryLocationScreen> createState() =>
      _DeliveryLocationScreenState();
}

class _DeliveryLocationScreenState
    extends State<DeliveryLocationScreen> {
  final MapController _mapController = MapController();
  final TextEditingController _searchController =
  TextEditingController();

  LatLng _selectedLocation =
  const LatLng(31.2001, 29.9187); // Alexandria, Egypt

  String _selectedAddress = '';
  List<Map<String, dynamic>> _searchResults = [];

  bool _loading = false;
  bool _searching = false;
  DateTime? _lastLookup;

  // Change this to your actual Android application ID.
  // Example: com.example.my_store
  static const String _appId = 'com.example.my_app';

  @override
  void dispose() {
    _searchController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _searchAddress() async {
    final query = _searchController.text.trim();

    if (query.isEmpty) {
      _showMessage('Enter an address or place name.');
      return;
    }

    setState(() {
      _searching = true;
      _searchResults = [];
    });

    try {
      final uri = Uri.https(
        'nominatim.openstreetmap.org',
        '/search',
        {
          'q': query,
          'format': 'jsonv2',
          'limit': '5',
          'addressdetails': '1',
        },
      );

      final response = await http.get(
        uri,
        headers: {
          'User-Agent': '$_appId FlutterDeliveryPicker/1.0',
          'Accept-Language': 'en',
        },
      );

      if (response.statusCode != 200) {
        throw Exception(
          'Search failed (HTTP ${response.statusCode}).',
        );
      }

      final data =
      jsonDecode(response.body) as List<dynamic>;

      if (!mounted) return;

      setState(() {
        _searchResults = data
            .map((item) => Map<String, dynamic>.from(item))
            .toList();
      });

      if (_searchResults.isEmpty) {
        _showMessage('No locations found. Try another search.');
      }
    } catch (e) {
      _showMessage('Could not search: $e');
    } finally {
      if (mounted) {
        setState(() => _searching = false);
      }
    }
  }

  void _selectSearchResult(Map<String, dynamic> result) {
    final location = LatLng(
      double.parse(result['lat'].toString()),
      double.parse(result['lon'].toString()),
    );

    setState(() {
      _selectedLocation = location;
      _selectedAddress =
          result['display_name']?.toString() ?? '';
      _searchResults = [];
      _searchController.text = _selectedAddress;
    });

    _mapController.move(location, 17);
    FocusScope.of(context).unfocus();
  }

  void _onMapTap(TapPosition tapPosition, LatLng point) {
    setState(() {
      _selectedLocation = point;
      _selectedAddress = '';
      _searchResults = [];
    });
  }

  Future<void> _getAddressForPin() async {
    // Respect the public Nominatim limit of one request/second.
    final now = DateTime.now();
    final last = _lastLookup;

    if (last != null &&
        now.difference(last).inMilliseconds < 1100) {
      _showMessage('Please wait a moment before retrying.');
      return;
    }

    _lastLookup = now;
    setState(() => _loading = true);

    try {
      final uri = Uri.https(
        'nominatim.openstreetmap.org',
        '/reverse',
        {
          'lat': _selectedLocation.latitude.toString(),
          'lon': _selectedLocation.longitude.toString(),
          'format': 'jsonv2',
          'addressdetails': '1',
        },
      );

      final response = await http.get(
        uri,
        headers: {
          'User-Agent': '$_appId FlutterDeliveryPicker/1.0',
          'Accept-Language': 'en',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Address lookup failed.');
      }

      final data =
      jsonDecode(response.body) as Map<String, dynamic>;

      if (!mounted) return;

      setState(() {
        _selectedAddress =
            data['display_name']?.toString() ??
                'Address not available for this point';
      });
    } catch (e) {
      _showMessage('Could not find address: $e');
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _useCurrentLocation() async {
    setState(() => _loading = true);

    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        throw Exception('Enable location services on your phone.');
      }

      var permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        throw Exception('Location permission was not granted.');
      }

      final position = await Geolocator.getCurrentPosition();

      final location = LatLng(
        position.latitude,
        position.longitude,
      );

      setState(() {
        _selectedLocation = location;
        _selectedAddress = '';
        _searchResults = [];
      });

      _mapController.move(location, 17);
    } catch (e) {
      _showMessage(e.toString());
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  void _confirmLocation() {
    Navigator.pop(
      context,
      <String, dynamic>{
        'address': _selectedAddress.isEmpty
            ? 'Selected map location'
            : _selectedAddress,
        'latitude': _selectedLocation.latitude,
        'longitude': _selectedLocation.longitude,
      },
    );
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delivery Location'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    textInputAction: TextInputAction.search,
                    onSubmitted: (_) => _searchAddress(),
                    decoration: const InputDecoration(
                      hintText: 'Search for an address or place',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  onPressed: _searching ? null : _searchAddress,
                  icon: _searching
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                      : const Icon(Icons.search),
                ),
              ],
            ),
          ),

          if (_searchResults.isNotEmpty)
            Container(
              constraints: const BoxConstraints(maxHeight: 180),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final result = _searchResults[index];

                  return ListTile(
                    leading: const Icon(Icons.location_on),
                    title: Text(
                      result['display_name']?.toString() ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () => _selectSearchResult(result),
                  );
                },
              ),
            ),

          Expanded(
            child: Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _selectedLocation,
                    initialZoom: 13,
                    onTap: _onMapTap,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: _appId,
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: _selectedLocation,
                          width: 50,
                          height: 50,
                          child: const Icon(
                            Icons.location_pin,
                            size: 48,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                    RichAttributionWidget(
                      attributions: [
                        TextSourceAttribution(
                          'OpenStreetMap contributors',
                          onTap: () {
                            // Attribution link:
                            // https://www.openstreetmap.org/copyright
                          },
                        ),
                      ],
                    ),
                  ],
                ),

                Positioned(
                  right: 12,
                  top: 12,
                  child: FloatingActionButton.small(
                    heroTag: 'gps_button',
                    onPressed:
                    _loading ? null : _useCurrentLocation,
                    child: const Icon(Icons.my_location),
                  ),
                ),

                Positioned(
                  left: 12,
                  right: 12,
                  bottom: 12,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Your delivery address',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _selectedAddress.isEmpty
                                ? 'Tap the map or search for a place.'
                                : _selectedAddress,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${_selectedLocation.latitude.toStringAsFixed(6)}, '
                                '${_selectedLocation.longitude.toStringAsFixed(6)}',
                            style: Theme.of(context)
                                .textTheme.bodySmall,
                          ),
                          TextButton.icon(
                            onPressed:
                            _loading ? null : _getAddressForPin,
                            icon: const Icon(Icons.pin_drop),
                            label: const Text('Get address for pin'),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _confirmLocation,
                              child: const Text('Confirm Address'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                if (_loading)
                  const Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: LinearProgressIndicator(),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
