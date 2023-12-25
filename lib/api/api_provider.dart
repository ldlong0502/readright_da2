import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../configs/configs.dart';

class ApiProvider {
  final Dio _dio = Dio(
      BaseOptions(
        baseUrl: AppConfigs.endpoint,
        responseType: ResponseType.json,
        contentType: 'application/json',
      )
  );
  Future<Response?> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      return await _dio.get(path, queryParameters: queryParameters);
    } catch (error) {
      debugPrint('error $error');
      return null;
    }
  }

  Future<Response?> post(String path, {Map<String, dynamic>? data}) async {
    try {
      debugPrint(data.toString());
      return await _dio.post(path, data: data);
    } catch (error) {
      debugPrint(error.toString());
      return null;
    }
  }

  Future<Response?> delete(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      return await _dio.delete(path, queryParameters: queryParameters);
    } catch (error) {
      return null;
    }
  }

  Future<Response?> update(String path, {Map<String, dynamic>? data}) async {
    try {
      return await _dio.put(path, data: data);
    } catch (error) {
      return null;
    }
  }

  dynamic handleError(error) {
    debugPrint('Error during HTTP request: $error');

  }

}