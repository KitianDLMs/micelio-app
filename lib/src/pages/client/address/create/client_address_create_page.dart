import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'client_address_create_controller.dart';

class ClientAddressCreatePage extends StatelessWidget {
  final ClientAddressCreateController con =
      Get.put(ClientAddressCreateController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _backgroundCover(context),
          _boxForm(context),
          _textNewAddress(context),
          _iconBack(),
        ],
      ),
    );
  }

  Widget _iconBack() {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(left: 15),
        child: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 30,
          ),
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
      height: MediaQuery.of(context).size.height * 0.55,
      margin: EdgeInsets.only(
        top: MediaQuery.of(context).size.height * 0.3,
        left: 50,
        right: 50,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black54,
            blurRadius: 15,
            offset: Offset(0, 0.75),
          )
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _textYourInfo(),
            _neighborhoodDropdown(),
            _streetDropdown(),
            _numberDropdown(),
            const SizedBox(height: 20),
            _buttonCreate(context),
          ],
        ),
      ),
    );
  }

  Widget _numberDropdown() {
    return Obx(
      () => Container(
        margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
        child: DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: 'Número',
            prefixIcon: Icon(Icons.location_on),
          ),
          value: con.selectedNumero.value.isEmpty
              ? null
              : con.selectedNumero.value,
          items: con.numeros.map<DropdownMenuItem<String>>((numero) {
            return DropdownMenuItem<String>(
              value: '$numero',
              child: Text('$numero'),
            );
          }).toList(),
          onChanged: con.onNumberSelected,
        ),
      ),
    );
  }

  // Widget _textFieldAddress() {
  //   return Container(
  //     margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
  //     child: TextField(
  //       controller: con.addressController,
  //       decoration: const InputDecoration(
  //         labelText: 'Número',
  //         prefixIcon: Icon(Icons.home),
  //       ),
  //     ),
  //   );
  // }

  Widget _neighborhoodDropdown() {
    final ClientAddressCreateController con =
        Get.find<ClientAddressCreateController>();

    return Obx(
      () => Container(
        margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
        child: DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: 'Localidad',
            prefixIcon: Icon(Icons.location_city),
          ),
          value: con.selectedNeighborhood.value.isEmpty
              ? null
              : con.selectedNeighborhood.value,
          items:
              con.neighborhoods.map<DropdownMenuItem<String>>((neighborhood) {
            return DropdownMenuItem<String>(
              value: neighborhood['name'],
              child: Text(neighborhood['name'] ?? ''),
            );
          }).toList(),
          onChanged: con.onNeighborhoodSelected,
        ),
      ),
    );
  }

  // Widget _streetDropdown() {
  //   return Obx(
  //     () => Container(
  //       margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
  //       child: DropdownButtonFormField<String>(
  //         decoration: const InputDecoration(
  //           labelText: 'Calle',
  //           prefixIcon: Icon(Icons.location_on),
  //         ),
  //         value: con.selectedStreet.value.isEmpty
  //             ? null
  //             : con.selectedStreet.value,
  //         items: con.streets.map<DropdownMenuItem<String>>((street) {
  //           return DropdownMenuItem<String>(
  //             value: street,
  //             child: Text(street),
  //           );
  //         }).toList(),
  //         onChanged: (value) {
  //           con.selectedStreet.value = value!;
  //         },
  //       ),
  //     ),
  //   );
  // }

  Widget _streetDropdown() {
    return Obx(
      () => Container(
        margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
        child: DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: 'Calle',
            prefixIcon: Icon(Icons.location_on),
          ),
          value: con.selectedStreet.value.isEmpty
              ? null
              : con.selectedStreet.value,
          items: con.streets.map<DropdownMenuItem<String>>((street) {
            return DropdownMenuItem<String>(
              value: street,
              child: Text(street),
            );
          }).toList(),
          onChanged: con.onStreetSelected,
        ),
      ),
    );
  }

  Widget _buttonCreate(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      child: ElevatedButton(
        onPressed: () {
          con.createAddress();
          print('Barrio: ${con.selectedNeighborhood.value}');
          print('Calle: ${con.selectedStreet.value}');
          print('Numero: ${con.selectedNumero.value}');
          // print('Número: ${con.refPointController.text}');
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 15),
        ),
        child: const Text(
          'CREAR DIRECCIÓN',
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }

  Widget _textNewAddress(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(top: 15),
        alignment: Alignment.topCenter,
        child: const Column(
          children: [
            Icon(Icons.location_on, size: 100),
            Text(
              'NUEVA DIRECCIÓN',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
            ),
          ],
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
        ),
      ),
    );
  }
}
