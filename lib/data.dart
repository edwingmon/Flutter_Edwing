import 'package:flutter/material.dart';

import 'apiService/apiService.dart';
import 'detail.dart';
import 'model/apod.dart';

class Data extends StatefulWidget {
  const Data({Key? key}) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<Data> {
  final ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      home: Scaffold(
        body: Center(
          child: FutureBuilder<Apod>(
            future: apiService.getData(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Detail(
                    title: snapshot.data!.title,
                    copyright: snapshot.data!.copyright,
                    date: snapshot.data!.date,
                    explanation: snapshot.data!.explanation,
                    url: snapshot.data!.url);
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
        ),
      ),
    );
  }
}
