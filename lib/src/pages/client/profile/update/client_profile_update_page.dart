import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:micelio/src/pages/client/profile/update/client_profile_update_controller.dart';

class ClientProfileUpdatePage extends StatelessWidget {
  final ClientProfileUpdateController con = Get.put(ClientProfileUpdateController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffF2F2F2),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      backgroundColor: const Color(0xffF2F2F2), // Fondo uniforme
      body: Stack(
        children: [
          _boxForm(context),
          _imageUser(context),
        ],
      ),
    );
  }

  Widget _boxForm(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.45,
      margin: EdgeInsets.only(
        top: MediaQuery.of(context).size.height * 0.2,
        left: 50,
        right: 50,
      ),
      decoration: BoxDecoration(
        color: Color(0xffF2F2F2),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        // boxShadow: const [
        //   BoxShadow(
        //     color: Colors.black54,
        //     blurRadius: 15,
        //     offset: Offset(0, 0.75),
        //   ),
        // ],
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _textYourInfo(),
            _textFieldName(),
            _textFieldLastName(),
            _textFieldPhone(),
            _buttonUpdate(context),
          ],
        ),
      ),
    );
  }

  Widget _textFieldName() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      child: TextField(
        controller: con.nameController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          hintText: 'Nombre',
          prefixIcon: const Icon(Icons.person),
          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.amber, width: 2),
          ),
        ),
      ),
    );
  }

  Widget _textFieldLastName() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      child: TextField(
        controller: con.lastnameController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          hintText: 'Apellido',
          prefixIcon: const Icon(Icons.person_outline),
          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.amber, width: 2),
          ),
        ),
      ),
    );
  }

  Widget _textFieldPhone() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      child: TextField(
        controller: con.phoneController,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          hintText: 'Teléfono',
          prefixIcon: const Icon(Icons.phone),
          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.amber, width: 2),
          ),
        ),
      ),
    );
  }

  Widget _buttonUpdate(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      child: MaterialButton(
            splashColor: Colors.transparent,
            minWidth: double.infinity,
            height: 40,
            color: Color(0xffF2F2F2),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [                
                const SizedBox(width: 10),
                const Text(
                  "  ACTUALIZAR",
                  style: TextStyle(color: Colors.black, fontSize: 17),
                ),
              ],
            ),
            onPressed: () => con.updateInfo(context),
          ),
    );
  }

  Widget _imageUser(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(top: 10),
        alignment: Alignment.topCenter,
        child: GetBuilder<ClientProfileUpdateController>(
          builder: (value) => CircleAvatar(
            backgroundImage: con.imageFile != null
                ? FileImage(con.imageFile!)
                : con.user.image != null
                    ? NetworkImage(con.user.image!)
                    : const AssetImage('assets/img/user_profile.png')
                        as ImageProvider,
            radius: 60,
            backgroundColor: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _textYourInfo() {
    return Container(
      margin: const EdgeInsets.only(top: 40, bottom: 30),
      child: const Text(
        'INGRESA ESTA INFORMACIÓN',
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
