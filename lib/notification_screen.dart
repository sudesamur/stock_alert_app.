import 'package:flutter/material.dart';
import 'package:stock_alert_application/services/api_service.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: FutureBuilder<List<dynamic>>(
        future: Future.wait([
          ApiService.getTrackedProducts(userId: 'user1'),
          ApiService.getProducts(),
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Hata: ${snapshot.error}'));
          }

          final tracked = snapshot.data![0] as List<dynamic>;
          final products = snapshot.data![1] as List<dynamic>;

          // productId -> product map
          final Map<String, dynamic> byId = {
            for (final p in products)
              (p['productId'] ?? '').toString(): p,
          };

          if (tracked.isEmpty) {
            return const Center(child: Text('No tracked products'));
          }

          return RefreshIndicator(
            onRefresh: () async {
              setState(() {});
            },
            child: ListView.builder(
              itemCount: tracked.length,
              itemBuilder: (context, index) {
                final t = tracked[index] as Map<String, dynamic>;
                final productId = (t['productId'] ?? '').toString();
                final p = byId[productId];

                final name = (p?['name'] ?? productId).toString();
                final price = (p?['price'] ?? '-').toString();
                final imageUrl = (p?['imageUrl'] ?? '').toString();

                return ListTile(
                  leading: imageUrl.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.network(
                            imageUrl,
                            width: 52,
                            height: 52,
                            fit: BoxFit.cover,
                          ),
                        )
                      : const Icon(Icons.image_not_supported),
                  title: Text(name),
                  subtitle: Text('Price: $price'),
                  trailing: const Text(
                    'Stock updated',
                    style: TextStyle(
                      color: Color.fromARGB(255, 59, 37, 115),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
