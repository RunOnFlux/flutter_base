import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_base/auth/auth_bloc.dart';
import 'package:http/http.dart' as http;

enum RequestType { get, post, put, patch, del, download }

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

abstract class Api {
  final _dio = _createDio();

  static Api? instance;

  String get backend;

  static Dio _createDio() {
    var dio = Dio(
      BaseOptions(
        sendTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );

    dio.interceptors.addAll({
      Logging(dio),
    });

    return dio;
  }

  Future<dynamic> apiCallHttp(
    RequestType requestType,
    String url, {
    String? backendOverride,
    Map<String, String>? headers,
    bool simpleRequest = false,
  }) async {
    late http.Response? result;
    var client = http.Client();
    var backendImpl = backendOverride ?? backend;
    try {
      switch (requestType) {
        case RequestType.get:
          {
            var requestHeaders = simpleRequest ? {...simpleHeaders} : {...header};
            if (headers != null) {
              headers.forEach((key, value) {
                requestHeaders[key] = value;
              });
            }
            if (kIsWeb) {
              if (backendImpl.startsWith('http://')) {
                backendImpl = 'https://corsanywhere.app.runonflux.io/$backendImpl';
              }
            }
            result = await client.get(
              Uri.parse('$backendImpl$url'),
              headers: requestHeaders,
            );
            break;
          }
        case RequestType.post:
          // TODO: Handle this case.
          break;
        case RequestType.put:
          // TODO: Handle this case.
          break;
        case RequestType.patch:
          // TODO: Handle this case.
          break;
        case RequestType.del:
          // TODO: Handle this case.
          break;
        case RequestType.download:
        // TODO: Handle this case.
      }
      //debugPrint(result!.body);
      return result!.body;
    } catch (error, stackTrace) {
      debugPrint(error.toString());
      debugPrint(stackTrace.toString());
      throw ApiException(message: error.toString());
    }
  }

  Future<dynamic> apiCall(
    RequestType requestType,
    String url, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    dynamic body,
    String? backendOverride,
    bool simpleRequest = false,
    ProgressCallback? onReceiveProgress,
    ProgressCallback? onSendProgress,
  }) async {
    late Response? result;
    var backendImpl = backendOverride ?? backend;
    try {
      switch (requestType) {
        case RequestType.get:
          {
            var headers = simpleRequest ? {...simpleHeaders} : {...header};
            if (options != null && options.headers != null) {
              options.headers!.forEach((key, value) {
                headers[key] = value;
              });
            }
            Options dioOptions = Options(headers: headers, sendTimeout: const Duration(seconds: 1));
            if (kIsWeb) {
              if (backendImpl.startsWith('http://')) {
                backendImpl = 'https://corsanywhere.app.runonflux.io/$backendImpl';
              }
            }
            result = await _dio.get(
              '$backendImpl$url',
              queryParameters: queryParameters,
              options: dioOptions,
              onReceiveProgress: onReceiveProgress,
            );
            break;
          }
        case RequestType.download:
          {
            Map<String, String> headers = {};
            if (options != null && options.headers != null) {
              options.headers!.forEach((key, value) {
                headers[key] = value;
              });
            }
            Options dioOptions =
                Options(headers: headers, sendTimeout: const Duration(seconds: 1), responseType: ResponseType.bytes);
            result = await _dio.get(
              '$backendImpl$url',
              queryParameters: queryParameters,
              options: dioOptions,
              onReceiveProgress: onReceiveProgress,
            );
            debugPrint(result.data.runtimeType.toString());
            break;
          }
        case RequestType.post:
          {
            //debugPrint('post $backendImpl$url ${body.toString()}');
            var headers = simpleRequest ? {...simpleHeaders} : {...header};
            if (options != null && options.headers != null) {
              options.headers!.forEach((key, value) {
                headers[key] = value;
              });
            }
            Options dioOptions = Options(
                headers: headers,
                receiveTimeout: const Duration(seconds: 15),
                sendTimeout: const Duration(seconds: 3600));
            if (options != null) {
              dioOptions.contentType = options.contentType;
              dioOptions.responseType = options.responseType;
            }
            result =
                await _dio.post('$backendImpl$url', data: body, options: dioOptions, onSendProgress: onSendProgress);
            break;
          }
        case RequestType.del:
          {
            Options options = Options(headers: header, sendTimeout: const Duration(seconds: 1));
            result = await _dio.delete('$backendImpl$url', data: queryParameters, options: options);
            break;
          }
        case RequestType.put:
          break;
        case RequestType.patch:
          break;
      }
      //debugPrint('done');
      //debugPrint(result.toString());
      if (result != null) {
        return result.data;
      } else {
        throw ApiException(message: "Data is null");
      }
    } on DioException catch (error) {
      debugPrint(error.message);
      debugPrint(error.stackTrace.toString());
      throw ApiException(message: error.message);
    } catch (error, stackTrace) {
      debugPrint(error.toString());
      debugPrint(stackTrace.toString());
      throw ApiException(message: error.toString());
    }
  }

  Map<String, String> get header => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        //'client-id': 'FluxCloud',
        //'package-name': 'io.runonflux.fluxcloud',
        //'platform': PlatformInfo().getCurrentPlatformType().toString(),
      };

  final Map<String, String> simpleHeaders = {
    'Content-type': 'text/plain',
  };
}

class ApiException {
  int? code;
  String? name;
  String? message;

  ApiException({
    this.code,
    this.name,
    this.message,
  });

  @override
  String toString() {
    return message ?? 'No error message';
  }
}

class Logging extends Interceptor {
  final Dio dio;
  Logging(this.dio);
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    debugPrint('REQUEST[${options.method}] => PATH: ${options.path}');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint(
      'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
    );
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    debugPrint(
      'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}',
    );
    super.onError(err, handler);
  }
}

class ApiUtils {
  static int stringToInt(String s) => int.parse(s);
  static int maybeStringToInt(dynamic s) => (s is int) ? s : int.parse(s);
  static double stringToDouble(String s) => double.parse(s);
  static List<int> listStringsToInts(List<dynamic> s) {
    return s.map((e) {
      if (e is int) return e;
      return int.parse(e);
    }).toList();
  }

  static List<String> listIntsToString(List<int> s) => s.map((e) => e.toString()).toList();

  static String mapToString(Map m) => m.toString();
  static String listToString(List l) => l.toString();

  static DateTime intToDateTime(int int) => DateTime.fromMillisecondsSinceEpoch(int);
  static int dateTimeToInt(DateTime time) => time.millisecondsSinceEpoch;

  static DateTime stringToDateTime(String string) => DateTime.parse(string);
  static DateTime stringMillisToDateTime(String string) => DateTime.fromMillisecondsSinceEpoch(int.parse(string));

  static PrivilegeLevel? stringToPrivilegeLevel(String p) => PrivilegeLevel.fromString(p);
}
