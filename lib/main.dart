import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final TextEditingController _firstController = TextEditingController();
  final TextEditingController _secondController = TextEditingController();
  String _result = '';
  String? _selectedOperation;

  void _calculate(String operation) {
    final first = double.tryParse(_firstController.text.trim());
    final second = double.tryParse(_secondController.text.trim());

    if (first == null || second == null) {
      _showErrorDialog();
      return;
    }

    double result;
    switch (operation) {
      case '+':
        result = first + second;
        break;
      case '-':
        result = first - second;
        break;
      case '×':
        result = first * second;
        break;
      case '÷':
        if (second == 0) {
          _showErrorDialog('Không thể chia cho 0');
          return;
        }
        result = first / second;
        break;
      default:
        return;
    }

    setState(() {
      _selectedOperation = operation;
      // Format result: show integer if no decimal part, otherwise show 2 decimal places
      if (result == result.toInt()) {
        _result = result.toInt().toString();
      } else {
        _result = result.toStringAsFixed(2);
      }
    });
  }

  void _showErrorDialog([String? message]) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Lỗi'),
        content: Text(message ?? 'Vui lòng nhập số hợp lệ'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _firstController.dispose();
    _secondController.dispose();
    super.dispose();
  }

  Widget _buildOperationButton({
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    final isSelected = _selectedOperation == label;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          border: isSelected ? Border.all(color: Colors.black, width: 3) : null,
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
      ),
      style: const TextStyle(fontSize: 16),
      onChanged: (_) {
        // Reset result when user changes input
        if (_result.isNotEmpty) {
          setState(() {
            _result = '';
            _selectedOperation = null;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Number',
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              const Text(
                'Thực hành 03',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 32),
              // First number input
              _buildTextField(_firstController),
              const SizedBox(height: 20),
              // Operation buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildOperationButton(
                    label: '+',
                    color: const Color(0xFFEF5350),
                    onPressed: () => _calculate('+'),
                  ),
                  const SizedBox(width: 12),
                  _buildOperationButton(
                    label: '-',
                    color: const Color(0xFFFFA726),
                    onPressed: () => _calculate('-'),
                  ),
                  const SizedBox(width: 12),
                  _buildOperationButton(
                    label: '×',
                    color: const Color(0xFFAB47BC),
                    onPressed: () => _calculate('×'),
                  ),
                  const SizedBox(width: 12),
                  _buildOperationButton(
                    label: '÷',
                    color: const Color(0xFF424242),
                    onPressed: () => _calculate('÷'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Second number input
              _buildTextField(_secondController),
              const SizedBox(height: 32),
              // Result display
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  _result.isEmpty ? 'Kết quả:' : 'Kết quả: $_result',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
