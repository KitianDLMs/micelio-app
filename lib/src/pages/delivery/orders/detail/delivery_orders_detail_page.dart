import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:micelio/src/models/product.dart';
import 'package:micelio/src/models/user.dart';
import 'package:micelio/src/pages/delivery/orders/detail/delivery_orders_detail_controller.dart';
import 'package:micelio/src/pages/delivery/orders/list/delivery_orders_list_controller.dart';
import 'package:micelio/src/providers/socket_service.dart';
import 'package:micelio/src/utils/relative_time_util.dart';
import 'package:micelio/src/widgets/no_data_widget.dart';
import 'package:provider/provider.dart';

class DeliveryOrdersDetailPage extends StatefulWidget {

  @override
  State<DeliveryOrdersDetailPage> createState() => _DeliveryOrdersDetailPageState();
}

class _DeliveryOrdersDetailPageState extends State<DeliveryOrdersDetailPage> {
  DeliveryOrdersDetailController con = Get.put(DeliveryOrdersDetailController());
  DeliveryOrdersListController con2 = Get.put(DeliveryOrdersListController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      bottomNavigationBar: Container(
        color: Color.fromRGBO(245, 245, 245, 1),
        height: MediaQuery.of(context).size.height * 0.45,
        child: Column(
          children: [
            _dataDate(),
            _dataClient(),
            _dataAddress(),
            _dataTrade(),
            _totalToPay(context),
          ],
        ),
      ),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'Order #${con.order.clientId}',
          style: TextStyle(
            color: Colors.black
          ),
        ),
      ),
      body: con.order.products!.isNotEmpty
      ? ListView(
        children: con.order.products!.map((Product product) {
          return _cardProduct(product);
        }).toList(),
      )
      : Center(
          child: NoDataWidget(text: 'No hay ningun producto agregado aun')
      ),
    ));
  }

  Widget _dataClient() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
        title: Text('Cliente y Telefono', style: TextStyle(color: Colors.black)),
        subtitle: Text('${con.order.user?.name ?? ''} ${con.order.user?.lastname ?? ''} - ${con.order.user?.phone ?? ''}', style: TextStyle(color: Colors.black)),
        trailing: Icon(Icons.person),
      ),
    );
  }

  Widget _dataAddress() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
        title: Text('Direccion de entrega', style: TextStyle(color: Colors.black)),
        subtitle: Text('${con.order.address?.neighborhood ?? ''} ${con.order.address?.address ?? ''} #${con.order.address!.number ?? ''}', style: TextStyle(color: Colors.black),),
        trailing: Icon(Icons.location_on),
      ),
    );
  }

  Widget _dataDate() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
        title: Text('Fecha del pedido', style: TextStyle(color: Colors.black)),
        subtitle: Text(RelativeTimeUtil.getRelativeTime(con.order.timestamp ?? 0), style: TextStyle(color: Colors.black)),
        trailing: Icon(Icons.timer),
      ),
    );
  }

  Widget _dataTrade() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
        title: Text('Retirar en', style: TextStyle(color: Colors.black)),
        subtitle: Text(con.order.trade!.name!, style: TextStyle(color: Colors.black),),
        trailing: Icon(Icons.task_rounded),
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
                style: TextStyle(
                  color: Colors.black,
                    fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: 7),
              Text(
                'Cantidad: ${product.quantity}',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 13
                ),
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
          placeholder:  AssetImage('assets/img/no-image.png'),
        ),
      ),
    );
  }

  Widget _totalToPay(BuildContext context) {
    return Column(
      children: [
        Divider(height: 1, color: Colors.grey[300]),
        Container(
          margin: EdgeInsets.only(left: con.order.status == 'PAGADO' ? 30 : 37, top: 15),
          child: Row(
            mainAxisAlignment: con.order.status == 'PAGADO'
                ? MainAxisAlignment.center
                : MainAxisAlignment.start,
            children: [
              Text(
                'TOTAL: \$${con.total.value}',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: Colors.black
                ),
              ),
              con.order.status.obs == 'DESPACHADO'
              ? _buttonUpdateOrder(context)
              : con.order.status.obs == 'ENCAMINO'
                ? _buttonGoToOrderMap()
                : Container()
            ],
          ),
        )

      ],
    );
  }

  Widget _buttonUpdateOrder(context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20,),
      child: ElevatedButton(
          onPressed: () {            
            con.updateOrder(context);            
          },
          style: ElevatedButton.styleFrom(
              padding: EdgeInsets.all(15),
              // primary: Colors.cyan
          ),
          child: Text(
            'INICIAR ENTREGA',
            style: TextStyle(
                color: Colors.black
            ),
          )
      ),
    );
  }

  Widget _buttonGoToOrderMap() {    
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: ElevatedButton(
          onPressed: () {
            con.updateToDelivered(context);         
          },
          style: ElevatedButton.styleFrom(
              padding: EdgeInsets.all(15),                                       
              // primary: Colors.lightGreenAccent
          ),
          child: Text(
            'ENTREGAR',
            style: TextStyle(
                color: Colors.black
            ),
          )
      ),
    );
  }

  Widget _buttonAccept(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(left: 30, right: 30),
      child: ElevatedButton(
        onPressed: con.isClose == true ? () => con.updateToDelivered(context) : null,
        child: Text(
          'ENTREGAR PEDIDO',
          style: TextStyle(
            color: Colors.black
          ),
        ),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15)
          ),
          padding: EdgeInsets.all(15)
        ),

      ),
    );
  }
}
