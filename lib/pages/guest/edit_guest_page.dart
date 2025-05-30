import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:guestbook_flutter/utils/shared_preferences.dart';

class EditGuestPage extends StatefulWidget {
  final Map<String, dynamic> guest;
  const EditGuestPage({super.key, required this.guest});

  @override
  State<EditGuestPage> createState() => _EditGuestPageState();
}

class _EditGuestPageState extends State<EditGuestPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameCtrl;
  late TextEditingController messageCtrl;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController(text: widget.guest['name']);
    messageCtrl = TextEditingController(text: widget.guest['message']);
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    messageCtrl.dispose();
    super.dispose();
  }

  Future<void> saveGuest() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isSaving = true);

    final id = widget.guest['id'];
    final url = Uri.parse('http://127.0.0.1:8000/api/guests/$id');
    final token = await SharedPrefs.getToken();

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'name': nameCtrl.text,
          'message': messageCtrl.text,
        }),
      );

      setState(() => isSaving = false);

      if (response.statusCode == 200) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tamu berhasil diperbarui')),
        );
        Navigator.pop(context, true);
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memperbarui tamu. Status: ${response.statusCode}')),
        );
      }
    } catch (e) {
      setState(() => isSaving = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Guest'),
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
