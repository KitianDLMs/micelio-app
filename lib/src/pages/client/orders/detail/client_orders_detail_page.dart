import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:micelio/src/models/product.dart';
import 'package:micelio/src/models/user.dart';
import 'package:micelio/src/pages/client/orders/detail/client_orders_detail_controller.dart';
// import 'package:micelio/src/pages/delivery/orders/detail/delivery_orders_detail_controller.dart';
import 'package:micelio/src/utils/relative_time_util.dart';
import 'package:micelio/src/widgets/no_data_widget.dart';

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
            // padding: EdgeInsets.only(top: 5),
            child: Column(
              children: [
                _dataDate(),
                _dataDelivery(),
                _dataAddress(),
                _totalToPay(context),
              ],
            ),
          ),
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.black),
            title: Text(
              'Order #${con.order.id}',
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

  Widget _dataDelivery() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
        title: Text('Repartidor y Telefono'),
        subtitle: Text(
            '${con.order.delivery?.name ?? 'No Asignado'} ${con.order.delivery?.lastname ?? ''} - ${con.order.delivery?.phone ?? '###'}'),
        trailing: Icon(Icons.person),
      ),
    );
  }

  Widget _dataAddress() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
        title: Text('Direccion de entrega'),
        subtitle: Text(con.order.address?.address ?? ''),
        trailing: Icon(Icons.location_on),
      ),
    );
  }

  Widget _dataDate() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
        title: Text('Fecha del pedido'),
        subtitle: Text(
            '${RelativeTimeUtil.getRelativeTime(con.order.timestamp ?? 0)}'),
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
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 7),
              Text(
                'Cantidad: ${product.quantity}',
                style: TextStyle(
                    // fontWeight: FontWeight.bold
                    fontSize: 13),
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
    return Column(
      children: [
        Divider(height: 1, color: Colors.grey[300]),
        Container(
          margin: EdgeInsets.only(
              left: con.order.status == 'ENCAMINO' ? 30 : 37, top: 15),
          child: Row(
            mainAxisAlignment: con.order.status == 'ENCAMINO'
                ? MainAxisAlignment.center
                : MainAxisAlignment.start,
            children: [
              Text(
                'TOTAL: \$${con.total.value}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
              con.order.status == 'ENCAMINO'
                  ? Container()
                  : Container()
            ],
          ),
        )
      ],
    );
  }

  Widget _buttonGoToOrderMap() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: ElevatedButton(
          onPressed: () => con.goToOrderMap(),
          style: ElevatedButton.styleFrom(
              padding: EdgeInsets.all(15), backgroundColor: Colors.redAccent),
          child: Text(
            'RASTREAR PEDIDO',
            style: TextStyle(color: Colors.white),
          )),
    );
  }
}
