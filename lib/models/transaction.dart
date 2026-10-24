import 'package:flutter/material.dart';

class TransactionItem {
  final String title;
  final String time;
  final int amount;
  final IconData icon;
  final Color color;

  TransactionItem({
    required this.title,
    required this.time,
    required this.amount,
    required this.icon,
    required this.color,
  });
}