import 'package:flutter/material.dart';

import 'datagrid.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Datagrid',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: DataGridExample(),
    );
  }
}


