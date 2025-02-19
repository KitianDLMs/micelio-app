import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:micelio/src/pages/register/register_controller.dart';
import 'package:micelio/src/widgets/boton_azul.dart';
import 'package:micelio/src/widgets/custom_input.dart';
import 'package:micelio/src/widgets/labels.dart';
import 'package:micelio/src/widgets/logo.dart';
import 'package:url_launcher/url_launcher.dart';

class RegisterPage extends StatelessWidget {
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
      backgroundColor: Color(0xffF2F2F2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Get.offAllNamed('/login');
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            // padding: EdgeInsets.symmetric(vertical: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Logo(
                  titulo: 'Registro',
                ),
                _Form(),
                Labels(
                  ruta: 'login',
                  titulo: '¿Ya tienes una cuenta?',
                  subTitulo: 'Ingresa ahora!',
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

class _Form extends StatefulWidget {
  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form> {
  final RegisterController con = Get.put(RegisterController());
  final nameCtrl = TextEditingController();
  final lastnameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final confirmPassCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 40),
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: <Widget>[
          _buildTextField(
            obscureText: false,
            onSuffixPressed: null,
            suffixIcon: null,
            controller: con.nameController,
            icon: Icons.perm_identity,
            hintText: ' Nombre',
            isPassword: false,
          ),
          SizedBox(
            height: 10,
          ),
          _buildTextField(
            obscureText: false,
            onSuffixPressed: null,
            suffixIcon: null,
            controller: con.lastnameController,
            icon: Icons.person_outline,
            hintText: ' Apellido',
            isPassword: false,
          ),
          SizedBox(
            height: 10,
          ),
          _buildTextField(
            obscureText: false,
            onSuffixPressed: null,
            suffixIcon: null,
            controller: con.emailController,
            icon: Icons.mail_outline,
            hintText: ' Correo',
            isPassword: false,
          ),
          SizedBox(
            height: 10,
          ),
          _buildTextField(
            obscureText: false,
            onSuffixPressed: null,
            suffixIcon: null,
            controller: con.phoneController,
            icon: Icons.phone,
            hintText: ' Teléfono',
            isPassword: false,
          ),
          SizedBox(
            height: 10,
          ),
          Obx(() => _buildTextField(
  controller: con.passwordController,
  icon: Icons.lock_outline,
  hintText: 'Contraseña',
  isPassword: true, // El campo es de contraseña
  obscureText: con.isPasswordHidden.value, // Controlamos la visibilidad con el estado
  onSuffixPressed: () => con.togglePasswordVisibility(),
  suffixIcon: con.isPasswordHidden.value
      ? Icons.visibility_off
      : Icons.visibility, // Cambia el ícono de visibilidad
)),

SizedBox(height: 10,),

Obx(() => _buildTextField(
  controller: con.confirmPasswordController,
  icon: Icons.lock_outline,
  hintText: 'Confirmar Contraseña',
  isPassword: true, // El campo es de confirmación de contraseña
  obscureText: con.isConfirmPasswordHidden.value, // Controlamos la visibilidad con el estado
  onSuffixPressed: () => con.toggleConfirmPasswordVisibility(),
  suffixIcon: con.isConfirmPasswordHidden.value
      ? Icons.visibility_off
      : Icons.visibility, // Cambia el ícono de visibilidad
)),

          SizedBox(
            height: 10,
          ),
          MaterialButton(
            splashColor: Colors.transparent,
            minWidth: double.infinity,
            height: 40,
            color: Colors.blue,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/img/repartidor.png',
                  height: 20,
                ),
                const SizedBox(width: 10),
                const Text(
                  "  Registrar",
                  style: TextStyle(color: Colors.white, fontSize: 17),
                ),
              ],
            ),
            onPressed: () {
              con.register();
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
    required bool obscureText, // Parámetro adicional
    void Function()? onSuffixPressed,
    IconData? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      style: TextStyle(color: Colors.black),
      obscureText: obscureText, // Usamos el parámetro obscureText
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
