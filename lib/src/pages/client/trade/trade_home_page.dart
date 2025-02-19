import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:micelio/main.dart';
import 'package:micelio/src/pages/client/trade/trade_home_controller.dart';

class TradeHomePage extends StatelessWidget {
  final TradeHomeController con = Get.put(TradeHomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Comercios',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            GetStorage().remove('user');
            Get.offAllNamed('/home-tutorial');
          },
        ),
      ),
      body: Obx(() {
        if (con.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.black,
            ),
          );
        }
        if (con.trades.isEmpty) {
          return Center(
            child: Text('No hay conexión'),
          );
        }
        return ListView.builder(
          itemCount: con.trades.length,
          itemBuilder: (context, index) {
            final trade = con.trades[index];
            return Card(
              margin: EdgeInsets.all(8.0),
              child: ListTile(
                leading: trade.image != null
                    ? Image.network(
                        trade.image!,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      )
                    : Icon(Icons.image_not_supported),
                title: Text(
                  trade.name!,
                  style: TextStyle(color: Colors.black),
                ),
                subtitle: Text(
                  trade.description,
                  style: TextStyle(color: Colors.black),
                ),
                trailing: Icon(
                  trade.isOpen! ? Icons.check_circle : Icons.cancel,
                  color: trade.isOpen! ? Colors.green : Colors.red,
                ),
                onTap: ()  {
                  if (trade.isOpen!) {
                    GetStorage().write('trade', trade);                    
                    con.goToClientPage();
                  } else {
                    null;
                  }
                },
              ),
            );
          },
        );
      }),
    );
  }
}
