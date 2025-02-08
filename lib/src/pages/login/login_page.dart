import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:micelio/src/providers/socket_service.dart';
import 'package:micelio/src/widgets/boton_azul.dart';
import 'package:micelio/src/widgets/custom_input.dart';
import 'package:micelio/src/widgets/labels.dart';
import 'package:micelio/src/widgets/logo.dart';
import 'package:micelio/src/pages/login/login_controller.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatelessWidget {
  final LoginController con = Get.put(LoginController());

  final Uri _termsAndConditionsUrl =
      Uri.parse('https://micelio-terms.netlify.app/');

  Future<void> _launchTermsAndConditions() async {
    if (!await launchUrl(_termsAndConditionsUrl)) {
      throw 'No se pudo abrir el enlace $_termsAndConditionsUrl';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF2F2F2),
      appBar: AppBar(
        backgroundColor: const Color(0xffF2F2F2),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Get.offAllNamed('/home-tutorial');
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.8,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Logo(),
                _Form(con: con), // Pasamos el controlador al formulario
                Labels(
                  ruta: 'register',
                  titulo: '¿No tienes cuenta?',
                  subTitulo: 'Crea una ahora!',
                ),
                GestureDetector(
                  onTap: _launchTermsAndConditions,
                  child: const Text(
                    'Términos y condiciones de uso',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Form extends StatelessWidget {
  final LoginController con;

  const _Form({required this.con});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: <Widget>[
          _buildTextField(
            controller: con.emailController,
            icon: Icons.mail_outline,
            hintText: ' Correo',
            isPassword: false,
            onSuffixPressed: null,
            keyboardType: TextInputType.emailAddress,
          ),
          SizedBox(
            height: 10,
          ),
          Obx(() => _buildTextField(
                controller: con.passwordController,
                icon: Icons.lock_outline,
                hintText: ' Contraseña',
                isPassword: true,
                onSuffixPressed: () => con.togglePasswordVisibility(),
                suffixIcon: con.isPasswordHidden.value
                    ? Icons.visibility_off
                    : Icons.visibility,
              )),
          SizedBox(
            height: 10,
          ),
          MaterialButton(
                splashColor: Colors.transparent,
                minWidth: double.infinity,
                height: 40,
                color: Colors.blue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/img/logo_micelio_polera.png',
                      height: 20,
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      "  Iniciar sesión",
                      style: TextStyle(color: Colors.white, fontSize: 17),
                    ),
                  ],
                ),
                onPressed: () {
                  con.login(context);
                },
              ),          
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required IconData icon,
    required String hintText,
    required bool isPassword,
    TextInputType keyboardType = TextInputType.text,
    void Function()? onSuffixPressed,
    IconData? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      style: TextStyle(color: Colors.black),
      obscureText: isPassword ? con.isPasswordHidden.value : false,
      cursorColor: Colors.black,
      decoration: InputDecoration(                
        prefixIcon: Icon(icon),
        suffixIcon: onSuffixPressed != null
            ? IconButton(
                icon: Icon(suffixIcon),
                onPressed: onSuffixPressed,
              )
            : null,
        hintText: hintText,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: Colors.blue,
              width: 2.0), // Borde azul cuando el campo está enfocado
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
      ),
    );
  }
}
