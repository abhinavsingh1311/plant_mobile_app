import 'package:geolocator/geolocator.dart';
import 'package:weather/weather.dart';

class WeatherService {
  final WeatherFactory _wf = WeatherFactory('29c9a9ce96f8d1a51fd8826a8c3ceb9d');
  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
          'Location permissions are permanently denied, cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<Weather> getCurrentWeather() async {
    try {
      final position = await _getCurrentLocation();
      final weather = await _wf.currentWeatherByLocation(
        position.latitude,
        position.longitude,
      );
      return weather;
    } catch (e) {
      throw Exception('Failed to get weather data: $e');
    }
  }

  String getWateringAdvice(Weather weather, String unit) {
    if (weather.temperature?.celsius == null) {
      return "No weather data available";
    }

    final temp = weather.temperature!.celsius!;
    final condition = weather.weatherMain?.toLowerCase() ?? '';
    final displayTemp = unit == 'Imperial' ? (temp * 9 / 5) + 32 : temp;

    if (condition.contains('rain')) {
      return "It's raining! Hold off on watering outdoor plants.";
    }

    if (displayTemp > (unit == 'Imperial' ? 86 : 30)) {
      return "It's very hot! Consider watering twice today.";
    }

    if (displayTemp > (unit == 'Imperial' ? 77 : 25)) {
      return "Warm weather - check soil moisture levels.";
    }

    if (displayTemp < (unit == 'Imperial' ? 50 : 10)) {
      return "Cold weather - reduce watering frequency.";
    }

    return "Normal watering schedule recommended.";
  }
}
