import 'package:flutter/material.dart';

import './category.dart';
import 'dart:math' as math;

class CategoryTotalAmount {
  Category? category;
  int? numberOfTransactions;
  double? income;
  double? expense;
  double? totalAmount;
  final Color? color =
      Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
  CategoryTotalAmount({
    this.category,
    this.numberOfTransactions,
    this.income,
    this.expense,
    this.totalAmount,
  });

  CategoryTotalAmount copyWith({
    Category? category,
    int? numberOfTransactions,
    double? income,
    double? expense,
    double? totalAmount,
  }) {
    return CategoryTotalAmount(
      category: category ?? this.category,
      numberOfTransactions: numberOfTransactions ?? this.numberOfTransactions,
      income: income ?? this.income,
      expense: expense ?? this.expense,
      totalAmount: totalAmount ?? this.totalAmount,
    );
  }
}
