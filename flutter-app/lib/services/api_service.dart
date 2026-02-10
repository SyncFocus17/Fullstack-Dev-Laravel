import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category.dart';

class ApiService {
  // 10.0.2.2 is localhost in Android emulator
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  /// GET - Haal alle categorieën op
  Future<List<Category>> getCategories() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/categories'),
        headers: {'Accept': 'application/json'},
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Category.fromJson(json)).toList();
      } else {
        throw Exception('Fout bij ophalen: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Verbinding mislukt: $e');
    }
  }

  /// POST - Maak nieuwe categorie
  Future<Category> createCategory(String name, String icon) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/categories'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'name': name,
          'icon': icon,
        }),
      );
      
      if (response.statusCode == 201 || response.statusCode == 200) {
        return Category.fromJson(json.decode(response.body));
      } else {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Fout bij aanmaken');
      }
    } catch (e) {
      throw Exception('Aanmaken mislukt: $e');
    }
  }

  /// DELETE - Verwijder categorie
  Future<void> deleteCategory(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/categories/$id'),
        headers: {'Accept': 'application/json'},
      );
      
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Fout bij verwijderen: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Verwijderen mislukt: $e');
    }
  }
}
