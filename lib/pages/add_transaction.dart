import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/transaction.dart';

class AddTransactionPage extends StatefulWidget {
  const AddTransactionPage({super.key});

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  final TextEditingController _amountController =
      TextEditingController();
  final TextEditingController _titleController =
      TextEditingController();
  final FocusNode _amountFocusNode = FocusNode();

  String selectedCategory = 'Makan';

  final List<Map<String, dynamic>> categories = [
    {'label': 'Makan', 'icon': Icons.restaurant, 'color': Colors.orange},
    {'label': 'Transport', 'icon': Icons.two_wheeler, 'color': Colors.blue},
    {'label': 'Kuliah', 'icon': Icons.school, 'color': Colors.purple},
    {'label': 'Lainnya', 'icon': Icons.more_horiz, 'color': Colors.grey},
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_showAmountKeyboard());
    });
  }

  Future<void> _showAmountKeyboard() async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    if (!mounted) return;

    _amountFocusNode.requestFocus();
    await SystemChannels.textInput.invokeMethod<void>('TextInput.show');
  }

  @override
  void dispose() {
    _amountController.dispose();
    _titleController.dispose();
    _amountFocusNode.dispose();
    super.dispose();
  }

  void _saveExpense() {
    final String note = _titleController.text.trim();
    final int amount = int.tryParse(_amountController.text) ?? 0;

    if (amount > 0 && note.isNotEmpty) {
      final selectedCategoryData = categories.firstWhere(
        (c) => c['label'] == selectedCategory,
      );

      final now = DateTime.now();
      final String currentTime =
          '${now.hour.toString().padLeft(2, '0')}.'
          '${now.minute.toString().padLeft(2, '0')}';

      final newTransaction = TransactionItem(
        title: note,
        time: currentTime,
        amount: amount,
        icon: selectedCategoryData['icon'],
        color: selectedCategoryData['color'],
      );

      Navigator.pop(context, newTransaction);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Tambah Pengeluaran',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Nominal',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            Row(
              children: [
                const Text(
                  'Rp ',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: _amountController,
                    focusNode: _amountFocusNode,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: false,
                      signed: false,
                    ),
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: const InputDecoration(
                      hintText: '0',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 20),

            const Text(
              'Kategori',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: categories.map((cat) {
                final isSelected = selectedCategory == cat['label'];

                return ChoiceChip(
                  showCheckmark: false,
                  avatar: Icon(
                    cat['icon'],
                    color: isSelected ? Colors.white : cat['color'],
                    size: 18,
                  ),
                  label: Text(cat['label']),
                  selected: isSelected,
                  selectedColor: const Color(0xFF3B52C2),
                  backgroundColor: Colors.white,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        selectedCategory = cat['label'];
                      });
                    }
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: TextField(
                controller: _titleController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Catatan',
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 40),

                        SizedBox(
              width: double.infinity,
              child: Material(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side: BorderSide(color: Colors.grey.shade300),
                ),
                clipBehavior: Clip.antiAlias, // penting, biar ripple kepotong sesuai sudut bulat
                child: InkWell(
                  onTap: _saveExpense,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: Text(
                        'Simpan',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}