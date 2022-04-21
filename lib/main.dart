import 'package:flutter/material.dart';
import 'package:login/apiService/apiService.dart';
import 'apodList.dart';
import 'home.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: MyHome());
  }
}

void main() => runApp(const MyApp());

class MyHome extends StatefulWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    userController.text = "cf18edwing.montero";
    passwordController.text = "123456";

    var title = 'App M7 de Edwing';
    return MaterialApp(
      title: title,
      home: Scaffold(
          appBar: AppBar(
            title: const Text("Prueba de Edwing Montero"),
            backgroundColor: Colors.pink[600],
          ),
          backgroundColor: const Color(0xfffff9ec),
          body: SingleChildScrollView(
            child: Stack(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: 250,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[Colors.cyan, Colors.red],
                    ),
                  ),
                  child: Image.asset('assets/images/fondo.png'),
                ),
                Padding(
                    padding: const EdgeInsets.fromLTRB(20, 150, 20, 20),
                    child: Card(
                        child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          TextFormField(
                            decoration:
                                const InputDecoration(labelText: "Usuari"),
                            controller: userController,
                          ),
                          TextFormField(
                            obscureText: true,
                            decoration:
                                const InputDecoration(labelText: "Contrasenya"),
                            controller: passwordController,
                          ),
                          SizedBox(
                              child: RaisedButton(
                            color: Colors.blue,
                            onPressed: () {
                              login(userController.text,
                                  passwordController.text, context);
                            },
                            child: const Text(
                              "Sign in",
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Raleway',
                                fontSize: 22.0,
                              ),
                            ),
                          ))
                        ],
                      ),
                    )))
              ],
            ),
          )),
    );
  }
}

Future<void> login(String user, String password, BuildContext context) async {
  var login = await ApiService().login(user, password);
  if (login) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Home()),
    );
  }
}
