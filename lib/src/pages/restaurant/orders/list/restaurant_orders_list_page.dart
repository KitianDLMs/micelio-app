import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:micelio/src/models/order.dart';
import 'package:micelio/src/widgets/no_data_widget.dart';
import 'package:micelio/src/pages/restaurant/orders/list/restaurant_orders_list_controller.dart';
import 'package:micelio/src/utils/relative_time_util.dart';

class RestaurantOrdersListPage extends StatelessWidget {
  RestaurantOrdersListController con =
      Get.put(RestaurantOrdersListController());

  @override
  Widget build(BuildContext context) {
    var storage = GetStorage().read('trade');
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
              body: TabBarView(
                children: con.status.map((String status) {
                  return FutureBuilder<List<Order>>(
                    future: con.getOrders(status),
                    builder: (context, AsyncSnapshot<List<Order>> snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data != null &&
                            snapshot.data!.isNotEmpty) {
                          return Column(
                            children: [
                              if (status == 'ENTREGADO')
                                _cardCalculate(snapshot.data!, storage),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: snapshot.data?.length ?? 0,
                                  itemBuilder: (_, index) {
                                    return _cardOrder(snapshot.data![index]);
                                  },
                                ),
                              ),
                            ],
                          );
                        } else {
                          return Center(
                              child: NoDataWidget(text: 'No hay pedidos'));
                        }
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  );
                }).toList(),
              )),
        ));
  }

  double getOrderTotal(Order order) {
    double total = 0.0;
    if (order.products != null) {
      for (var product in order.products!) {
        total += (product.quantity ?? 0) * (product.price ?? 0.0);
      }
    }
    return total;
  }

  Widget _cardCalculate(List<Order> orders, String currentTradeId) {
    List<Order> filteredOrders =
        orders.where((order) => order.tradeId == currentTradeId).toList();

    Map<String, List<Order>> groupedOrders = {};
    Map<String, String> deliveryNames = {};

    for (var order in filteredOrders) {
      if (order.delivery != null && order.delivery!.id != null) {
        String deliveryId = order.delivery!.id!;
        if (deliveryNames[deliveryId] == null) {
          deliveryNames[deliveryId] =
              order.delivery!.name ?? 'Unknown Delivery';
        }

        if (groupedOrders[deliveryId] == null) {
          groupedOrders[deliveryId] = [];
        }
        groupedOrders[deliveryId]!.add(order);
      } else {
        print('Delivery is null for order: ${order.id}');
      }
    }

    List<Widget> deliveryCards = [];
    groupedOrders.forEach((deliveryId, orders) {
      double totalRecaudado = 0.0;
      double totalDelivery = 0.0;

      for (var order in orders) {
        totalRecaudado += getOrderTotal(order);
        totalDelivery +=
            order.deliveryPrice ?? 0.0; // Sumar el costo del delivery
      }

      String deliName = deliveryNames[deliveryId] ?? 'Unknown Delivery';

      deliveryCards.add(
        Container(
          height: 140,
          margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
          child: Card(
            elevation: 3.0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Stack(
              children: [
                Container(
                  height: 30,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      )),
                  child: Container(
                    margin: const EdgeInsets.only(top: 5),
                    child: Text(
                      'Total para Delivery $deliName',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.amber),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 15, left: 20, right: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(top: 5),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Total Recaudado: \$${totalRecaudado.toStringAsFixed(2)}',
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(top: 5),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Total Delivery: \$${totalDelivery.toStringAsFixed(2)}',
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(top: 5),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Total General: \$${(totalRecaudado + totalDelivery).toStringAsFixed(2)}',
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });

    return Column(
      children: deliveryCards,
    );
  }

  Widget _cardOrder(Order order) {
    return GestureDetector(
      onTap: () => con.goToOrderDetail(order),
      child: Container(
        height: 150,
        margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
        child: Card(
          elevation: 3.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Stack(
            children: [
              Container(
                height: 30,
                width: double.infinity,
                decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    )),
                child: Container(
                  margin: const EdgeInsets.only(top: 5),
                  child: Text(
                    'Order #${order.id}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.amber),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 15, left: 20, right: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(top: 5),
                        alignment: Alignment.centerLeft,
                        child: Text(
                            'Pedido: ${RelativeTimeUtil.getRelativeTime(order.timestamp ?? 0)}',
                            style: TextStyle(color: Colors.black))),
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(top: 5),
                      alignment: Alignment.centerLeft,
                      child: Text(
                          'Cliente: ${order.user?.name ?? ''} ${order.user?.lastname ?? ''}',
                          style: TextStyle(color: Colors.black)),
                    ),
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(top: 5),
                      alignment: Alignment.centerLeft,
                      child: Text(
                          'Destino: ${order.address?.neighborhood ?? ''} ${order.address?.address ?? ''} #${order.address?.number ?? ''}',
                          style: TextStyle(color: Colors.black)),
                    ),
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(top: 5),
                      alignment: Alignment.centerLeft,
                      child: Text('Delivery: ${order.deliveryPrice ?? ''}',
                          style: TextStyle(color: Colors.black)),
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
