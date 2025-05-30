import 'package:flutter/material.dart';
import 'package:guestbook_flutter/pages/auth/login_page.dart';
import 'package:guestbook_flutter/pages/guest/guest_list_page.dart';
import 'package:guestbook_flutter/pages/guest/guest_detail_page.dart';
import 'package:guestbook_flutter/pages/guest/edit_guest_page.dart';

void main() {
  runApp(const GuestbookApp());
}

class GuestbookApp extends StatelessWidget {
  const GuestbookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Guestbook App',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
        '/guest_list': (context) => const GuestListPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/guest_detail') {
          final guest = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (_) => GuestDetailPage(guest: guest),
          );
        }
        if (settings.name == '/edit_guest') {
          final guest = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (_) => EditGuestPage(guest: guest),
          );
        }
        // Jika route tidak ditemukan, bisa return null atau halaman error
        return null;
      },
    );
  }
}
