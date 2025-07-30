import 'dart:ui';

import 'package:flood_prediction_fyp/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:gif_view/gif_view.dart';
import 'package:intl/intl.dart';

class TodayForecast extends StatelessWidget {
  const TodayForecast({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            width: MediaQuery.sizeOf(context).width - 20,
            // height: MediaQuery.sizeOf(context).height / 3.6,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: .2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// ✅ Date & Weather Icon Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    /// ✅ Location
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Kuala Lumpur',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            SizedBox(width: 10),
                            Assets.image.gps.image(scale: 40, color: Colors.white),
                          ],
                        ),
                        Text.rich(TextSpan(
                          text: 'Today, ',
                          style: const TextStyle(
                              fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500),
                          children: [
                            TextSpan(
                              text: DateFormat('d MMM yy').format(DateTime.now()),
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.white70, fontWeight: FontWeight.w500),
                            ),
                          ],
                        )),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: GifView.asset(
                        Assets.gif.clouds.path,
                        controller: GifController(),
                        height: 50,
                        width: 50,
                        fit: BoxFit.scaleDown,
                        frameRate: 10,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),

                /// ✅ Temperature
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: const TextSpan(
                        text: '30',
                        style: TextStyle(
                            fontSize: 62, fontWeight: FontWeight.bold, color: Colors.white),
                        children: [
                          TextSpan(
                            text: '℃',
                            style: TextStyle(
                                fontSize: 52, fontWeight: FontWeight.bold, color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          height: 120,
                          width: 80,
                          decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                  ),
                                  child: Assets.image.drizzle.image(scale: 15)),
                              SizedBox(height: 10),
                              Text(
                                'Rainfall',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                '10 mm',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.all(8),
                          height: 120,
                          width: 80,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: .2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Assets.image.humidity.image(scale: 15)),
                              SizedBox(height: 10),
                              Text(
                                'Humidity',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                '60%',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
