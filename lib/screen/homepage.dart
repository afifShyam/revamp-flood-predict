import 'dart:ui';

import 'package:flood_prediction_fyp/widget/homepage_widget/index.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomepageScreen extends StatelessWidget {
  const HomepageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF263238), // Color(0xFFF5F5F5),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 50, top: 70),
        physics: const BouncingScrollPhysics(),
        child: Column(
          spacing: 10,
          children: [
            TodayForecast(),
            SizedBox(
              height: 60,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: 7,
                itemBuilder: (context, index) {
                  DateTime currentDate = DateTime.now().add(Duration(days: index));
                  String day = DateFormat('EEE').format(currentDate);
                  String date = DateFormat('d MMM').format(currentDate);

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      children: [
                        Text(
                          day,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: index == 0 ? Colors.blueAccent : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            date,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: index == 0 ? Colors.white : Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            WeatherForecastScroll(),
          ],
        ),
      ),
    );
  }
}
