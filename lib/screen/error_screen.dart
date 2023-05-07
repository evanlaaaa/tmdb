import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:tmdb/constant/color.dart';

class ErrorScreen extends StatelessWidget {
  final Future<void> Function()? onRefresh;

  const ErrorScreen({super.key, this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await onRefresh?.call();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: 100.0.h,
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.signal_wifi_connected_no_internet_4_outlined),
                Text("Please check your connection", style: TextStyle(color: secondaryLabel))
              ],
            ),
          ),
        ),
      ),
    );
  }
}