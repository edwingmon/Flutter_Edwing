import 'dart:io';
import 'package:path_provider/path_provider.dart' as pathProvider;
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'apiService/apiService.dart';
import 'model/apod.dart';

class Detail extends StatefulWidget {
  final String title, copyright, date, explanation, url;

  const Detail(
      {Key? key,
      required this.title,
      required this.copyright,
      required this.date,
      required this.explanation,
      required this.url})
      : super(key: key);

  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  final ApiService apiService = ApiService();
  late final String _url = widget.url;

  getId() async {
    final prefs = await SharedPreferences.getInstance();
    final String? id = prefs.getString('id');
    Apod apod = Apod(
        copyright: widget.copyright,
        date: widget.date,
        explanation: widget.explanation,
        title: widget.title,
        url: widget.url);
    var status = await ApiService().addFavorite(id!, apod);
    if (status) {
      showToast("Agregado correctamente!");
    } else {
      showToast("Ha habido un error en la conexión.");
    }
    print(id);
  }

  var title;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return MaterialApp(
      title: 'Fetch Data Example',
      //theme: ThemeData(scaffoldBackgroundColor: const Color(0xFFFFFFFF)),
      home: Scaffold(
        body: SingleChildScrollView(
          child: Stack(children: <Widget>[
            Container(
              width: double.infinity,
              height: size.height * 0.5,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(widget.url), fit: BoxFit.cover)),
            ),
            Container(
              width: 50,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(100)),
              margin: EdgeInsets.only(
                  top: size.height * 0.3, left: size.width * 0.8),
              child: IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: () async {
                    final uri = Uri.parse(_url);
                    final response = await http.get(uri);
                    final bytes = response.bodyBytes;

                    Directory temp = await pathProvider.getTemporaryDirectory();
                    final path = '${temp.path}/image.jpg';
                    File(path).writeAsBytesSync(bytes);

                    await Share.shareFiles([path],
                        text: "\n" + widget.date + widget.title);
                  }),
            ),
            Container(
              width: 50,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(100)),
              margin: EdgeInsets.only(
                  top: size.height * 0.3, left: size.width * 0.6),
              child: IconButton(
                  icon: const Icon(Icons.favorite),
                  onPressed: () async {
                    getId();
                  }),
            ),
            Container(
                margin: EdgeInsets.only(top: size.height * 0.4),
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50)),
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text(widget.title,
                            textAlign: TextAlign.left,
                            style: const TextStyle(fontSize: 18)),
                        const SizedBox(height: 20),
                        Text(widget.copyright,
                            textAlign: TextAlign.left,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        Text(widget.date, textAlign: TextAlign.left),
                        const SizedBox(height: 20),
                        Text(widget.explanation, textAlign: TextAlign.left),
                      ]),
                ))
          ]),
        ),
      ),
    );
  }
}

showToast(String message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0);
}
