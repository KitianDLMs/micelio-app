import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:micelio/src/models/order.dart';
import 'package:micelio/src/pages/client/orders/list/client_orders_list_controller.dart';
import 'package:micelio/src/utils/relative_time_util.dart';
import 'package:micelio/src/widgets/no_data_widget.dart';

class ClientOrdersListPage extends StatelessWidget {
  ClientOrdersListController con = Get.put(ClientOrdersListController());
  var trade = GetStorage().read('trade');  
  @override
  Widget build(BuildContext context) {
    return Obx(() => DefaultTabController(
          length: con.status.length,
          child: Scaffold(
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(50),
                child: AppBar(
                  bottom: TabBar(
                    isScrollable: true,
                    indicatorColor: Colors.amber,
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.grey[600],
                    tabs: List<Widget>.generate(con.status.length, (index) {
                      return Tab(
                        child: Text(con.status[index]),
                      );
                    }),
                  ),
                ),
              ),
              body: Stack(
                children: [
                  TabBarView(
                    children: con.status.map((String status) {
                      return FutureBuilder(
                        future: con.getOrders(status),
                        builder:
                            (context, AsyncSnapshot<List<Order?>> snapshot, ) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: Colors.black,
                              ),
                            );
                          }

                          if (!snapshot.hasData || snapshot.data == null) {
                            return Center(
                              child: NoDataWidget(text: 'No hay pedidos'),
                            );
                          }                
                                    
                          final userOrders = snapshot.data!.where((order) {                                                                              
                            return order?.clientId == con.userSession.id && order!.tradeId == trade.id;
                          }).toList();

                          if (userOrders.isEmpty) {
                            return Center(
                              child: NoDataWidget(text: 'No hay pedidos'),
                            );
                          }                          

                          return ListView.builder(
                            itemCount: userOrders.length,
                            itemBuilder: (_, index) {
                              return _cardOrder(
                                  userOrders[index]!);
                            },
                          );
                        },
                      );
                    }).toList(),
                  )                  
                ],
              )),
        ));
  }

  Widget _cardOrder(Order order) {
    return GestureDetector(
      onTap: () => {
        con.goToOrderDetail(order),
        // NotiService().showNotification(title: 'notificacion', body: 'body de la notificación')
      },
      child: Container(
        height: 150,
        margin: EdgeInsets.only(left: 20, right: 20, top: 10),
        child: Card(
          elevation: 3.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Stack(
            children: [
              Container(
                height: 30,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    )),
                child: Container(
                  margin: EdgeInsets.only(top: 5),
                  child: Text(                    
                    'Pedido #${order.id}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.amber),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 15, left: 20, right: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [                    
                    Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(top: 5),
                        alignment: Alignment.centerLeft,
                        child: Text(
                            'Pedido: ${RelativeTimeUtil.getRelativeTime(order.timestamp ?? 0)}', style: TextStyle(color: Colors.black),)),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(top: 5),
                      alignment: Alignment.centerLeft,
                      child: Text(
                          'Repartidor: ${order.delivery?.name ?? 'No asignado'} ${order.delivery?.lastname ?? ''}', style: TextStyle(color: Colors.black)),
                    ),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(top: 5),
                      alignment: Alignment.centerLeft,
                      child:
                          Text('Entregar en: ${order.address?.neighborhood ?? ''} ${order.address?.address ?? ''} #${order.address?.number ?? ''}', style: TextStyle(color: Colors.black)),
                    ),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(top: 5),
                      alignment: Alignment.centerLeft,
                      child:
                          Text('Delivery: \$${order.deliveryPrice ?? ''}', style: TextStyle(color: Colors.black)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
