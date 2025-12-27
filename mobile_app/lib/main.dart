import 'package:flutter/material.dart';
import 'screens/delivery_screen.dart';

void main() {
    runApp(const MyApp());
}

class MyApp extends StatelessWidget {
    const MyApp({super.key});

    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            title: 'Last Mile Delivery',
            theme: ThemeData(
                primarySwatch: Colors.blue,
                colorScheme: ColorScheme.fromSeed(
                    seedColor: const Color(0xFF00A8E8), 
                ),
            ),
            home: const DeliveryScreen(),
        );
    }
}

