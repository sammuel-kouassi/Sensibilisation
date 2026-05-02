import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';

import '../core/app_config.dart';

class ImageUploadService {
  static final ImageUploadService _instance = ImageUploadService._internal();
  factory ImageUploadService() => _instance;
  ImageUploadService._internal();

  Future<List<String>> uploadImages(List<String> localPaths) async {
    if (localPaths.isEmpty) return [];

    final uri = Uri.parse(AppConfig.uploadUrl);
    final request = http.MultipartRequest('POST', uri);

    for (final path in localPaths) {
      final file = File(path);
      if (!await file.exists()) {
        debugPrint('⚠️ Fichier introuvable : $path');
        continue;
      }
      request.files.add(await http.MultipartFile.fromPath('files', path));
      debugPrint('📎 Ajout fichier : ${file.path.split('/').last}');
    }

    if (request.files.isEmpty) {
      throw Exception('Aucun fichier valide à uploader');
    }

    debugPrint('📤 Upload de ${request.files.length} image(s) vers ${AppConfig.springBootUrl}...');

    final streamedResponse = await request.send().timeout(
      const Duration(seconds: 60),
      onTimeout: () => throw Exception('Timeout : le serveur ne répond pas'),
    );

    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode != 200) {
      throw Exception('Erreur serveur ${response.statusCode} : ${response.body}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;

    if (json['success'] != true) {
      throw Exception('Upload échoué : ${json['message'] ?? 'erreur inconnue'}');
    }

    final urls = (json['urls'] as List<dynamic>)
        .map((e) => e.toString())
        .toList();

    debugPrint('✅ ${urls.length} image(s) uploadée(s) avec succès');
    for (final url in urls) {
      debugPrint('   → $url');
    }

    return urls;
  }

  String _getMimeType(String path) {
    final ext = path.split('.').last.toLowerCase();
    switch (ext) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'webp':
        return 'image/webp';
      case 'gif':
        return 'image/gif';
      default:
        return 'image/jpeg';
    }
  }
}