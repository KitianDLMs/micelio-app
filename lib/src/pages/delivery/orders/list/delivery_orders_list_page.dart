import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:micelio/src/models/order.dart';
import 'package:micelio/src/pages/delivery/orders/list/delivery_orders_list_controller.dart';
import 'package:micelio/src/widgets/no_data_widget.dart';

class DeliveryOrdersListPage extends StatelessWidget {
  final DeliveryOrdersListController con =
      Get.put(DeliveryOrdersListController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => DefaultTabController(
          length: con.status.length,
          child: Scaffold(
            appBar: _buildAppBar(),
            body: TabBarView(
              children:
                  con.status.map((status) => _buildOrdersList(status)).toList(),
            ),
          ),
        ));
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(4),
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: TabBar(
            isScrollable: true,
            indicatorColor: Colors.amber,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey[600],
            tabs: List.generate(
                con.status.length, (index) => Tab(text: con.status[index])),
          ),
        ),
      ),
    );
  }

  Widget _buildOrdersList(String status) {
    return FutureBuilder<List<Order?>>(
      future: con.getOrders(status),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return Center(child: NoDataWidget(text: 'No hay pedidos'));
        }

        final userOrders = snapshot.data!
            .where((order) => order?.delivery?.id == con.userSession.id)
            .toList();

        if (userOrders.isEmpty) {
          return Center(child: NoDataWidget(text: 'No hay pedidos'));
        }

        return Column(
          children: [
            if (status == 'ENTREGADO') _buildTotalByTrade(userOrders),
            Expanded(child: _buildOrderListView(userOrders)),
          ],
        );
      },
    );
  }

  Widget _buildOrderListView(List<Order?> orders) {
    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (_, index) => _buildOrderCard(orders[index]!),
    );
  }

  Widget _buildTotalByTrade(List<Order?> orders) {
    Map<String, List<Order>> ordersByTrade = {};

    for (var order in orders) {
      if (order != null && order.trade?.id != null) {
        ordersByTrade.putIfAbsent(order.trade!.id!, () => []).add(order);
      }
    }

    return Column(
      children: ordersByTrade.entries.map((entry) {
        return _buildTotalCard(entry.value, entry.key);
      }).toList(),
    );
  }

  Widget _buildTotalCard(List<Order> orders, String tradeId) {
    double totalDelivery =
        orders.fold(0.0, (sum, order) => sum + (order.deliveryPrice ?? 0.0));

    return Container(
      height: 100,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Card(
        elevation: 3.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Stack(
          children: [
            Container(
              height: 50,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15)),
              ),
              alignment: Alignment.center,
              child: Text(
                'Total Delivery - Comercio #$tradeId',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.amber),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 40, left: 20, right: 20),
              alignment: Alignment.centerLeft,
              child: Text(
                'Total Delivery: \$${totalDelivery.toStringAsFixed(2)}',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderCard(Order order) {
    return GestureDetector(
      onTap: () => con.goToOrderDetail(order),
      child: Container(
        height: 180,
        margin: const EdgeInsets.symmetric(horizontal: 20),
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
                      topRight: Radius.circular(15)),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Pedido #${order.id}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.green),
                ),
              ),
              _buildOrderDetails(order),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderDetails(Order order) {
    return Container(
      margin: const EdgeInsets.only(top: 15, left: 20, right: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildOrderDetailRow('Cliente',
              '${order.user?.name ?? ''} ${order.user?.lastname ?? ''}'),
          _buildOrderDetailRow('Entregar en',
              '${order.address?.neighborhood ?? ''} ${order.address?.address ?? ''} #${order.address?.number}'),
          _buildTradeInfo(order),
          _buildDeliveryPrice(order)
        ],
      ),
    );
  }

  Widget _buildDeliveryPrice(Order order) {
    return Row(children: [
      Expanded(
        child: _buildOrderDetailRow(
            'Delivery', order.deliveryPrice.toString() ?? 'N/A'),
      ),
    ]);
  }

  Widget _buildTradeInfo(Order order) {
    return Row(
      children: [
        Expanded(
          child: _buildOrderDetailRow('Comercio', order.trade?.name ?? 'N/A'),
        ),
        if (order.trade?.image != null)
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: Image.network(order.trade!.image!,
                width: 30, height: 30, fit: BoxFit.cover),
          ),
      ],
    );
  }

  Widget _buildOrderDetailRow(String label, String value) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 5),
      alignment: Alignment.centerLeft,
      child: Text('$label: $value', style: TextStyle(color: Colors.black)),
    );
  }

  double getOrderTotal(Order order) {
    return order.products?.fold(
            0.0,
            (sum, product) =>
                sum! + (product.quantity ?? 0) * (product.price ?? 0.0)) ??
        0.0;
  }
}
