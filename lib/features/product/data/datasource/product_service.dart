import 'package:dio/dio.dart';
import '../models/product_model.dart';
import '../../../../core/constants/app_constants.dart';

class ProductService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  ProductService() {
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (log) => print(log),
    ));
  }

  Future<List<Product>> getProducts() async {
    try {
      final response = await _dio.get(AppConstants.productsEndpoint);
      final List data = response.data;
      return data.map((e) => Product.fromJson(e)).toList();
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception('Koneksi timeout, coba lagi');
      } else if (e.response != null) {
        throw Exception('Server error: ${e.response?.statusCode}');
      } else {
        throw Exception('Tidak ada koneksi internet');
      }
    } catch (e) {
      throw Exception('Gagal mengambil data produk');
    }
  }
}
