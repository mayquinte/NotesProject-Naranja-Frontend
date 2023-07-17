import 'package:flutter/material.dart';
import '../../../application/DTOS/cmdCreateUser.dart';
import '../../../application/createUserService.dart';
import '../../implementations/repositories/HTTPuserRepository.dart';
import '../../implementations/repositories/localUserRepository.dart';
import '../noteWidgets/home.dart';
import 'widgets.dart';

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inicio de sesión',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Inicio(),
    );
  }
}

class Inicio extends StatefulWidget {
  const Inicio({super.key});

  @override
  State<Inicio> createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  TextEditingController userText = TextEditingController(text: "");
  TextEditingController userPass = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: bodyInicio(), // Se pasa context como parametro
    );
  }

  Widget botonEntrar(
      TextEditingController userText, TextEditingController userPass) {
    //Se agrega el argumento context
    return TextButton(
        style: TextButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            backgroundColor: const Color.fromARGB(255, 30, 103, 240),
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10)),
        onPressed: () {
          iniciar();

          //alerta(context,true,"Wrong Password","The password didnt match");
          ///Envia al usuario a la ventana de inicio
        }, // Funcion para cuando se presione el boton (se debe validar el usuario que va a ingresar para ver sus notas)
        child: const Text(
          "Ingresar",
          style: TextStyle(
              fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),
        ));
  }

  Future<void> iniciar() async {
    var user = await localUserRepository().getUser();
    if (user.isLeft) {
      print(user.left.message);
      var res = await createUserService(
              serverRepo: httpUserRepository(),
              localRepo: localUserRepository())
          .execute(cmdCreateUser(
              nombre: 'userTelefono',
              correo: 'telefono@gmail.com',
              clave: '23041614d',
              fechaNacimiento: DateTime.now()));
      if (res.isLeft) {
        print(res.left.message);
      }
    }

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Home()));
  }

  Widget bodyInicio() {
    return Container(
      height: double.infinity,
      child: Transform.translate(
        //Acomodar la ubicacion inicial
        offset: const Offset(0, 70),
        child: SingleChildScrollView(
          //Evitar el error BottomOverflowed
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              iconApp(120),
              genericSizedBox(30),
              Card(
                shape: RoundedRectangleBorder(
                    side: const BorderSide(
                        color: Color.fromARGB(255, 30, 103, 240), width: 3),
                    borderRadius: BorderRadius.circular(25)),
                color: const Color.fromARGB(255, 255, 255, 255),
                margin: const EdgeInsets.only(left: 20, right: 20),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  child: Column(children: <Widget>[
                    textLabel("Iniciar sesión", 30),
                    genericSizedBox(20),
                    genericTextFormField(userText, "Usuario", false, 20),
                    genericSizedBox(25),
                    genericTextFormField(userPass, "Contraseña", true, 20),
                    genericSizedBox(25),
                    botonEntrar(userText, userPass),
                    genericSizedBox(25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        textLabel("¿No tienes una cuenta?", 15),
                        TextButton(
                            onPressed: () {
                              // Navigator.push(
                              //    context,
                              //    MaterialPageRoute(
                              //     builder: (context) => const Registro()));
                            },
                            child: const Text(
                              "Crear cuenta",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 0, 119, 255),
                                  fontSize: 15),
                            ))
                      ],
                    ),
                  ]),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
