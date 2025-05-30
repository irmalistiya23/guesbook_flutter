import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GuestDetailPage extends StatefulWidget {
  final Map<String, dynamic> guest;

  const GuestDetailPage({super.key, required this.guest});

  @override
  State<GuestDetailPage> createState() => _GuestDetailPageState();
}

class _GuestDetailPageState extends State<GuestDetailPage> {
  bool isDeleting = false;

  Future<void> deleteGuest() async {
    setState(() {
      isDeleting = true;
    });

    final id = widget.guest['id'];
    final url = Uri.parse('http://127.0.0.1:8000/api/guests/$id');

    final response = await http.delete(url);

    setState(() {
      isDeleting = false;
    });

    if (response.statusCode == 200 || response.statusCode == 204) {
      if (mounted) {
        Navigator.pop(context, true);
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menghapus guest. Status: ${response.statusCode}')),
        );
      }
    }
  }

  void navigateToEdit() {
    Navigator.pushNamed(context, '/edit_guest', arguments: widget.guest);
  }

  @override
  Widget build(BuildContext context) {
    final guest = widget.guest;

    return Container(
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
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: const Color(0xFFff6f91), // pink cerah
          foregroundColor: Colors.white,
          title: Text(
            guest['name'] ?? 'Detail Guest',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: navigateToEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: isDeleting
                  ? null
                  : () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Konfirmasi Hapus'),
                          content: const Text('Apakah kamu yakin ingin menghapus tamu ini?'),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
                            TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Hapus')),
                          ],
                        ),
                      );
                      if (confirm == true) {
                        await deleteGuest();
                      }
                    },
            ),
          ],
        ),
        body: isDeleting
            ? const Center(child: CircularProgressIndicator(color: Colors.white))
            : SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 400),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Email:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        guest['email'] ?? '-',
                        style: const TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Message:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        guest['message'] ?? '-',
                        style: const TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
