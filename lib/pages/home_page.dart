import 'package:flutter/material.dart';
import '../models/phone.dart';
import '../services/api_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiService _apiService = ApiService();
  List<Phone> _phones = [];
  bool _loading = true;

  
  static const Color primaryColor = Color.fromARGB(255, 27, 127, 226);  // Soft Purple
  static const Color accentColor = Color(0xFF00B894);   // Mint Green
  static const Color cardColor = Color(0xFFF8F9FA);     // Light Gray
  static const Color textPrimary = Color(0xFF2D3436);   // Dark Gray
  static const Color textSecondary = Color(0xFF636E72);  // Medium Gray
  static const Color deleteColor = Color(0xFFE17055);   // Coral Red
  static const Color editColor = Color(0xFF74B9FF);     // Sky Blue

  @override
  void initState() {
    super.initState();
    _fetchPhones();
  }

  Future<void> _fetchPhones() async {
    try {
      final phones = await _apiService.fetchPhones();
      setState(() {
        _phones = phones;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      _showSnackBar('Failed to fetch phones: $e', isError: true);
    }
  }

  Future<void> _deletePhone(int id) async {
    try {
      await _apiService.deletePhone(id);
      await _fetchPhones();
      _showSnackBar('Phone deleted successfully', isError: false);
    } catch (e) {
      _showSnackBar('Failed to delete phone: $e', isError: true);
    }
  }

  void _showSnackBar(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? deleteColor : accentColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _goToCreate() {
    Navigator.pushNamed(context, '/create').then((_) => _fetchPhones());
  }

  void _goToFavorite() {
    Navigator.pushNamed(context, '/favorite');
  }

  void _goToDetail(Phone phone) {
    Navigator.pushNamed(
      context,
      '/detail',
      arguments: phone,
    ).then((_) => _fetchPhones());
  }

  void _goToEdit(Phone phone) {
    Navigator.pushNamed(
      context,
      '/edit',
      arguments: phone,
    ).then((_) => _fetchPhones());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F2F6),
      appBar: AppBar(
        title: const Text(
          'All Phone Store',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 22,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(27, 127, 226, 1),
        foregroundColor: Colors.white,
        elevation: 8,
        shadowColor: primaryColor.withOpacity(0.4),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.favorite_rounded, color: Colors.white, size: 20),
              ),
              onPressed: _goToFavorite,
              tooltip: 'Favorites',
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.add_rounded, color: Colors.white, size: 20),
              ),
              onPressed: _goToCreate,
              tooltip: 'Add Phone',
            ),
          ),
        ],
      ),
      body: _loading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: primaryColor,
                    strokeWidth: 3,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Loading phones...',
                    style: TextStyle(
                      color: textSecondary,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          : _phones.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: cardColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.phone_android_rounded,
                          size: 64,
                          color: textSecondary,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'No Phones Available',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Add your first phone to get started',
                        style: TextStyle(
                          fontSize: 16,
                          color: textSecondary,
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _fetchPhones,
                  color: primaryColor,
                  backgroundColor: Colors.white,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _phones.length,
                    itemBuilder: (context, index) {
                      final phone = _phones[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: Card(
                          elevation: 8,
                          shadowColor: Colors.black.withOpacity(0.15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          color: cardColor,
                          child: InkWell(
                            onTap: () => _goToDetail(phone),
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.white,
                                    Colors.white.withOpacity(0.9),
                                  ],
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Hero(
                                    tag: 'phone_${phone.id}',
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.1),
                                            blurRadius: 10,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: phone.img_url.isNotEmpty
                                            ? Image.network(
                                                phone.img_url,
                                                width: 90,
                                                height: 90,
                                                fit: BoxFit.cover,
                                              )
                                            : Container(
                                                width: 90,
                                                height: 90,
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      primaryColor.withOpacity(0.3),
                                                      accentColor.withOpacity(0.3),
                                                    ],
                                                  ),
                                                ),
                                                child: const Icon(
                                                  Icons.phone_android_rounded,
                                                  size: 40,
                                                  color: Colors.white,
                                                ),
                                              ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          phone.name,
                                          style: TextStyle(
                                            fontSize: 19,
                                            fontWeight: FontWeight.w700,
                                            color: textPrimary,
                                            letterSpacing: 0.3,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color.fromARGB(255, 29, 83, 230).withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            phone.brand,
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: const Color.fromARGB(255, 33, 33, 219),
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [accentColor, accentColor.withOpacity(0.8)],
                                            ),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            'Rp ${phone.price}',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: editColor.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.edit_rounded,
                                            color: editColor,
                                            size: 22,
                                          ),
                                          onPressed: () => _goToEdit(phone),
                                          tooltip: 'Edit',
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: deleteColor.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.delete_rounded,
                                            color: deleteColor,
                                            size: 22,
                                          ),
                                          onPressed: () => showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              title: Row(
                                                children: [
                                                  Icon(
                                                    Icons.warning_rounded,
                                                    color: deleteColor,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  const Text('Confirm Delete'),
                                                ],
                                              ),
                                              content: Text(
                                                'Are you sure you want to delete ${phone.name}?',
                                                style: TextStyle(color: textSecondary),
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () => Navigator.pop(context),
                                                  child: Text(
                                                    'Cancel',
                                                    style: TextStyle(color: textSecondary),
                                                  ),
                                                ),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                    _deletePhone(phone.id);
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: deleteColor,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(10),
                                                    ),
                                                  ),
                                                  child: const Text(
                                                    'Delete',
                                                    style: TextStyle(color: Colors.white),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          tooltip: 'Delete',
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}