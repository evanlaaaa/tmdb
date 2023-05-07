import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:tmdb/constant/string.dart';
import 'package:tmdb/root.dart';
import 'package:tmdb/utils/api_service.dart';
import 'package:tmdb/utils/shared_pref.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  ApiService.initial(baseUrl);
  await SharedPreferencesService.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            scaffoldBackgroundColor: const Color(0xFFf6f5fa),
            primarySwatch: Colors.blue,
          ),
          home: const RootView(),
        );
      }
    );
  }
}