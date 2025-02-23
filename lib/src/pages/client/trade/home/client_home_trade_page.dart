import 'package:get_storage/get_storage.dart';
import 'package:micelio/src/models/category.dart';
import 'package:micelio/src/models/product.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:micelio/src/pages/client/trade/home/client_home_trade_controller.dart';


class ClientHomeTradePage extends StatelessWidget {
  ClientHomeTradeController con = Get.put(ClientHomeTradeController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (con.isLoading.value) {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(
              color: Colors.black,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
            ),
          ),
        );
      }

      if (con.trade.value == null) {
        return Scaffold(
          body: Center(child: Text('No se pudo cargar el trade')),
        );
      }

      String imageUrl = con.trade.value!.image ?? '';

      return Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(0),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              imageUrl.isNotEmpty
                  ? Image.network(imageUrl,
                      fit: BoxFit.cover, width: double.infinity)
                  : Container(
                      height: 200,
                      color: Colors.grey[300],
                      child: Center(
                          child:
                              Icon(Icons.image, size: 50, color: Colors.white)),
                    ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          con.isOpen.value ? 'Abierto' : 'Cerrado',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),                        
                        Switch(
                          value: con.isOpen.value,
                          activeColor: con.isOpen.value ? Colors.green : Colors.red,
                          inactiveThumbColor: con.isOpen.value ? Colors.green : Colors.red,
                          onChanged: null,
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      '${con.trade.value!.name}',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Descripción: ${con.trade.value!.description}',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Dirección: ${con.trade.value!.address}',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Abre:',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      con.trade.value!.openingHours ?? 'No disponible',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Cierra:',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    Text(
                      con.trade.value!.closingHours ?? 'No disponible',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
