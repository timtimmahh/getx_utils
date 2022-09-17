// import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/adapter_browser.dart';
import 'package:dio/dio.dart';

// import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart';

abstract class BaseDioProvider implements Dio {
  @protected
  final Dio _dio = Dio()
    ..options.connectTimeout = 30000
    ..options.receiveTimeout = 30000
    ..options.contentType = Headers.textPlainContentType
    ..options.headers['User-Agent'] = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0';

  BaseDioProvider(/*{CookieJar? cookieJar}*/) {
    if (_dio.httpClientAdapter is BrowserHttpClientAdapter) {
      (_dio.httpClientAdapter as BrowserHttpClientAdapter).withCredentials = true;
    }
    _dio.interceptors.addAll([
      // if (!kIsWeb) CookieManager(cookieJar ?? Get.find<CookieJar>()),
      LogInterceptor(requestBody: true, responseBody: false)
    ]);
    dioConfig();
  }

  void dioConfig();

  @override
  Future<Response<T>> fetch<T>(RequestOptions requestOptions) => _dio.fetch<T>(requestOptions);

  @override
  Future<Response<T>> requestUri<T>(Uri uri,
          {data,
          CancelToken? cancelToken,
          Options? options,
          ProgressCallback? onSendProgress,
          ProgressCallback? onReceiveProgress}) =>
      _dio.requestUri<T>(uri,
          data: data,
          cancelToken: cancelToken,
          options: options,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress);

  @override
  Future<Response<T>> request<T>(String path,
          {data,
          Map<String, dynamic>? queryParameters,
          CancelToken? cancelToken,
          Options? options,
          ProgressCallback? onSendProgress,
          ProgressCallback? onReceiveProgress}) =>
      _dio.request<T>(path,
          data: data,
          queryParameters: queryParameters,
          cancelToken: cancelToken,
          options: options,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress);

  @override
  Future<Response> downloadUri(Uri uri, savePath,
          {ProgressCallback? onReceiveProgress,
          CancelToken? cancelToken,
          bool deleteOnError = true,
          String lengthHeader = Headers.contentLengthHeader,
          data,
          Options? options}) =>
      _dio.downloadUri(uri, savePath,
          onReceiveProgress: onReceiveProgress,
          cancelToken: cancelToken,
          deleteOnError: deleteOnError,
          lengthHeader: lengthHeader,
          data: data,
          options: options);

  @override
  Future<Response> download(String urlPath, savePath,
          {ProgressCallback? onReceiveProgress,
          Map<String, dynamic>? queryParameters,
          CancelToken? cancelToken,
          bool deleteOnError = true,
          String lengthHeader = Headers.contentLengthHeader,
          data,
          Options? options}) =>
      _dio.download(urlPath, savePath,
          onReceiveProgress: onReceiveProgress,
          queryParameters: queryParameters,
          cancelToken: cancelToken,
          deleteOnError: deleteOnError,
          lengthHeader: lengthHeader,
          data: data,
          options: options);

  @override
  void clear() => _dio.clear();

  @override
  void unlock() => _dio.unlock();

  @override
  void lock() => _dio.lock();

  @override
  Future<Response<T>> patchUri<T>(Uri uri,
          {data,
          Options? options,
          CancelToken? cancelToken,
          ProgressCallback? onSendProgress,
          ProgressCallback? onReceiveProgress}) =>
      _dio.patchUri<T>(uri,
          data: data,
          options: options,
          cancelToken: cancelToken,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress);

  @override
  Future<Response<T>> patch<T>(String path,
          {data,
          Map<String, dynamic>? queryParameters,
          Options? options,
          CancelToken? cancelToken,
          ProgressCallback? onSendProgress,
          ProgressCallback? onReceiveProgress}) =>
      _dio.patch<T>(path,
          data: data,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress);

  @override
  Future<Response<T>> deleteUri<T>(Uri uri, {data, Options? options, CancelToken? cancelToken}) =>
      _dio.deleteUri<T>(uri, data: data, options: options, cancelToken: cancelToken);

  @override
  Future<Response<T>> delete<T>(String path,
          {data, Map<String, dynamic>? queryParameters, Options? options, CancelToken? cancelToken}) =>
      _dio.delete<T>(path, data: data, queryParameters: queryParameters, options: options, cancelToken: cancelToken);

  @override
  Future<Response<T>> headUri<T>(Uri uri, {data, Options? options, CancelToken? cancelToken}) =>
      _dio.headUri<T>(uri, data: data, options: options, cancelToken: cancelToken);

  @override
  Future<Response<T>> head<T>(String path,
          {data, Map<String, dynamic>? queryParameters, Options? options, CancelToken? cancelToken}) =>
      _dio.head<T>(path, data: data, queryParameters: queryParameters, options: options, cancelToken: cancelToken);

  @override
  Future<Response<T>> putUri<T>(Uri uri,
          {data,
          Options? options,
          CancelToken? cancelToken,
          ProgressCallback? onSendProgress,
          ProgressCallback? onReceiveProgress}) =>
      _dio.putUri<T>(uri,
          data: data,
          options: options,
          cancelToken: cancelToken,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress);

  @override
  Future<Response<T>> put<T>(String path,
          {data,
          Map<String, dynamic>? queryParameters,
          Options? options,
          CancelToken? cancelToken,
          ProgressCallback? onSendProgress,
          ProgressCallback? onReceiveProgress}) =>
      _dio.put<T>(path,
          data: data,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress);

  @override
  Future<Response<T>> postUri<T>(Uri uri,
          {data,
          Options? options,
          CancelToken? cancelToken,
          ProgressCallback? onSendProgress,
          ProgressCallback? onReceiveProgress}) =>
      _dio.postUri<T>(uri,
          data: data,
          options: options,
          cancelToken: cancelToken,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress);

  @override
  Future<Response<T>> post<T>(String path,
          {data,
          Map<String, dynamic>? queryParameters,
          Options? options,
          CancelToken? cancelToken,
          ProgressCallback? onSendProgress,
          ProgressCallback? onReceiveProgress}) =>
      _dio.post<T>(path,
          data: data,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress);

  @override
  Future<Response<T>> getUri<T>(Uri uri,
          {Options? options, CancelToken? cancelToken, ProgressCallback? onReceiveProgress}) =>
      _dio.getUri<T>(uri, options: options, cancelToken: cancelToken, onReceiveProgress: onReceiveProgress);

  @override
  Future<Response<T>> get<T>(String path,
          {Map<String, dynamic>? queryParameters,
          Options? options,
          CancelToken? cancelToken,
          ProgressCallback? onReceiveProgress}) =>
      _dio.get<T>(path,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
          onReceiveProgress: onReceiveProgress);

  @override
  void close({bool force = false}) => _dio.close(force: force);

  @override
  late Transformer transformer = _dio.transformer;

  @override
  late HttpClientAdapter httpClientAdapter = _dio.httpClientAdapter;

  @override
  Interceptors get interceptors => _dio.interceptors;

  @override
  late BaseOptions options = _dio.options;
}
