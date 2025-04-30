import 'package:flutter/material.dart';

class TransactionsScreen extends StatefulWidget {
  TransactionsScreen({super.key, required this.title});

  final String title;

  @override
  _TransactionsScreenState createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sổ giao dịch')),
      body: Center(child: Text('Chưa có giao dịch nào')),
    );
  }
}
