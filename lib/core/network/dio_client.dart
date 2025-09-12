import 'package:dio/dio.dart';

class DioClient {
  DioClient._();
  static final Dio dio = Dio(BaseOptions(
    baseUrl: 'https://jsonplaceholder.typicode.com',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 20),
  ));
}
