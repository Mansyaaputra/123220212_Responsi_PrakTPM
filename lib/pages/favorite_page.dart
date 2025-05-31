import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/phone.dart';
import '../services/api_service.dart';
import 'detail_page.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  final ApiService _apiService = ApiService();
  List<Phone> _favorites = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favIds = prefs.getStringList('favorites') ?? [];
    final allPhones = await _apiService.fetchPhones();
    setState(() {
      _favorites =
          allPhones
              .where((phone) => favIds.contains(phone.id.toString()))
              .toList();
    });
  }

  Future<void> _removeFavorite(int id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Remove Favorite'),
            content: const Text(
              'Are you sure you want to remove this phone from favorites?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Remove'),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      final prefs = await SharedPreferences.getInstance();
      final favIds = prefs.getStringList('favorites') ?? [];
      favIds.remove(id.toString());
      await prefs.setStringList('favorites', favIds);
      _loadFavorites();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Phones'),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(27, 127, 226, 1),
        foregroundColor: Colors.white,
      ),
      body:
          _favorites.isEmpty
              ? const Center(
                child: Text(
                  'No favorite phones yet.',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              )
              : RefreshIndicator(
                onRefresh: _loadFavorites,
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: _favorites.length,
                  itemBuilder: (context, index) {
                    final phone = _favorites[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child:
                              phone.img_url.isNotEmpty
                                  ? Image.network(
                                    phone.img_url,
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                  )
                                  : const Icon(
                                    Icons.phone_android,
                                    size: 60,
                                    color: Colors.grey,
                                  ),
                        ),
                        title: Text(
                          phone.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          'Rp ${phone.price}',
                          style: const TextStyle(color: Color.fromRGBO(27, 127, 226, 1)),
                        ),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.remove_circle,
                            color: Colors.red,
                          ),
                          tooltip: 'Remove from favorites',
                          onPressed: () => _removeFavorite(phone.id),
                        ),
                        onTap:
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailPage(phone: phone),
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
