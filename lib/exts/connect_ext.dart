import 'package:dartkt/dartkt.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';

/// An extension of GetConnect for simplifying network provider implementations.
class GetConnectExt extends GetConnect {
  /// Network interceptors to be used on requests and responses.
  final List<GetConnectInterceptor> _interceptors = List.empty(growable: true);

  GetConnectExt() : super() {
    httpClient.addRequestModifier<dynamic>((request) {
      _interceptors.forEach((element) {
        element.onRequest(request);
      });
      return request;
    });
    httpClient.addResponseModifier((request, response) {
      _interceptors.forEach((element) {
        element.onResponse(request, response);
      });
      return response;
    });
  }

  /// Adds a network interceptor.
  void addInterceptor(GetConnectInterceptor interceptor) {
    _interceptors.add(interceptor);
  }

  /// Removes a network interceptor.
  void removeInterceptor(GetConnectInterceptor interceptor) {
    _interceptors.remove(interceptor);
  }

  /// Fixes query data for lists.
  Map<String, dynamic>? _fixQueries(Map<String, dynamic>? query, [String? commaSeparator]) =>
      query?.map((key, value) => MapEntry(
          key,
          (value is Iterable)
              ? value
                  .map((e) => (e is! String) ? e.toString() : e)
                  .let((obj) => commaSeparator?.let((separator) => obj.join(separator)) ?? obj)
              : ((value is! String) ? value.toString() : value)));

  @override
  Future<Response<T>> get<T>(String url,
          {Map<String, String>? headers,
          String? contentType,
          Map<String, dynamic>? query,
          Decoder<T>? decoder,
          String? querySeparator}) =>
      super.get<T>(url,
          headers: headers, contentType: contentType, query: _fixQueries(query, querySeparator), decoder: decoder);

  @override
  Future<GraphQLResponse<T>> query<T>(String query,
          {String? url, Map<String, dynamic>? variables, Map<String, String>? headers, String? querySeparator}) =>
      super.query<T>(query, url: url, variables: _fixQueries(variables, querySeparator), headers: headers);

  @override
  Future<Response<T>> delete<T>(String url,
          {Map<String, String>? headers,
          String? contentType,
          Map<String, dynamic>? query,
          Decoder<T>? decoder,
          String? querySeparator}) =>
      super.delete<T>(url,
          headers: headers, contentType: contentType, query: _fixQueries(query, querySeparator), decoder: decoder);

  @override
  Future<Response<T>> request<T>(String url, String method,
          {dynamic body,
          String? contentType,
          Map<String, String>? headers,
          Map<String, dynamic>? query,
          Decoder<T>? decoder,
          Progress? uploadProgress,
          String? querySeparator}) =>
      super.request<T>(url, method,
          body: body,
          contentType: contentType,
          headers: headers,
          query: _fixQueries(query, querySeparator),
          decoder: decoder,
          uploadProgress: uploadProgress);

  @override
  Future<Response<T>> patch<T>(String url, dynamic body,
          {String? contentType,
          Map<String, String>? headers,
          Map<String, dynamic>? query,
          Decoder<T>? decoder,
          Progress? uploadProgress,
          String? querySeparator}) =>
      super.patch<T>(url, body,
          contentType: contentType,
          headers: headers,
          query: _fixQueries(query, querySeparator),
          decoder: decoder,
          uploadProgress: uploadProgress);

  @override
  Future<Response<T>> put<T>(String url, dynamic body,
          {String? contentType,
          Map<String, String>? headers,
          Map<String, dynamic>? query,
          Decoder<T>? decoder,
          Progress? uploadProgress,
          String? querySeparator}) =>
      super.put<T>(url, body,
          contentType: contentType,
          headers: headers,
          query: _fixQueries(query, querySeparator),
          decoder: decoder,
          uploadProgress: uploadProgress);

  @override
  Future<Response<T>> post<T>(String? url, dynamic body,
          {String? contentType,
          Map<String, String>? headers,
          Map<String, dynamic>? query,
          Decoder<T>? decoder,
          Progress? uploadProgress,
          String? querySeparator}) =>
      super.post<T>(url, body,
          contentType: contentType,
          headers: headers,
          query: _fixQueries(query, querySeparator),
          decoder: decoder,
          uploadProgress: uploadProgress);
}

abstract class GetConnectInterceptor {
  void onRequest(Request options);

  void onResponse(Request request, Response response);
}

class GetConnectLogInterceptor extends GetConnectInterceptor {
  GetConnect _getConnect;

  GetConnectLogInterceptor({
    required GetConnect getConnect,
    this.request = true,
    this.requestHeader = true,
    this.requestBody = false,
    this.responseHeader = true,
    this.responseBody = false,
    this.error = true,
    this.logPrint = print,
  }) : _getConnect = getConnect;

  /// Print request [Options]
  bool request;

  /// Print request header [Options.headers]
  bool requestHeader;

  /// Print request data [Options.data]
  bool requestBody;

  /// Print [Response.data]
  bool responseBody;

  /// Print [Response.headers]
  bool responseHeader;

  /// Print error message
  bool error;

  /// Log printer; defaults print log to console.
  /// In flutter, you'd better use debugPrint.
  /// you can also write log in a file, for example:
  ///```dart
  ///  var file=File("./log.txt");
  ///  var sink=file.openWrite();
  ///  dio.interceptors.add(LogInterceptor(logPrint: sink.writeln));
  ///  ...
  ///  await sink.close();
  ///```
  void Function(Object object) logPrint;

  @override
  void onRequest(Request options) async {
    logPrint('*** Request ***');
    _printKV('uri', options.url);
    //options.headers;

    if (request) {
      _printKV('method', options.method);
      _printKV('responseType', options.headers.toString());
      _printKV('followRedirects', options.followRedirects);
      _printKV('timeout', _getConnect.timeout);
    }
    if (requestHeader) {
      logPrint('headers:');
      options.headers.forEach((key, v) => _printKV(' $key', v));
    }
    if (requestBody) {
      logPrint('data:');
      _printAll(await options.bodyBytes.bytesToString());
    }
    logPrint('');
  }

  @override
  void onResponse(Request request, Response response) async {
    logPrint('*** Response ***');
    _printResponse(request, response);
  }

  void _printResponse(Request request, Response response) {
    _printKV('uri', request.url);
    if (responseHeader) {
      _printKV('statusCode', response.statusCode);

      logPrint('headers:');
      response.headers?.forEach((key, v) => _printKV(' $key', v /*.join('\r\n\t')*/));
    }
    if (responseBody) {
      logPrint('Response Text:');
      _printAll(response.toString());
    }
    logPrint('');
  }

  void _printKV(String key, Object? v) {
    logPrint('$key: $v');
  }

  void _printAll(msg) {
    msg.toString().split('\n').forEach(logPrint);
  }
}
