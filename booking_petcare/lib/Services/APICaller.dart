import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:booking_petcare/Global/GlobalValue.dart';
import 'package:booking_petcare/Services/Auth.dart';
import 'package:booking_petcare/Utils/Utils.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class APICaller {
  static APICaller _apiCaller = APICaller();
  final String BASE_URL = "http://192.168.171.66/api/";

  static APICaller getInstance() {
    if (_apiCaller == null) {
      _apiCaller = APICaller();
    }
    return _apiCaller;
  }

  Future<dynamic> get(String endpoint,
      {Map<String, dynamic>? queryParams}) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': GlobalValue.getInstance().getToken(),
    };

    Uri uri =
        Uri.parse(BASE_URL + endpoint).replace(queryParameters: queryParams);

    try {
      final response = await http.get(uri, headers: requestHeaders).timeout(
            const Duration(seconds: 30),
            onTimeout: () => http.Response(
                jsonEncode({
                  "error": {
                    "code": 408,
                    "message":
                        "Không kết nối được đến máy chủ, bạn vui lòng kiểm tra lại."
                  },
                  "data": []
                }),
                408),
          );

      if (response.statusCode == 401) {
        Auth.backLogin(true);
        Utils.showSnackBar(
            title: 'Thông báo', message: 'Đã hết phiên đăng nhập');
        return null;
      }

      if (response.body.isEmpty) {
        Utils.showSnackBar(title: 'Lỗi', message: 'API trả về dữ liệu rỗng');
        return null;
      }

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (response.statusCode != 200 || responseData["error"]["code"] != 0) {
        Utils.showSnackBar(
          title: 'Thông báo',
          message: responseData["error"]["message"] ?? 'Lỗi không xác định',
        );
        return null;
      }

      return responseData["data"];
    } catch (e) {
      Utils.showSnackBar(
          title: 'Lỗi', message: 'Đã xảy ra lỗi khi gọi API: $e');
      return null;
    }
  }

  Future<dynamic> post(String endpoint, dynamic body) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': GlobalValue.getInstance().getToken(),
    };

    final uri = Uri.parse(BASE_URL + endpoint);

    try {
      final response = await http
          .post(uri, headers: requestHeaders, body: jsonEncode(body))
          .timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          return http.Response(jsonEncode({'error': 'Timeout'}), 408);
        },
      );

      print("🔹 API Response (${response.statusCode}): ${response.body}");

      if (response.statusCode == 408) {
        Utils.showSnackBar(title: 'Lỗi', message: "Mất kết nối đến máy chủ.");
        return null;
      }

      // Kiểm tra JSON hợp lệ
      dynamic responseBody;
      try {
        responseBody = jsonDecode(utf8.decode(response.bodyBytes));
      } catch (e) {
        print('Lỗi khi parse JSON: $e');
        print('Phản hồi từ API: ${response.body}');
        Utils.showSnackBar(
            title: 'Lỗi', message: 'Phản hồi từ máy chủ không hợp lệ.');
        return null;
      }

      if (responseBody == null || responseBody is! Map) {
        print('API trả về không phải JSON hợp lệ.');
        Utils.showSnackBar(
            title: 'Lỗi', message: 'Phản hồi từ máy chủ không hợp lệ.');
        return null;
      }

      if (response.statusCode == 401) {
        Auth.backLogin(true);
        Utils.showSnackBar(
            title: 'Thông báo', message: 'Đã hết phiên đăng nhập');
        return null;
      }

      if (responseBody['success'] == false) {
        Utils.showSnackBar(
            title: 'Thông báo',
            message: responseBody['message'] ?? 'Lỗi không xác định');
        return null;
      }

      return responseBody;
    } catch (e) {
      print('Lỗi khi gọi API: $e');
      Utils.showSnackBar(
          title: 'Thông báo', message: 'Đã xảy ra lỗi khi gọi API.');
      return null;
    }
  }

  Future<dynamic> postFile(
      {required String endpoint,
      required File filePath,
      required String type,
      required String keyCert,
      required String time}) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'multipart/form-data',
      'Authorization': GlobalValue.getInstance().getToken(),
    };
    final uri = Uri.parse(BASE_URL + endpoint);

    final request = http.MultipartRequest('POST', uri);
    request.files
        .add(await http.MultipartFile.fromPath('ImageFiles', filePath.path));
    request.fields['Type'] = type;
    request.fields['keyCert'] = keyCert;
    request.fields['time'] = time;
    request.headers.addAll(requestHeaders);

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse).timeout(
      const Duration(seconds: 30),
      onTimeout: () {
        return http.Response(
            'Không kết nối được đến máy chủ, bạn vui lòng kiểm tra lại.', 408);
      },
    );
    bool code401 = response.statusCode == 401;
    if (code401) {
      Auth.backLogin(code401);
      Utils.showSnackBar(title: 'Thông báo', message: 'Đã hết phiên đăng nhập');
    }
    ;
    if (response.statusCode != 200) {
      // Utils.showSnackBar(
      //     title: TextByNation.getStringByKey('notification'),
      //     message: response.body);
      return null;
    }
    if (jsonDecode(response.body)['error']['code'] != 0) {
      Utils.showSnackBar(
          title: 'Thông báo',
          message: jsonDecode(response.body)['error']['message']);
      return null;
    }
    return jsonDecode(response.body);
  }

  Future<dynamic> postFiles(String endpoint, List<File> filePath) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'multipart/form-data',
      'Authorization': GlobalValue.getInstance().getToken(),
    };
    final uri = Uri.parse(BASE_URL + endpoint);

    final request = http.MultipartRequest('POST', uri);
    List<http.MultipartFile> files = [];
    for (File file in filePath) {
      var f = await http.MultipartFile.fromPath('files', file.path);
      files.add(f);
    }
    request.files.addAll(files);
    request.headers.addAll(requestHeaders);

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse).timeout(
      const Duration(seconds: 30),
      onTimeout: () {
        return http.Response(
            'Không kết nối được đến máy chủ, bạn vui lòng kiểm tra lại.', 408);
      },
    );
    bool code401 = response.statusCode == 401;
    if (code401) {
      Auth.backLogin(code401);
      Utils.showSnackBar(title: 'Thông báo', message: 'Đã hết phiên đăng nhập');
    }
    ;
    if (response.statusCode != 200) {
      // Utils.showSnackBar(
//     title: TextByNation.getStringByKey('notification'),
      //     message: response.body);
      return null;
    }
    if (jsonDecode(response.body)['error']['code'] != 0) {
      Utils.showSnackBar(
          title: 'Thông báo',
          message: jsonDecode(response.body)['error']['message']);
      return null;
    }
    return jsonDecode(response.body);
  }

  Future<dynamic> put(String endpoint, dynamic body) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': GlobalValue.getInstance().getToken(),
    };
    final uri = Uri.parse(BASE_URL + endpoint);

    final response = await http
        .put(uri, headers: requestHeaders, body: jsonEncode(body))
        .timeout(
      const Duration(seconds: 30),
      onTimeout: () {
        return http.Response(
            'Không kết nối được đến máy chủ, bạn vui lòng kiểm tra lại.', 408);
      },
    );
    bool code401 = response.statusCode == 401;
    if (code401) {
      Auth.backLogin(code401);
      Utils.showSnackBar(title: 'Thông báo', message: 'Đã hết phiên đăng nhập');
    }
    ;
    if (response.statusCode != 200) {
      // Utils.showSnackBar(
      //     title: TextByNation.getStringByKey('notification'),
      //     message: response.body);
      return null;
    }
    if (jsonDecode(response.body)['error']['code'] != 0) {
      Utils.showSnackBar(
          title: 'Thông báo',
          message: jsonDecode(response.body)['error']['message']);
      return null;
    }
    return jsonDecode(response.body);
  }

  Future<dynamic> putFile(
      {required String endpoint, required File filePath}) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'multipart/form-data',
      'Authorization': GlobalValue.getInstance().getToken(),
    };
    final uri = Uri.parse(BASE_URL + endpoint);

    final request = http.MultipartRequest('PUT', uri);
    request.files
        .add(await http.MultipartFile.fromPath('FileData', filePath.path));
    request.fields['Type'] = '1';
    request.fields['KeyCert'] = 'string';
    request.fields['Time'] = 'string';
    request.headers.addAll(requestHeaders);

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse).timeout(
      const Duration(seconds: 30),
      onTimeout: () {
        return http.Response(
            'Không kết nối được đến máy chủ, bạn vui lòng kiểm tra lại.', 408);
      },
    );
    bool code401 = response.statusCode == 401;
    if (code401) {
      Auth.backLogin(code401);
      Utils.showSnackBar(title: 'Thông báo', message: 'Đã hết phiên đăng nhập');
    }
    ;
    if (response.statusCode != 200) {
      // Utils.showSnackBar(
      //     title: TextByNation.getStringByKey('notification'),
      //     message: response.body);
      return null;
    }
    if (jsonDecode(response.body)['error']['code'] != 0) {
      Utils.showSnackBar(
          title: 'Thông báo',
          message: jsonDecode(response.body)['error']['message']);
      return null;
    }
    return jsonDecode(response.body);
  }

  Future<dynamic> delete(String endpoint, {dynamic body}) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': GlobalValue.getInstance().getToken(),
    };
    final uri = Uri.parse(BASE_URL + endpoint);

    final response = await http
        .delete(uri, headers: requestHeaders, body: jsonEncode(body))
        .timeout(
      const Duration(seconds: 30),
      onTimeout: () {
        return http.Response(
            'Không kết nối được đến máy chủ, bạn vui lòng kiểm tra lại.', 408);
      },
    );
    bool code401 = response.statusCode == 401;
    if (code401) {
      Auth.backLogin(code401);
      Utils.showSnackBar(title: 'Thông báo', message: 'Đã hết phiên đăng nhập');
    }
    ;
    if (response.statusCode != 200) {
      // Utils.showSnackBar(
      //     title: TextByNation.getStringByKey('notification'),
      //     message: response.body);
      return null;
    }
    if (jsonDecode(response.body)['error']['code'] != 0) {
      Utils.showSnackBar(
          title: 'Thông báo',
          message: jsonDecode(response.body)['error']['message']);
      return null;
    }
    return jsonDecode(response.body);
  }
}
