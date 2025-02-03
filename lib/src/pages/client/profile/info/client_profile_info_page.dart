import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:micelio/src/pages/client/profile/info/client_profile_info_controller.dart';
import 'package:micelio/src/providers/socket_service.dart';
import 'package:provider/provider.dart';

class ClientProfileInfoPage extends StatefulWidget {
  @override
  State<ClientProfileInfoPage> createState() => _ClientProfileInfoPageState();
}

class _ClientProfileInfoPageState extends State<ClientProfileInfoPage> {
  final ClientProfileInfoController con = Get.put(ClientProfileInfoController());

  @override
  void initState() {
    super.initState();        
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => Stack(
          children: [
            _backgroundCover(context),
            _boxForm(context),
            _imageUser(context),
            _buttonsStack(),
          ],
        ),
      ),
    );
  }

  Widget _backgroundCover(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.35,
      color: Colors.amber,
    );
  }

  Widget _boxForm(BuildContext context) {
  return Container(
    height: MediaQuery.of(context).size.height * 0.4,
    margin: EdgeInsets.only(
      top: MediaQuery.of(context).size.height * 0.3,
      left: 50,
      right: 50,
    ),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(30),
      boxShadow: [
        BoxShadow(
          color: Colors.black54,
          blurRadius: 15,
          offset: Offset(0, 0.75),
        ),
      ],
    ),
    child: SingleChildScrollView(
      child: Obx(() {
        final user = con.user.value;
        if (user.id == null) {            
          return _notLoggedInView();
        } else {            
          return _userDetailsView(context);
        }
      }),
    ),
  );
}


  Widget _notLoggedInView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 70),
          Icon(Icons.warning, color: Colors.red, size: 40),
          SizedBox(height: 20),
          Text(
            'No has iniciado sesión',
            style: TextStyle(fontSize: 18, color: Colors.black54),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: con.goToLoginPage,
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            ),
            child: Text('Iniciar Sesión', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  Widget _userDetailsView(BuildContext context) {
  return Obx(() {
    final user = con.user.value;
    return Column(
      children: [
        _textTile(Icons.person, '${user.name ?? ''} ${user.lastname ?? ''}', 'Nombre del usuario'),
        _textTile(Icons.email, user.email ?? '', 'Email'),
        _textTile(Icons.phone, user.phone ?? '', 'Teléfono'),
        _buttonAction(context, 'ACTUALIZAR DATOS', con.goToProfileUpdate),
        _buttonAction(context, 'ELIMINAR CUENTA', () => con.showAlertDialog(context)),
      ],
    );
  });
}


  Widget _textTile(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }

  Widget _buttonAction(BuildContext context, String label, VoidCallback onPressed) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(vertical: 15)),
        child: Text(label, style: TextStyle(color: Colors.black)),
      ),
    );
  }

  Widget _buttonsStack() {
    return SafeArea(
      child: Align(
        alignment: Alignment.topRight,
        child: Column(
          children: [
            // _iconButton(Icons.exit_to_app, con.signOut),
            _iconButton(Icons.exit_to_app, () {
                // final socketService = Provider.of<SocketService>(context, listen: false);  
                // socketService.disconnect();      
                con.signOut(context);
              }
            ),
            SizedBox(height: 10),
            if (con.user.value.id != null)
              _iconButton(Icons.supervised_user_circle, con.goToRoles),
          ],
        ),
      ),
    );
  }

  Widget _iconButton(IconData icon, VoidCallback onPressed) {   
    return Container(
      margin: EdgeInsets.only(right: 20),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white, size: 30),
      ),
    );
  }

  Widget _imageUser(BuildContext context) {
    final user = con.user.value;
    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(top: 25),
        alignment: Alignment.topCenter,
        child: CircleAvatar(
          backgroundImage: user.image != null
              ? NetworkImage(user.image!)
              : const AssetImage('assets/img/user_profile.png') as ImageProvider,
          radius: 60,
          backgroundColor: Colors.white,
        ),
      ),
    );
  }
}
