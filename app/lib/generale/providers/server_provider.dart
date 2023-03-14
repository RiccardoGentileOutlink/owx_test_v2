// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:ows_test_v2/generale/models/abstract_model.dart';
import 'package:ows_test_v2/generale/models/response_model.dart';
import 'package:ows_test_v2/utility.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServerProvider extends ChangeNotifier {
  //NOMI API
  bool mostraProgress = false;
  bool mostraProgressPopup = false;

  void setMostraProgress(bool mostraProgress) {
    Future.delayed(Duration.zero).then(
      (value) {
        this.mostraProgress = mostraProgress;
        notifyListeners();
      },
    );
  }

  void setMostraProgressPopup(bool mostraProgressPopup) {
    Future.delayed(Duration.zero).then(
      (value) {
        this.mostraProgressPopup = mostraProgressPopup;
        notifyListeners();
      },
    );
  }

  final Dio _dio = Dio();

  ServerProvider() {
    _dio.options.connectTimeout = const Duration(seconds: 60);
    _dio.options.contentType = Headers.jsonContentType;
    addInterceptors();
    getUrl();
  }

  dynamic requestInterceptor(
      RequestOptions options, RequestInterceptorHandler handler) async {
    String token = Utility.getUtenteProvider().getToken();
    int id_azienda = Utility.getUtenteProvider().azienda == null
        ? 0
        : Utility.getUtenteProvider().azienda!.id_azienda!;

    options.headers.addAll({
      'Authorization': 'Bearer $token',
      'Lingua': 'it',
      'Azienda': id_azienda,
    });

    handler.next(options);
  }

  dynamic responseInterceptor(
      Response response, ResponseInterceptorHandler handler) async {
    if (response.statusCode == HttpStatus.unauthorized) {
      Utility.getUtenteProvider().disconnetti(mostraAlert: true);
    }
    setMostraProgress(false);
    setMostraProgressPopup(false);
    handler.next(response);
  }

  dynamic errorInterceptor(
      DioError error, ErrorInterceptorHandler handler) async {
    if (error.response != null &&
        error.response!.statusCode == HttpStatus.unauthorized) {
      Utility.getUtenteProvider().disconnetti(mostraAlert: true);
    }
    setMostraProgress(false);
    setMostraProgressPopup(false);
    handler.next(error);
  }

  addInterceptors() {
    _dio.interceptors.add(InterceptorsWrapper(
        onRequest: (options, handler) => requestInterceptor(options, handler),
        onResponse: (response, handler) =>
            responseInterceptor(response, handler),
        onError: (dioError, handler) => errorInterceptor(dioError, handler)));
  }

  Future<ResponseModel> getData(
      String funzioneApi, Map<String, dynamic>? parameters,
      {bool mostraProgress = true, bool isPopup = false}) async {
    try {
      if (mostraProgress) {
        if (isPopup) {
          setMostraProgressPopup(true);
        } else {
          setMostraProgress(true);
        }
      }

      Response response =
          await _dio.get(funzioneApi, queryParameters: parameters);
      return ResponseModel(data: response.data == '' ? null : response.data);
    } on DioError catch (err) {
      if (err.response != null && err.response!.data != null) {
        return ResponseModel(errore: err.response!.data.toString());
      } else {
        return ResponseModel(errore: err.message);
      }
    } on Error catch (ex) {
      return ResponseModel(errore: ex.toString());
    } on Exception catch (ex) {
      return ResponseModel(errore: ex.toString());
    }
  }

  Future<ResponseModel> getListData(
      String funzioneApi, Map<String, dynamic>? parameters,
      {bool mostraProgress = true, bool isPopup = false}) async {
    try {
      if (mostraProgress) {
        if (isPopup) {
          setMostraProgressPopup(true);
        } else {
          setMostraProgress(true);
        }
      }

      Response response =
          await _dio.get(funzioneApi, queryParameters: parameters);
      List<Map<String, dynamic>> resultList = <Map<String, dynamic>>[];
      for (var element in response.data) {
        if (element is Map<String, dynamic>) {
          resultList.add(Map.from(element));
        }
        if (element is String) {
          resultList.add({'value': element});
        }
      }

      return ResponseModel(listData: resultList);
    } on DioError catch (err) {
      if (err.response != null && err.response!.data != null) {
        return ResponseModel(errore: err.response!.data.toString());
      } else {
        return ResponseModel(errore: err.message);
      }
    } on Error catch (ex) {
      return ResponseModel(errore: ex.toString());
    } on Exception catch (ex) {
      return ResponseModel(errore: ex.toString());
    }
  }

  Future<ResponseModel> postData(
      String funzioneApi, Map<String, dynamic>? parameters,
      {bool mostraProgress = true, bool isPopup = false}) async {
    try {
      if (mostraProgress) {
        if (isPopup) {
          setMostraProgressPopup(true);
        } else {
          setMostraProgress(true);
        }
      }
      Response response = await _dio.post(funzioneApi, data: parameters);
      if (response.data is Map<String, dynamic>) {
        return ResponseModel(data: response.data);
      }
      if (response.data is List) {
        return ResponseModel(listData: response.data);
      }
      if (response.data is bool) {
        return ResponseModel(resultOk: response.data);
      }
      return ResponseModel();
    } on DioError catch (err) {
      if (err.response != null && err.response!.data != null) {
        return ResponseModel(errore: err.response!.data.toString());
      } else {
        return ResponseModel(errore: err.message);
      }
    } on Error catch (ex) {
      return ResponseModel(errore: ex.toString());
    } on Exception catch (ex) {
      return ResponseModel(errore: ex.toString());
    }
  }

  Future<ResponseModel> postListData(
      String funzioneApi, List<dynamic>? parameters,
      {bool mostraProgress = true, bool isPopup = false}) async {
    try {
      if (mostraProgress) {
        if (isPopup) {
          setMostraProgressPopup(true);
        } else {
          setMostraProgress(true);
        }
      }

      Response response =
          await _dio.post(funzioneApi, data: jsonEncode(parameters));
      if (response.data is List) {
        List<Map<String, dynamic>> resultList = <Map<String, dynamic>>[];
        for (var element in response.data) {
          resultList.add(Map.from(element));
        }
        return ResponseModel(listData: resultList);
      } else {
        return ResponseModel(data: response.data);
      }
    } on DioError catch (err) {
      if (err.response != null && err.response!.data != null) {
        return ResponseModel(errore: err.response!.data.toString());
      } else {
        return ResponseModel(errore: err.message);
      }
    } on Error catch (ex) {
      return ResponseModel(errore: ex.toString());
    } on Exception catch (ex) {
      return ResponseModel(errore: ex.toString());
    }
  }

  Future<ResponseModel> deleteSingolo(
      String funzioneApi, AbstractModel daElimninare,
      {bool mostraProgress = true, bool isPopup = false}) async {
    try {
      if (mostraProgress) {
        if (isPopup) {
          setMostraProgressPopup(true);
        } else {
          setMostraProgress(true);
        }
      }

      Response response =
          await _dio.delete(funzioneApi, data: jsonEncode(daElimninare));
      if (response.data is bool) {
        return ResponseModel(resultOk: response.data);
      } else {
        return ResponseModel(data: response.data);
      }
    } on DioError catch (err) {
      if (err.response != null && err.response!.data != null) {
        return ResponseModel(errore: err.response!.data.toString());
      } else {
        return ResponseModel(errore: err.message);
      }
    } on Error catch (ex) {
      return ResponseModel(errore: ex.toString());
    } on Exception catch (ex) {
      return ResponseModel(errore: ex.toString());
    }
  }

  Future<ResponseModel> delete(
      String funzioneApi, List<AbstractModel> daElimninare,
      {bool mostraProgress = true, bool isPopup = false}) async {
    try {
      if (mostraProgress) {
        if (isPopup) {
          setMostraProgressPopup(true);
        } else {
          setMostraProgress(true);
        }
      }

      Response response =
          await _dio.delete(funzioneApi, data: jsonEncode(daElimninare));
      if (response.data is bool) {
        return ResponseModel(resultOk: response.data);
      } else {
        return ResponseModel(data: response.data);
      }
    } on DioError catch (err) {
      if (err.response != null && err.response!.data != null) {
        return ResponseModel(errore: err.response!.data.toString());
      } else {
        return ResponseModel(errore: err.message);
      }
    } on Error catch (ex) {
      return ResponseModel(errore: ex.toString());
    } on Exception catch (ex) {
      return ResponseModel(errore: ex.toString());
    }
  }

  Future<ResponseModel> downloadFilePost(
      String funzioneApi, Map<String, dynamic>? parameters,
      {bool mostraProgress = true, bool isPopup = false}) async {
    try {
      if (mostraProgress) {
        if (isPopup) {
          setMostraProgressPopup(true);
        } else {
          setMostraProgress(true);
        }
      }

      Response response = await _dio.post(funzioneApi, data: parameters);
      //final Uint8List bytes = await readByteStream((response.data as ResponseBody).stream);
      final Uint8List bytes = base64.decoder.convert(response.data);
      return ResponseModel(bytes: bytes);
    } on DioError catch (err) {
      if (err.response != null && err.response!.data != null) {
        return ResponseModel(errore: err.response!.data.toString());
      } else {
        return ResponseModel(errore: err.message);
      }
    } on Error catch (ex) {
      return ResponseModel(errore: ex.toString());
    } on Exception catch (ex) {
      return ResponseModel(errore: ex.toString());
    }
  }

  Future<String> getUrl() async {
    if (_dio.options.baseUrl != "") {
      return _dio.options.baseUrl;
    } else {
      SharedPreferences pref = await SharedPreferences.getInstance();
      if (pref.containsKey(DatiMemoria.url)) {
        setUrl(pref.getString(DatiMemoria.url)!);
        return _dio.options.baseUrl;
      } else {
        //se sono nel web leggo dal file di configurazione
        if (kIsWeb) {
          String defaultUrl =
              await Utility.getParametroConfigurazione('base_url');
          if (defaultUrl != "") {
            pref.setString(DatiMemoria.url, defaultUrl);
            setUrl(defaultUrl);
            return _dio.options.baseUrl;
          }
        }
        return "";
      }
    }
  }

  void setUrl(String url) {
    _dio.options.baseUrl = "$url/";
  }
}
