import 'package:flutter/material.dart';
import 'package:login/detail.dart';

import 'data.dart';
import 'model/apod.dart';
import 'apiService/apiService.dart';

class ApodList extends StatefulWidget {
  const ApodList({Key? key}) : super(key: key);

  @override
  State<ApodList> createState() => _ApodListState();
}

class _ApodListState extends State<ApodList> {
  final ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      body: Center(
        child: FutureBuilder<List<Apod>>(
          future: apiService.getList(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (_, index) => GestureDetector(
                        onTap: (() => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Detail(
                                  title: snapshot.data![index].title,
                                  copyright: snapshot.data![index].copyright,
                                  date: snapshot.data![index].date,
                                  explanation:
                                      snapshot.data![index].explanation,
                                  url: snapshot.data![index].url),
                            ))),
                        child: Container(
                          height: 150,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          padding: const EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color: Colors.black,
                            image: DecorationImage(
                                colorFilter: ColorFilter.mode(
                                    Colors.black.withOpacity(0.5),
                                    BlendMode.dstATop),
                                image: NetworkImage(snapshot.data![index].url),
                                fit: BoxFit.cover),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                snapshot.data![index].title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                snapshot.data![index].date,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ));
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    ));
  }
}
