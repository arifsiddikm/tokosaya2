import 'package:dio/dio.dart';
import '../models/cart_model.dart';
import '../../../../core/constants/app_constants.dart';

class CartService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  Future<List<Cart>> getCarts() async {
    try {
      final response = await _dio.get('/carts');
      final List data = response.data;
      return data.map((e) => Cart.fromJson(e)).toList();
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Server error: ${e.response?.statusCode}');
      }
      throw Exception('Tidak ada koneksi internet');
    } catch (e) {
      throw Exception('Gagal mengambil data cart');
    }
  }
}
