import 'package:flutter/material.dart';

class DynamicFormField extends StatefulWidget {
  final String name;
  final String label;
  final String type;
  final bool required;
  final dynamic value;
  final ValueChanged<dynamic>? onChanged;
  final String? Function(String?)? validator;

  const DynamicFormField({
    Key? key,
    required this.name,
    required this.label,
    required this.type,
    this.required = false,
    this.value,
    this.onChanged,
    this.validator,
  }) : super(key: key);

  @override
  State<DynamicFormField> createState() => _DynamicFormFieldState();
}

class _DynamicFormFieldState extends State<DynamicFormField> {
  late TextEditingController _controller;
  DateTime? _selectedDate;
  Time? _selectedTime;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    if (widget.value != null) {
      _controller.text = widget.value.toString();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.type) {
      case 'text':
        return _buildTextFormField();
      case 'number':
        return _buildNumberFormField();
      case 'email':
        return _buildEmailFormField();
      case 'url':
        return _buildUrlFormField();
      case 'date':
        return _buildDateFormField();
      case 'textarea':
        return _buildTextAreaFormField();
      case 'list':
        return _buildListFormField();
      default:
        return _buildTextFormField();
    }
  }

  Widget _buildTextFormField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: _controller,
        decoration: InputDecoration(
          labelText: widget.label + (widget.required ? ' *' : ''),
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        validator: widget.required
            ? (value) {
                if (value == null || value.isEmpty) {
                  return 'This field is required';
                }
                return null;
              }
            : widget.validator,
        onChanged: (value) {
          widget.onChanged?.call(value);
        },
      ),
    );
  }

  Widget _buildNumberFormField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: _controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: widget.label + (widget.required ? ' *' : ''),
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        validator: (value) {
          if (widget.required && (value == null || value.isEmpty)) {
            return 'This field is required';
          }
          if (value != null && value.isNotEmpty) {
            final number = double.tryParse(value);
            if (number == null) {
              return 'Please enter a valid number';
            }
          }
          return null;
        },
        onChanged: (value) {
          if (value.isEmpty) {
            widget.onChanged?.call(null);
          } else {
            final number = double.tryParse(value);
            widget.onChanged?.call(number);
          }
        },
      ),
    );
  }

  Widget _buildEmailFormField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: _controller,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          labelText: widget.label + (widget.required ? ' *' : ''),
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        validator: (value) {
          if (widget.required && (value == null || value.isEmpty)) {
            return 'This field is required';
          }
          if (value != null && value.isNotEmpty) {
            final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
            if (!emailRegex.hasMatch(value)) {
              return 'Please enter a valid email';
            }
          }
          return null;
        },
        onChanged: (value) {
          widget.onChanged?.call(value);
        },
      ),
    );
  }

  Widget _buildUrlFormField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: _controller,
        keyboardType: TextInputType.url,
        decoration: InputDecoration(
          labelText: widget.label + (widget.required ? ' *' : ''),
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        validator: (value) {
          if (widget.required && (value == null || value.isEmpty)) {
            return 'This field is required';
          }
          if (value != null && value.isNotEmpty) {
            final urlRegex = RegExp(
              r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)',
            );
            if (!urlRegex.hasMatch(value)) {
              return 'Please enter a valid URL';
            }
          }
          return null;
        },
        onChanged: (value) {
          widget.onChanged?.call(value);
        },
      ),
    );
  }

  Widget _buildDateFormField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: widget.label + (widget.required ? ' *' : ''),
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _selectedDate != null
                  ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                  : 'Select Date',
              style: TextStyle(
                color: _selectedDate != null ? Colors.black87 : Colors.grey,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.calendar_today),
              onPressed: _selectDate,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextAreaFormField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: _controller,
        maxLines: 4,
        decoration: InputDecoration(
          labelText: widget.label + (widget.required ? ' *' : ''),
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        validator: widget.required
            ? (value) {
                if (value == null || value.isEmpty) {
                  return 'This field is required';
                }
                return null;
              }
            : widget.validator,
        onChanged: (value) {
          widget.onChanged?.call(value);
        },
      ),
    );
  }

  Widget _buildListFormField() {
    // For list fields, we'll create a text field where user can enter comma-separated values
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: _controller,
        decoration: InputDecoration(
          labelText: widget.label + (widget.required ? ' *' : ''),
          hintText: 'Enter items separated by commas',
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        validator: widget.required
            ? (value) {
                if (value == null || value.isEmpty) {
                  return 'This field is required';
                }
                return null;
              }
            : widget.validator,
        onChanged: (value) {
          // Convert comma-separated string to list
          if (value != null && value.isNotEmpty) {
            final list = value.split(',').map((item) => item.trim()).toList();
            widget.onChanged?.call(list);
          } else {
            widget.onChanged?.call([]);
          }
        },
      ),
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _controller.text = '${picked.day}/${picked.month}/${picked.year}';
        widget.onChanged?.call(_selectedDate);
      });
    }
  }
}