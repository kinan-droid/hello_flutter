import 'package:flutter/material.dart';

class FieldKataSandi extends StatefulWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool enabled;
  final void Function(String)? onFieldSubmitted;

  const FieldKataSandi({
    super.key,
    required this.controller,
    this.validator,
    this.enabled = true,
    this.onFieldSubmitted,
  });

  @override
  State<FieldKataSandi> createState() => _FieldKataSandiState();
}

class _FieldKataSandiState extends State<FieldKataSandi> {
  bool _terlihat = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: !_terlihat,
      autocorrect: false,
      enableSuggestions: false,
      autofillHints: const [AutofillHints.password],
      enabled: widget.enabled,
      validator: widget.validator,
      onFieldSubmitted: widget.onFieldSubmitted,
      decoration: InputDecoration(
        labelText: 'Kata Sandi',
        hintText: 'Masukkan kata sandi',
        prefixIcon: const Icon(Icons.lock_outline),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        suffixIcon: IconButton(
          tooltip: _terlihat ? 'Sembunyikan kata sandi' : 'Lihat kata sandi',
          onPressed: () {
            setState(() {
              _terlihat = !_terlihat;
            });
          },
          icon: Icon(
            _terlihat ? Icons.visibility_off : Icons.visibility,
          ),
        ),
      ),
    );
  }
}