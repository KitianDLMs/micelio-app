import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:micelio/src/models/address.dart';
import 'package:micelio/src/pages/client/address/list/client_address_list_controller.dart';
import 'package:micelio/src/widgets/no_data_widget.dart';
import 'package:get_storage/get_storage.dart';

class ClientAddressListPage extends StatelessWidget {
  ClientAddressListController con = Get.put(ClientAddressListController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: _iconList(),
        ),
      ),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'Mis Direcciones',
          style: TextStyle(color: Colors.black),
        ),
        actions: [_iconAddressCreate()],
      ),
      body: GetBuilder<ClientAddressListController>(
          builder: (value) => Stack(
                children: [_textSelectAddress(), _listAddress(context)],
              )),
    );
  }

  Widget _iconList() {
    return Container(
      margin: EdgeInsets.only(bottom: 30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _iconWithText(Icons.payment, 'MERCADO PAGO', () {
            try {
              con.createOrder(Get.context!);
            } catch (e) {
              print('Error en la solicitud: $e');
            }
          }),
          SizedBox(height: 20),
          _iconWithText(Icons.attach_money, 'POR PAGAR', () {
            try {
              con.createOrder(Get.context!);
            } catch (e) {
              print('Error en la solicitud: $e');
            }
          }),
        ],
      ),
    );
  }

  Widget _buttonNext(BuildContext context) {
    final bag = GetStorage().read('shopping_bag');
    return Container(
        width: double.infinity,
        height: 50,
        margin: EdgeInsets.symmetric(horizontal: 40, vertical: 40),
        child: ElevatedButton(
          onPressed: () async {
            try {
              con.createOrder(context);
            } catch (e) {
              print('Error en la solicitud: $e');
            }
          },
          child: const Text(
            'MERCADO PAGO',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ));
  }

  Widget _buttonNextWithDeli(BuildContext context) {
    final bag = GetStorage().read('shopping_bag');
    return Container(
        width: double.infinity,
        height: 50,
        margin: EdgeInsets.symmetric(horizontal: 40, vertical: 40),
        child: ElevatedButton(
          onPressed: () async {
            try {
              con.createOrder(context);
            } catch (e) {
              print('Error en la solicitud: $e');
            }
          },
          child: const Text(
            'POR PAGAR',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ));
  }

  Widget _iconWithText(IconData icon, String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30), color: Colors.blue[500]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30, color: Colors.black),
            SizedBox(width: 10),
            Text(
              text,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _listAddress(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 50),
      child: FutureBuilder(
          future: con.getAddress(),
          builder: (context, AsyncSnapshot<List<Address>> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.isNotEmpty) {
                return ListView.builder(
                    itemCount: snapshot.data?.length ?? 0,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                    itemBuilder: (_, index) {
                      return _radioSelectorAddress(
                          snapshot.data![index], index);
                    });
              } else {
                return Center(
                  child: NoDataWidget(text: 'No hay direcciones'),
                );
              }
            } else {
              return Center(
                child: NoDataWidget(text: 'No hay direcciones'),
              );
            }
          }),
    );
  }

  Widget _radioSelectorAddress(Address address, int index) {
  // Asigna el precio del delivery dependiendo del barrio
  String deliveryPrice = '';
  if (address.neighborhood == 'Huertos Familiares') {
    deliveryPrice = '+ 1000';
  } else if (address.neighborhood == 'Los Lingues') {
    deliveryPrice = '+ 1500';
  } else if (address.neighborhood == 'Santa Matilde') {
    deliveryPrice = '+ 2000';
  } else if (address.neighborhood == 'Alto el Manzano') {
    deliveryPrice = '+ 2500';
  } else if (address.neighborhood == 'Plazuela') {
    deliveryPrice = '+ 3000';
  } else if (address.neighborhood == 'Polpaico') {
    deliveryPrice = '+ 3500';
  }

  return Container(
    margin: EdgeInsets.symmetric(horizontal: 20),
    child: Column(
      children: [
        Row(
          children: [
            Radio<int>(
              value: index, // El índice único para esta opción
              groupValue: con.radioValue.value, // Valor actual seleccionado
              onChanged: con.handleRadioValueChange, // Maneja los cambios
              activeColor: Colors.blue, // Color cuando está seleccionado
              fillColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.selected)) {
                    return Colors.blue; // Color seleccionado
                  }
                  return Colors.black; // Color cuando no está seleccionado
                },
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${address.address ?? ''} #${address.number ?? ''}',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                Text(
                  '${address.neighborhood ?? ''} $deliveryPrice', // Aquí mostramos el precio del delivery
                  style: TextStyle(fontSize: 12, color: Colors.black),
                )
              ],
            )
          ],
        ),
        Divider(color: Colors.black)
      ],
    ),
  );
}


  Widget _textSelectAddress() {
    return Container(
      margin: EdgeInsets.only(top: 30, left: 30),
      child: Text(
        'Elije donde recibir tu pedido',
        style: TextStyle(
            color: Colors.black, fontSize: 19, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _iconAddressCreate() {
    return IconButton(
        onPressed: () => con.goToAddressCreate(),
        icon: Icon(
          Icons.add,
          color: Colors.black,
        ));
  }
}
