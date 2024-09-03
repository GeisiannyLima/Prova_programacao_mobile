import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateInputField extends StatefulWidget {
  @override
  _DateInputFieldState createState() => _DateInputFieldState();
}

class _DateInputFieldState extends State<DateInputField> {
  TextEditingController _controller = TextEditingController();
  DateTime? _selectedDate;
  final DateTime now = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(2000),
      lastDate: now,
      // A localidade é definida automaticamente com base na configuração do dispositivo
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        // Formata a data selecionada para o formato 'DD/MM/AAAA'
        _controller.text = DateFormat('dd/MM/yyyy').format(_selectedDate!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: AbsorbPointer(
        child: TextField(
          controller: _controller,
          decoration: InputDecoration(
            labelText: 'Data da Despesa',
            hintText: 'DD/MM/AAAA',
            border: OutlineInputBorder(),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: IconButton(
              icon: Icon(Icons.calendar_today),
              onPressed: () => _selectDate(context),
            ),
          ),
        ),
      ),
    );
  }
}
