import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:micelio/src/models/product.dart';
import 'package:micelio/src/models/user.dart';
import 'package:micelio/src/pages/restaurant/orders/detail/restaurant_orders_detail_controller.dart';
import 'package:micelio/src/providers/socket_service.dart';
import 'package:micelio/src/utils/relative_time_util.dart';
import 'package:micelio/src/widgets/no_data_widget.dart';
import 'package:provider/provider.dart';

class RestaurantOrdersDetailPage extends StatelessWidget {
  RestaurantOrdersDetailController con =
      Get.put(RestaurantOrdersDetailController());
  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          bottomNavigationBar: Container(
            color: Color.fromRGBO(245, 245, 245, 1),
            height: con.order.status == 'PAGADO'
                ? MediaQuery.of(context).size.height * 0.50
                : MediaQuery.of(context).size.height * 0.45,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _dataDate(),
                  _dataClient(),
                  _dataAddress(),
                  _dataDelivery(),
                  _totalToPay(context),
                ],
              ),
            ),
          ),
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.black),
            title: Text(
              'Pedido #${con.order.id}',
              style: TextStyle(color: Colors.black),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: GestureDetector(
                  onTap: () {
                    Get.offNamed('/restaurant/orders/print');
                  },
                  child: const Icon(Icons.print),
                ),
              )
            ],
          ),
          body: con.order.products!.isNotEmpty
              ? ListView(
                  children: con.order.products!.map((Product product) {
                    return _cardProduct(product);
                  }).toList(),
                )
              : Center(
                  child: NoDataWidget(
                      text: 'No hay ningun producto agregado aun')),
        ));
  }

  Widget _dataClient() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
        title:
            Text('Cliente y Telefono', style: TextStyle(color: Colors.black)),
        subtitle: Text(
            '${con.order.user?.name ?? ''} ${con.order.user?.lastname ?? ''} - ${con.order.user?.phone ?? ''}',
            style: TextStyle(color: Colors.black)),
        trailing: Icon(Icons.person),
      ),
    );
  }

  Widget _dataDelivery() {
    return con.order.status != 'PAGADO'
        ? Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: ListTile(
              title: Text('Repartidor asignado',
                  style: TextStyle(color: Colors.black)),
              subtitle: Text(
                  '${con.order.delivery?.name ?? ''} ${con.order.delivery?.lastname ?? ''} - ${con.order.delivery?.phone ?? ''}',
                  style: TextStyle(color: Colors.black)),
              trailing: Icon(Icons.delivery_dining),
            ),
          )
        : Container();
  }

  Widget _dataAddress() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
        title:
            Text('Direccion de entrega', style: TextStyle(color: Colors.black)),
        subtitle: Text(
            '${con.order.address?.neighborhood ?? ''} ${con.order.address?.address ?? ''} #${con.order.address?.number ?? ''}',
            style: TextStyle(color: Colors.black)),
        trailing: Icon(Icons.location_on),
      ),
    );
  }

  // Widget _dataClient() {
  //   return Container(
  //     margin: EdgeInsets.symmetric(horizontal: 20),
  //     child: ListTile(
  //       title:
  //           Text('Direccion de entrega', style: TextStyle(color: Colors.black)),
  //       subtitle: Text(
  //           '${con.order.address?.neighborhood ?? ''} ${con.order.address?.address ?? ''} #${con.order.address?.number ?? ''}',
  //           style: TextStyle(color: Colors.black)),
  //       trailing: Icon(Icons.location_on),
  //     ),
  //   );
  // }

  Widget _dataDate() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
        title: Text('Fecha del pedido', style: TextStyle(color: Colors.black)),
        subtitle: Text(
            RelativeTimeUtil.getRelativeTime(con.order.timestamp ?? 0),
            style: TextStyle(color: Colors.black)),
        trailing: Icon(Icons.timer),
      ),
    );
  }

  Widget _cardProduct(Product product) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 7),
      child: Row(
        children: [
          _imageProduct(product),
          SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.name ?? '',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
              SizedBox(height: 7),
              Text(
                'Cantidad: ${product.quantity}',
                style: TextStyle(color: Colors.black, fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _imageProduct(Product product) {
    return Container(
      height: 50,
      width: 50,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: FadeInImage(
          image: product.image1 != null
              ? NetworkImage(product.image1!)
              : AssetImage('assets/img/no-image.png') as ImageProvider,
          fit: BoxFit.cover,
          fadeInDuration: Duration(milliseconds: 50),
          placeholder: AssetImage('assets/img/no-image.png'),
        ),
      ),
    );
  }

  Widget _totalToPay(BuildContext context) {
    double shippingCost = con.order.deliveryPrice ?? 0.0;

    return Column(
      children: [
        Divider(height: 1, color: Colors.grey[300]),
        con.order.status == 'PAGADO'
            ? Container(
                width: double.infinity,
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(left: 30, top: 10),
                child: Text(
                  'ASIGNAR REPARTIDOR',
                  style: TextStyle(
                      fontStyle: FontStyle.italic, color: Colors.amber),
                ),
              )
            : Container(),
        con.order.status == 'PAGADO'
            ? _dropDownDeliveryMen(con.users)
            : Container(),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPriceRow('Subtotal:', con.total.value, Colors.black),
              _buildPriceRow('Costo de envío:', shippingCost, Colors.black),
              Divider(height: 1, color: Colors.grey[300]),
              _buildPriceRow(
                'TOTAL:',
                con.total.value + shippingCost,
                Colors.black,
                isBold: true,
                fontSize: 17,
              ),
            ],
          ),
        ),
        con.order.status == 'PAGADO'
            ? Container(
                margin: EdgeInsets.symmetric(horizontal: 30),
                child: ElevatedButton(
                  onPressed: () {
                    con.updateOrder(context);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(15),
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'DESPACHAR PEDIDO',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ))
            : Container()
      ],
    );
  }

  Widget _buildPriceRow(String label, double value, Color color,
      {bool isBold = false, double fontSize = 16}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: color,
          ),
        ),
        Text(
          '\$${value.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _dropDownDeliveryMen(List<User> users) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 35),
      margin: EdgeInsets.only(top: 15),
      child: DropdownButton(
        underline: Container(
          alignment: Alignment.centerRight,
          child: Icon(
            Icons.arrow_drop_down_circle,
            color: Colors.amber,
          ),
        ),
        elevation: 3,
        isExpanded: true,
        hint: Text(
          'Seleccionar repartidor',
          style: TextStyle(fontSize: 15),
        ),
        items: _dropDownItems(users),
        value: con.idDelivery.value == '' ? null : con.idDelivery.value,
        onChanged: (option) {
          con.idDelivery.value = option.toString();
        },
      ),
    );
  }

  List<DropdownMenuItem<String>> _dropDownItems(List<User> users) {
    List<DropdownMenuItem<String>> list = [];
    users.forEach((user) {
      list.add(DropdownMenuItem(
        child: Row(
          children: [
            Container(
              height: 35,
              width: 35,
              child: FadeInImage(
                image: user.image != null
                    ? NetworkImage(user.image!)
                    : AssetImage('assets/img/no-image.png') as ImageProvider,
                fit: BoxFit.cover,
                fadeInDuration: Duration(milliseconds: 50),
                placeholder: AssetImage('assets/img/no-image.png'),
              ),
            ),
            SizedBox(width: 15),
            Text(user.name ?? ''),
          ],
        ),
        value: user.id,
      ));
    });

    return list;
  }
}
