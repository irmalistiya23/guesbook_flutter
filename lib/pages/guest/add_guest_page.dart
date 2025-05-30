import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddGuestPage extends StatefulWidget {
  const AddGuestPage({super.key});

  @override
  State<AddGuestPage> createState() => _AddGuestPageState();
}

class _AddGuestPageState extends State<AddGuestPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController messageCtrl = TextEditingController();
  bool isSaving = false;

  Future<void> saveGuest() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isSaving = true);

    final url = Uri.parse('http://127.0.0.1:8000/api/guests');
    final body = json.encode({
      'name': nameCtrl.text,
      'message': messageCtrl.text,
      'user_id': 1,
    });

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: body,
      );

      setState(() => isSaving = false);

      if (response.statusCode == 201 || response.statusCode == 200) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tamu berhasil disimpan')),
        );
        Navigator.pop(context, true);
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan tamu. Status: ${response.statusCode}')),
        );
      }
    } catch (e) {
      setState(() => isSaving = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saat menyimpan: $e')),
      );
    }
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    messageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(' Add Guest'),
        backgroundColor: const Color(0xFFff6f91),
        foregroundColor: Colors.white,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFfbd3e9), // pink pastel
              Color(0xFFbbded6), // biru pastel
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: nameCtrl,
                      decoration: InputDecoration(
                        labelText: 'Nama',
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.8),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      validator: (value) =>
                          (value == null || value.isEmpty) ? 'Nama wajib diisi' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: messageCtrl,
                      maxLines: 4,
                      decoration: InputDecoration(
                        labelText: 'Pesan',
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.8),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      validator: (value) =>
                          (value == null || value.isEmpty) ? 'Pesan wajib diisi' : null,
                    ),
                    const SizedBox(height: 24),
                    isSaving
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                            onPressed: saveGuest,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFff6f91),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Save',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
