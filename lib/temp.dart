import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:progress_dialog/progress_dialog.dart';


class Activity extends StatefulWidget {
  @override
  _ActivityState createState() => _ActivityState();
}

class _ActivityState extends State<Activity> {
  TextEditingController textEditingController = new TextEditingController();
  var dio_respnse, http_respnse;
  ProgressDialog progressDialog;


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Test App"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            child: Column(
              children: <Widget>[
                // PLease this textfield only 0 and 1 set value
                TextField(
                  keyboardType: TextInputType.number,
                  controller: textEditingController,
                  maxLength: 1,
                  decoration: InputDecoration(labelText: "enter here"),
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                Text("PLease this textfield only 0 and 1 set value"),
                if (textEditingController.text != null)
                  RaisedButton(
                    onPressed: () {
                      _GetpostMethod();
                    },
                    child: Text("Post data hit"),
                  ),
                http_respnse != null
                    ? Text(
                        http_respnse.toString(),
                        style: TextStyle(color: Colors.black),
                      )
                    : Container(),


                SizedBox(
                  height: 20,
                ),
                dio_respnse != null
                    ? Text(
                        dio_respnse.toString(),
                        style: TextStyle(color: Colors.black),
                      )
                    : Container(),
                RaisedButton(
                  onPressed: () {
                    Getfunc();
                    Getdio();
                  },
                  child: Text("Get data hit"),
                ),
                dio_respnse != null
                    ? Text(
                        "PLease Get the api check the response and show the key name (is_subs) is not updated value 0 and 1 . For example "
                        " intput text is 0 (is_sub) is 0 and input text is 1 (is_sub) is 1",
                        style: TextStyle(color: Colors.grey),
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future Getfunc() async {
    // This example uses the Google Books API to search for books about http.
    // https://developers.google.com/books/docs/overview

    // Await the http get response, then decode the json-formatted response.
    //var client = http.Client();
    var url =
        'http://leanports.com/muemue/api/web/events/access?token=npz-LgbT5FLFVxkIwCaafK0IHpLK-ZDw';
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };

    var response = await http.get(url, headers: headers);
    //print(jsonResponse);
    if (response.statusCode == 200) {
      var jsonResponse;
      // setState(() {
      jsonResponse = convert.jsonDecode(response.body);
  setState(() {
    http_respnse = jsonResponse;

  });

      //  });
      print("--http http---" + jsonResponse.toString());
    } else {
      print('-------Request failed with status: ${response.statusCode}.');
    }
  }

  Future Getdio() async {
    _showProgress(context);
    var url =
        'http://leanports.com/muemue/api/web/events/access?token=npz-LgbT5FLFVxkIwCaafK0IHpLK-ZDw';
    var dio = Dio();

//    dio.options.baseUrl = "http://leanports.com/muemue/api/web/events/access?token=poSgUPKJ9W29BDpl4-M3Ra8ASegc-Osp";
    //  dio.interceptors
    //    ..add(CacheInterceptor())
    //  ..add(LogInterceptor(requestHeader: false, responseHeader: false));
    // Response response = await dio.get(url,queryParameters: {"id": 12, "name": "wendu"});
    Response response = await dio.get(url);
    _hideProgress();
    setState(() {
      dio_respnse = response.data;

    });
    print(response.data);
  }

  Future _GetpostMethod() async {
    try {
      _showProgress(context);
      Map jsondata = {"is_sub": textEditingController.text, "event_id": "9"};
      var response = await http.post(
          "http://leanports.com/muemue/api/web/events/subscribe?token=npz-LgbT5FLFVxkIwCaafK0IHpLK-ZDw",
          body: jsondata,
          encoding: Encoding.getByName("utf-8"));
      _hideProgress();
      print("respnse----" + response.body);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data["status"]) {}
      }
    } on Expanded catch (e) {
      print(e.toString());
    }
  }

  _showProgress(BuildContext context) {
    progressDialog = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    progressDialog.style(
        message: "Loading",
        progressWidget: CircularProgressIndicator());
    progressDialog.show();
  }

  _hideProgress() {
    if (progressDialog != null) {
      progressDialog.hide();
    }
  }
}
