import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:micelio/src/models/product.dart';
import 'package:micelio/src/pages/client/orders/detail/client_orders_detail_controller.dart';
import 'package:micelio/src/utils/relative_time_util.dart';
import 'package:micelio/src/widgets/no_data_widget.dart';
import 'package:flutter/services.dart';

class ClientOrdersDetailPage extends StatelessWidget {
  ClientOrdersDetailController con = Get.put(ClientOrdersDetailController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          bottomNavigationBar: Container(
            color: Color.fromRGBO(245, 245, 245, 1),
            height: con.order.status == 'ENCAMINO'
                ? MediaQuery.of(context).size.height * 0.4
                : MediaQuery.of(context).size.height * 0.35,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _dataDate(),
                  _dataDelivery(context),
                  _dataAddress(),
                  _dataUser(),
                  _totalToPay(context),
                ],
              ),
            ),
          ),
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.black),
            title: Text(
              'Pedido ${con.order.id}',
              style: TextStyle(color: Colors.black),
            ),
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

  Widget _dataDelivery(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
        title: Text('Repartidor y Teléfono',
            style: TextStyle(color: Colors.black)),
        subtitle: GestureDetector(
          onTap: () {
            final phone = con.order.delivery?.phone ?? '###';
            if (phone != '###') {
              // Solo copiar si hay un número válido
              Clipboard.setData(ClipboardData(text: phone));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Número copiado: $phone')),
              );
            }
          },
          child: Text(
            '${con.order.delivery?.name ?? 'No Asignado'} ${con.order.delivery?.lastname ?? ''} - ${con.order.delivery?.phone ?? '###'}',
            style: TextStyle(
                color: Colors.blue, decoration: TextDecoration.underline),
          ),
        ),
        trailing: Icon(Icons.person),
      ),
    );
  }

  Widget _dataAddress() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
        title:
            Text('Direccion de entrega', style: TextStyle(color: Colors.black)),
        subtitle: Text(
            '${con.order.address?.neighborhood ?? ''} ${con.order.address?.address ?? ''} ${con.order.address?.number ?? ''}',
            style: TextStyle(color: Colors.black)),
        trailing: Icon(Icons.location_on),
      ),
    );
  }

  Widget _dataUser() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
        title:
            Text('Cliente', style: TextStyle(color: Colors.black)),
        subtitle: Text(
            '${con.order.user!.name ?? ''} ${con.order.user!.lastname ?? ''}',
            style: TextStyle(color: Colors.black)),
        trailing: Icon(Icons.location_on),
      ),
    );
  }

  Widget _dataDate() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
        title: Text(
          'Fecha del pedido',
          style: TextStyle(color: Colors.black),
        ),
        subtitle: Text(
            '${RelativeTimeUtil.getRelativeTime(con.order.timestamp ?? 0)}',
            style: TextStyle(color: Colors.black)),
        trailing: Icon(Icons.timer),
      ),
    );
  }

  Widget _cardProduct(Product product) {
    double totalProducto = (product.price ?? 0) * (product.quantity ?? 1);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 7),
      child: Row(
        children: [
          _imageProduct(product),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name ?? '',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
                SizedBox(height: 7),
                Text(
                  'Cantidad: ${product.quantity}',
                  style: TextStyle(color: Colors.black, fontSize: 13),
                ),
                SizedBox(height: 7),
                Text(
                  'Precio unitario: \$${product.price?.toStringAsFixed(2) ?? '0.00'}',
                  style: TextStyle(color: Colors.black, fontSize: 13),
                ),
                SizedBox(height: 7),
                Text(
                  'Total: \$${totalProducto.toStringAsFixed(2)}',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _imageProduct(Product product) {
    return Container(
      height: 50,
      width: 50,
      // padding: EdgeInsets.all(2),
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
    double totalOrder = con.total.value;
    double deliveryPrice = con.order.deliveryPrice ?? 0.0;
    double totalWithDelivery = totalOrder + deliveryPrice;

    return Column(
      children: [
        Divider(height: 1, color: Colors.grey[300]),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: Column(
            children: [
              // Subtotal
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Subtotal:',
                      style: TextStyle(fontSize: 16, color: Colors.black)),
                  Text('\$${totalOrder.toStringAsFixed(2)}',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                ],
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Costo de entrega:',
                      style: TextStyle(fontSize: 16, color: Colors.black)),
                  Text('\$${deliveryPrice.toStringAsFixed(2)}',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                ],
              ),
              SizedBox(height: 10),
              Divider(height: 1, color: Colors.grey[400]),
              SizedBox(height: 10),
              // Total
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('TOTAL:',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  Text('\$${totalWithDelivery.toStringAsFixed(2)}',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[700])),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}
