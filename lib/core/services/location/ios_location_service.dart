import 'package:flutter/services.dart';

class IosLocationService {
  const IosLocationService._();

  static const MethodChannel _channel = MethodChannel('agrix/location');

  static Future<({double latitude, double longitude})> getCurrentLocation() async {
    final dynamic result = await _channel.invokeMethod('getCurrentLocation');

    if (result is! Map) {
      throw const FormatException('Invalid location payload from iOS channel');
    }

    final lat = result['latitude'];
    final lng = result['longitude'];

    if (lat is! num || lng is! num) {
      throw const FormatException('Missing latitude/longitude in location payload');
    }

    return (latitude: lat.toDouble(), longitude: lng.toDouble());
  }
}
