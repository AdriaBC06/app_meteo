import 'package:flutter/material.dart';

class LoginOrRegisterScreen extends StatefulWidget {
  const LoginOrRegisterScreen({Key? key}) : super(key: key);

  @override
  _LoginOrRegisterScreenState createState() => _LoginOrRegisterScreenState();
}

class _LoginOrRegisterScreenState extends State<LoginOrRegisterScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;
  final GlobalKey<FormState> _key = GlobalKey();

  bool isLogin = false;
  bool isRegister = false;
  // Empieza con ambos en false, ya se actualizarán al tocar los ToggleButtons.
  List<bool> _selectedEvent = [false, false];

  RegExp emailRegExp =
      RegExp(r'^\w+[\w-\.]*\@\w+((-\w+)|(\w*))\.[a-z]{2,3}$');
  RegExp contRegExp = RegExp(r'^([1-zA-Z0-1@.\s]{1,255})$');
  String? _correu;
  String? _passwd;
  String missatge = '';
  bool _isChecked = false; // (por si lo usas después para “recordar sesión”)

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);

    // "Respiración" del logo
    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });
    controller.forward();
  }

  @override
  void dispose() {
    // Es important SEMPRE realitzar el dispose del controller.
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 200,
                child: AnimatedLogo(animation: animation),
              ),
              if (isLogin || isRegister) loginOrRegisterForm(),
              const SizedBox(height: 100),
              loginOrRegister(),
            ],
          ),
        ),
      ),
    );
  }

  Widget loginOrRegister() {
    return ToggleButtons(
      direction: Axis.horizontal,
      onPressed: (int index) {
        setState(() {
          // El botón seleccionado a true, el resto a false
          for (int i = 0; i < _selectedEvent.length; i++) {
            _selectedEvent[i] = i == index;
          }
          if (index == 0) {
            isLogin = true;
            isRegister = false;
          } else {
            isLogin = false;
            isRegister = true;
          }
        });
      },
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      selectedBorderColor: Colors.blue[800],
      selectedColor: Colors.white,
      fillColor: Colors.blue[200],
      color: Colors.blue[400],
      constraints: const BoxConstraints(
        minHeight: 40.0,
        minWidth: 120.0,
      ),
      isSelected: _selectedEvent,
      children: events,
    );
  }

  Widget loginOrRegisterForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(isLogin ? 'Inicia sessió' : 'Registra\'t'),
        SizedBox(
          width: 300.0,
          child: Form(
            key: _key,
            child: Column(
              children: <Widget>[
                TextFormField(
                  initialValue: '',
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return "Correu es obligatori";
                    } else if (!emailRegExp.hasMatch(text)) {
                      return "Format correu incorrecte";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  maxLength: 50,
                  textAlign: TextAlign.left,
                  decoration: InputDecoration(
                    hintText: 'Escrigui el seu correu',
                    labelText: 'Correu',
                    counterText: '',
                    icon: Icon(Icons.email, size: 32.0, color: Colors.blue[800]),
                  ),
                  onSaved: (text) => _correu = text,
                ),
                TextFormField(
                  initialValue: '',
                  obscureText: true,
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return "Contrasenya és obligatori";
                    } else if (text.length <= 5) {
                      return "Contrasenya mínim de 5 caràcters";
                    } else if (!contRegExp.hasMatch(text)) {
                      return "Contrasenya incorrecte";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.text,
                  maxLength: 20,
                  textAlign: TextAlign.left,
                  decoration: InputDecoration(
                    hintText: 'Escrigui la contrasenya',
                    labelText: 'Contrasenya',
                    counterText: '',
                    icon: Icon(Icons.lock, size: 32.0, color: Colors.blue[800]),
                  ),
                  onSaved: (text) => _passwd = text,
                ),
                IconButton(
                  onPressed: () => _loginRegisterRequest(),
                  icon: Icon(
                    Icons.arrow_forward,
                    size: 42.0,
                    color: Colors.blue[800],
                  ),
                ),
                const SizedBox(height: 8),
                _isLoading ? const CircularProgressIndicator() : Container(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _loginRegisterRequest() async {
    if (_key.currentState!.validate()) {
      _key.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      // Aquí es realitzaria la petició de login a l'API o similar
      missatge = 'Gràcies \n $_correu';
      setState(() {
        _isLoading = false;
      });
      // Navega a la Home ('/') com tens definit en el MaterialApp
      Navigator.of(context).pushReplacementNamed('/', arguments: missatge);
    }
  }
}

class AnimatedLogo extends AnimatedWidget {
  // Maneja los Tween estáticos debido a que estos no cambian.
  static final _opacityTween = Tween<double>(begin: 0.1, end: 1.0);
  static final _sizeTween = Tween<double>(begin: 0.0, end: 100.0);

  const AnimatedLogo({Key? key, required Animation<double> animation})
      : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable as Animation<double>;
    return Opacity(
      opacity: _opacityTween.evaluate(animation),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        height: _sizeTween.evaluate(animation),
        width: _sizeTween.evaluate(animation),
        child: const FlutterLogo(),
      ),
    );
  }
}

const List<Widget> events = <Widget>[
  Text('Inicia sessió'),
  Text('Registra\'t'),
];
