import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Data dummy pengguna
  String name = 'John Doe';
  String email = 'john.doe@example.com';
  String bio = 'Flutter Developer | Coffee Lover';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Bagian header: avatar, nama, email, bio
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey[300],
                  child: const Icon(Icons.person, size: 60, color: Colors.grey),
                ),
                const SizedBox(height: 10),
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  email,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Text(
                  bio,
                  style: const TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                // Tombol Edit Profile
                ElevatedButton.icon(
                  onPressed: () {
                    // Arahkan ke halaman edit profil (belum diimplementasikan)
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Fitur edit profil')),
                    );
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit Profil'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 40),
          // Menu-menu pengaturan
          _buildMenuItem(
            icon: Icons.settings,
            title: 'Pengaturan',
            onTap: () {
              // Arahkan ke halaman pengaturan
            },
          ),
          _buildMenuItem(
            icon: Icons.help,
            title: 'Bantuan & Dukungan',
            onTap: () {
              // Arahkan ke halaman bantuan
            },
          ),
          _buildMenuItem(
            icon: Icons.logout,
            title: 'Keluar',
            onTap: _showLogoutDialog,
            isDestructive: true,
          ),
        ],
      ),
    );
  }

  // Widget untuk menu item
  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(icon, color: isDestructive ? Colors.red : null),
      title: Text(
        title,
        style: TextStyle(color: isDestructive ? Colors.red : null),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  // Dialog konfirmasi logout
  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Keluar'),
        content: const Text('Apakah Anda yakin ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              // Logika logout (misal hapus session, navigasi ke login)
              Navigator.pop(context);
              // Navigator.pushReplacementNamed(context, '/login');
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Logout berhasil')));
            },
            child: const Text('Keluar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
