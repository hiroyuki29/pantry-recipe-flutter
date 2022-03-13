import 'package:http/http.dart' as http;
import 'dart:convert';

class NetworkHelper {
  NetworkHelper();

  // final String url; https://nasuhiro-pantry-recipe.herokuapp.com/  http://localhost:3000/v1/
  final String apiBaseUrl = 'https://nasuhiro-pantry-recipe.herokuapp.com/v1/';

  Future getData({required String urlInput, required Map<String, String> headerInput}) async {
    var urlAll = Uri.parse('$apiBaseUrl$urlInput');
    http.Response response = await http.get(
      urlAll,
      headers: headerInput,
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> responseResult = {'headers': response.headers, 'body': response.body};
      return responseResult;
    } else {
      print(response.statusCode);
    }
  }

  Future postData({required String urlInput, required Map<String, String> headerInput, required String bodyInput}) async {
    var urlAll = Uri.parse('$apiBaseUrl$urlInput');
    http.Response response = await http.post(
      urlAll,
      headers: headerInput,
      body: bodyInput,
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> responseResult = {'headers': response.headers, 'body': response.body};
      return responseResult;
    } else {
      print(response.statusCode);
    }
  }

  Future putData({required String urlInput, required Map<String, String> headerInput, required String bodyInput}) async {
    var urlAll = Uri.parse('$apiBaseUrl$urlInput');
    http.Response response = await http.put(
      urlAll,
      headers: headerInput,
      body: bodyInput,
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> responseResult = {'headers': response.headers, 'body': response.body};
      return responseResult;
    } else {
      print(response.statusCode);
    }
  }

  Future deleteData({required String urlInput, required Map<String, String> headerInput, required String bodyInput}) async {
    var urlAll = Uri.parse('$apiBaseUrl$urlInput');
    http.Response response = await http.delete(
      urlAll,
      headers: headerInput,
      body: bodyInput,
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> responseResult = {'headers': response.headers, 'body': response.body};
      return responseResult;
    } else {
      print(response.statusCode);
    }
  }
}
