import 'dart:convert';
import 'package:flutter/material.dart';
import 'add_guest_page.dart';
import 'guest_detail_page.dart';
import 'package:http/http.dart' as http;

class GuestListPage extends StatefulWidget {
  const GuestListPage({super.key});

  @override
  State<GuestListPage> createState() => _GuestListPageState();
}

class _GuestListPageState extends State<GuestListPage> {
  List<Map<String, dynamic>> guests = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchGuests();
  }

  Future<void> fetchGuests() async {
    setState(() => isLoading = true);
    final url = Uri.parse('http://127.0.0.1:8000/api/guests');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        final List<dynamic> data = body['data'];

        setState(() {
          guests = data
              .map<Map<String, dynamic>>((item) => Map<String, dynamic>.from(item))
              .toList();
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengambil data. Status: ${response.statusCode}')),
        );
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $e')),
      );
    }
  }

  Future<void> goToAddGuest() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddGuestPage()),
    );

    if (result == true) {
      fetchGuests();
    }
  }

  Future<void> goToGuestDetail(Map<String, dynamic> guest) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GuestDetailPage(guest: guest),
      ),
    );

    if (result == true) {
      fetchGuests();
    }
  }

  Future<void> confirmLogout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Konfirmasi Logout'),
        content: const Text('Apakah kamu yakin ingin logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
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
          backgroundColor: Color(0xFFff6f91), // pink cerah
          foregroundColor: Colors.white,
          title: const Text('GuestBook'),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: fetchGuests,
            ),
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: 'Logout',
              onPressed: confirmLogout,
            ),
          ],
        ),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Colors.white),
              )
            : guests.isEmpty
                ? const Center(
                    child: Text(
                      'Belum ada data tamu',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    itemCount: guests.length,
                    itemBuilder: (context, index) {
                      final guest = guests[index];
                      return Card(
                        color: Colors.white.withOpacity(0.95),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          title: Text(
                            guest['name'] ?? 'No Name',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Text(
                            guest['message'] ?? 'No Message',
                            style: const TextStyle(fontSize: 14),
                          ),
                          onTap: () => goToGuestDetail(guest),
                        ),
                      );
                    },
                  ),
        floatingActionButton: FloatingActionButton(
          onPressed: goToAddGuest,
          tooltip: 'Tambah Tamu',
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFFff6f91), // pink tua
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
