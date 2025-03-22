import 'package:hive_flutter/hive_flutter.dart';
import 'dart:convert';

class CacheManager {
  static const String _cacheBox = "api_cache";

  /// Save API response with timestamp
  static Future<void> saveCache(String key, dynamic data) async {
    final box = await Hive.openBox(_cacheBox);
    final cacheData = {
      "timestamp": DateTime.now().millisecondsSinceEpoch,
      "data": jsonEncode(data),
    };
    await box.put(key, cacheData);
  }

  /// Get cached data if it's not expired
  static Future<dynamic> getCache(String key, Duration expiryDuration) async {
    final box = await Hive.openBox(_cacheBox);
    if (!box.containsKey(key)) return null;

    final cachedData = box.get(key);
    final int timestamp = cachedData["timestamp"];
    final int currentTime = DateTime.now().millisecondsSinceEpoch;

    if (currentTime - timestamp > expiryDuration.inMilliseconds) {
      await box.delete(key); // Remove expired cache
      return null;
    }

    return jsonDecode(cachedData["data"]);
  }
}
