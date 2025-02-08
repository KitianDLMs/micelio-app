import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:micelio/src/pages/client/profile/info/client_profile_info_controller.dart';

class ClientProfileInfoPage extends StatefulWidget {
  @override
  State<ClientProfileInfoPage> createState() => _ClientProfileInfoPageState();
}

class _ClientProfileInfoPageState extends State<ClientProfileInfoPage> {
  final ClientProfileInfoController con =
      Get.put(ClientProfileInfoController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF2F2F2),
      body: Obx(
        () => Stack(
          children: [
            // _backgroundCover(),
            _boxForm(context),
            _imageUser(),
            _buttonsStack(),
          ],
        ),
      ),
    );
  }

  Widget _backgroundCover() {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.35,
      color: const Color(0xffFFD700), // Amarillo dorado similar al tutorial.
    );
  }

  Widget _boxForm(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      margin: EdgeInsets.only(
        top: MediaQuery.of(context).size.height * 0.3,
        left: 32,
        right: 32,
      ),
      decoration: BoxDecoration(
        color: Color(0xffF2F2F2),
        borderRadius: BorderRadius.circular(20),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.grey.withOpacity(0.5),
        //     blurRadius: 15,
        //     offset: Offset(0, 4),
        //   ),
        // ],
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Obx(() {
          final user = con.user.value;
          if (user.id == null) {
            return _notLoggedInView();
          } else {
            return _userDetailsView();
          }
        }),
      ),
    );
  }

  Widget _notLoggedInView() {
    return Center(
      child: Column(
        mainAxisSize:
            MainAxisSize.min, // Asegura que solo ocupe el espacio necesario
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.warning, color: Colors.red, size: 40),
          const SizedBox(height: 20),
          const Text(
            'No has iniciado sesión',
            style: TextStyle(fontSize: 18, color: Colors.black54),
            textAlign: TextAlign.center, // Asegura que el texto esté centrado
          ),
          const SizedBox(height: 20),
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
                // Image.asset(
                //   'assets/img/logo_micelio_polera.png',
                //   height: 20,
                // ),
                const SizedBox(width: 10),
                const Text(
                  "  Iniciar sesión",
                  style: TextStyle(color: Colors.white, fontSize: 17),
                ),
              ],
            ),
            onPressed: () {
              Get.offNamedUntil('/home-tutorial', (route) => false);
            },
          ),
        ],
      ),
    );
  }

  Widget _userDetailsView() {
    final user = con.user.value;
    return Column(
      children: [
        _textTile(Icons.person, '${user.name ?? ''} ${user.lastname ?? ''}',
            'Nombre del usuario'),
        _textTile(Icons.email, user.email ?? '', 'Email'),
        _textTile(Icons.phone, user.phone ?? '', 'Teléfono'),
        const SizedBox(height: 16),
        _buttonAction('ACTUALIZAR DATOS', con.goToProfileUpdate),
        const SizedBox(height: 16),
        _buttonAction('ELIMINAR CUENTA', () => con.showAlertDialog(context)),
      ],
    );
  }

  Widget _textTile(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Icon(icon, color: Colors.black54),
      title: Text(title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle,
          style: const TextStyle(fontSize: 14, color: Colors.black45)),
    );
  }

  Widget _buttonAction(String label, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: MaterialButton(
                splashColor: Colors.transparent,
                minWidth: double.infinity,
                height: 40,
                color: const Color.fromARGB(255, 240, 240, 240),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [                   
                    const SizedBox(width: 10),
                    Text(
                      "  $label",
                      style: TextStyle(color: Colors.black, fontSize: 17),
                    ),
                  ],
                ),
                onPressed: onPressed,
              ),
    );
  }

  Widget _buttonsStack() {
    return SafeArea(
      child: Align(
        alignment: Alignment.topRight,
        child: Column(
          children: [
            _iconButton(Icons.exit_to_app, () => con.signOut(context)),
            const SizedBox(height: 10),
            if (con.user.value.id != null)
              _iconButton(Icons.supervised_user_circle, con.goToRoles),
          ],
        ),
      ),
    );
  }

  Widget _iconButton(IconData icon, VoidCallback onPressed) {
    return Container(
      margin: const EdgeInsets.only(right: 16),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.black54, size: 30),
      ),
    );
  }

  Widget _imageUser() {
    final user = con.user.value;
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(top: 25),
        alignment: Alignment.topCenter,
        child: CircleAvatar(
          backgroundImage: user.image != null
              ? NetworkImage(user.image!)
              : const AssetImage('assets/img/user_profile.png')
                  as ImageProvider,
          radius: 50,
          backgroundColor: Colors.white,
        ),
      ),
    );
  }
}
