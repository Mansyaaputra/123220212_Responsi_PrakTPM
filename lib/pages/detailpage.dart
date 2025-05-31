import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/phone.dart';
import '../services/apiservice.dart';
import 'editpage.dart';

class DetailPage extends StatefulWidget {
  final Phone phone;
  const DetailPage({super.key, required this.phone});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final ApiService _apiService = ApiService();
  List<String> _favoriteIds = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _favoriteIds = prefs.getStringList('favorites') ?? [];
    });
  }

  Future<void> _toggleFavorite(int id) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (_favoriteIds.contains(id.toString())) {
        _favoriteIds.remove(id.toString());
      } else {
        _favoriteIds.add(id.toString());
      }
    });
    prefs.setStringList('favorites', _favoriteIds);
  }

  void _deletePhone(int id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Confirm Delete'),
            content: Text(
              'Are you sure you want to delete ${widget.phone.name}?',
            ),
            actions: [
              TextButton(
                child: const Text('Cancel'),
                onPressed: () => Navigator.pop(context, false),
              ),
              TextButton(
                child: const Text('Delete'),
                onPressed: () => Navigator.pop(context, true),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      await _apiService.deletePhone(id);
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final phone = widget.phone;
    final isFavorite = _favoriteIds.contains(phone.id.toString());

    return Scaffold(
      appBar: AppBar(
        title: Text(phone.name),
        backgroundColor: const Color.fromRGBO(27, 127, 226, 1),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.redAccent : Colors.white,
            ),
            tooltip: 'Favorite',
            onPressed: () => _toggleFavorite(phone.id),
          ),
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            tooltip: 'Edit',
            onPressed:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditPage(phone: phone),
                  ),
                ),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.white),
            tooltip: 'Delete',
            onPressed: () => _deletePhone(phone.id),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: double.infinity,
                height: 220,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(16),
                  image:
                      phone.img_url.isNotEmpty
                          ? DecorationImage(
                            image: NetworkImage(phone.img_url),
                            fit: BoxFit.cover,
                          )
                          : null,
                ),
                child:
                    phone.img_url.isEmpty
                        ? const Center(
                          child: Icon(
                            Icons.phone_android,
                            size: 60,
                            color: Colors.grey,
                          ),
                        )
                        : null,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              phone.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              phone.brand,
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Text(
              'Rp ${phone.price}',
              style: const TextStyle(
                fontSize: 22,
                color: Color.fromRGBO(27, 127, 226, 1),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Description',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              phone.specification,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
