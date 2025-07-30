import 'package:flutter/material.dart';
import 'dart:ui';

class WeatherForecastScroll extends StatelessWidget {
  /// ✅ Dynamic Weather Data (Replace with API response)
  final Map<String, dynamic> weatherData = {
    "morning_forecast": "No rain",
    "afternoon_forecast": "Thunderstorms in some areas",
    "night_forecast": "No rain",
    "summary_forecast": "Thunderstorms in some areas",
    "summary_when": "Afternoon",
    "min_temp": 24,
    "max_temp": 34,
  };

  /// ✅ Time Period Forecast Mapping (Including Weather Icons)
  final List<Map<String, dynamic>> forecastPeriods = [
    {"time": "Morning", "key": "morning_forecast", "icon": Icons.wb_sunny}, // 🌞
    {"time": "Afternoon", "key": "afternoon_forecast", "icon": Icons.flash_on}, // ⛈️
    {"time": "Night", "key": "night_forecast", "icon": Icons.nightlight_round}, // 🌙
  ];

  WeatherForecastScroll({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// ✅ Horizontal Scrollable Weather Cards
        SizedBox(
          height: 180,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            scrollDirection: Axis.horizontal,
            itemCount: forecastPeriods.length,
            separatorBuilder: (context, index) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final period = forecastPeriods[index];
              final forecast = weatherData[period["key"]];
              final isStorm = forecast.contains("Thunderstorms"); // ⚠️ Detect Storm

              return _buildForecastCard(period["time"], forecast, period["icon"], isStorm);
            },
          ),
        ),

        const SizedBox(height: 20),

        /// ✅ Overall Summary Box
        _buildWeatherSummary(),
      ],
    );
  }

  /// ✅ Forecast Card UI
  Widget _buildForecastCard(String time, String forecast, IconData icon, bool isStorm) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: 140,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isStorm ? Colors.redAccent.withOpacity(0.3) : Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Icon(
                  icon,
                  size: 36,
                  color: isStorm ? Colors.redAccent : Colors.white,
                ),
                const SizedBox(height: 8),
                Text(
                  forecast,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: isStorm ? Colors.redAccent.shade200 : Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// ✅ Overall Weather Summary UI
  Widget _buildWeatherSummary() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: weatherData["summary_forecast"].contains("Thunderstorms") // ⚠️ Highlight Storm
            ? Colors.redAccent.withOpacity(0.2)
            : Colors.blueAccent.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Text(
            "Daily Weather Forecast",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            weatherData["summary_forecast"],
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color:
                  weatherData["summary_forecast"].contains("Thunderstorms") // ⚠️ Storm Alert Color
                      ? Colors.redAccent
                      : Colors.white70,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "📌 Expected in the ${weatherData["summary_when"]}",
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildTemperatureBox("Min", "${weatherData["min_temp"]}°C"),
              _buildTemperatureBox("Max", "${weatherData["max_temp"]}°C"),
            ],
          ),
        ],
      ),
    );
  }

  /// ✅ Min & Max Temperature Box
  Widget _buildTemperatureBox(String label, String temp) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Colors.white70),
        ),
        const SizedBox(height: 5),
        Text(
          temp,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
