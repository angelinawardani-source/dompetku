import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/transaction.dart';

class DompetState {
  final int balance;
  final List<TransactionItem> transactions;

  const DompetState({required this.balance, required this.transactions});

  DompetState copyWith({int? balance, List<TransactionItem>? transactions}) {
    return DompetState(
      balance: balance ?? this.balance,
      transactions: transactions ?? this.transactions,
    );
  }
}

class DompetProvider extends Notifier<DompetState> {
  @override
  DompetState build() {
    return DompetState(
      balance: 255000,
      transactions: [
        TransactionItem(
          title: 'Nasi goreng',
          time: '07.30',
          amount: 15000,
          icon: Icons.restaurant,
          color: Colors.orange,
        ),
        TransactionItem(
          title: 'Ojek ke kampus',
          time: '08.10',
          amount: 12000,
          icon: Icons.two_wheeler,
          color: Colors.blue,
        ),
        TransactionItem(
          title: 'Print tugas',
          time: '10.45',
          amount: 3000,
          icon: Icons.school,
          color: Colors.purple,
        ),
        TransactionItem(
          title: 'Es teh',
          time: '12.15',
          amount: 5000,
          icon: Icons.local_cafe,
          color: Colors.amber,
        ),
      ],
    );
  }

  // Tambah pengeluaran baru: masuk paling atas, saldo berkurang
  void addTransaction(TransactionItem item) {
    state = state.copyWith(
      balance: state.balance - item.amount,
      transactions: [item, ...state.transactions],
    );
  }
}

final dompetProvider = NotifierProvider<DompetProvider, DompetState>(
  DompetProvider.new,
);