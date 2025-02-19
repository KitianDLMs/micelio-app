import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:get/get.dart';
import 'package:micelio/src/models/product.dart';
import 'package:micelio/src/pages/client/products/detail/client_products_detail_controller.dart';

class ClientProductsDetailPage extends StatelessWidget {
  Product? product;
  late ClientProductsDetailController con;
  var counter = 0.obs;
  var price = 0.0.obs;

  ClientProductsDetailPage({@required this.product}) {
    con = Get.put(ClientProductsDetailController());
  }

  @override
  Widget build(BuildContext context) {    
    con.checkIfProductsWasAdded(product!, price, counter);  
    return Obx(() => Scaffold(
          bottomNavigationBar: Container(
              color: const Color.fromRGBO(245, 245, 245, 1.0),
              height: 100,
              child: _buttonsAddToBag()),
          body: Column(
            children: [
              _imageSlideshow(context),
              _textNameProduct(),
              _textDescriptionProduct(),
              _textPriceProduct()
            ],
          ),
        ));
  }

  Widget _textNameProduct() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(top: 30, left: 30, right: 30),
      child: Text(
        product?.name ?? '',
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 22, color: Colors.black),
      ),
    );
  }

  Widget _textDescriptionProduct() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(top: 30, left: 30, right: 30),
      child: Text(
        product?.description ?? '',
        style: TextStyle(
          fontSize: 16,
          color: Colors.black
        ),
      ),
    );
  }

  Widget _buttonsAddToBag() {
    bool isProductAvailable = product != null && (product!.stock ?? 0) > 0;

    return Column(
      children: [
        Divider(height: 1, color: Colors.grey[400]),
        Container(
          margin: EdgeInsets.only(left: 20, right: 20, top: 25),
          child: Row(
            children: [
              ElevatedButton(
                onPressed: isProductAvailable ? () => con.removeItem(product!, price, counter) : null,
                child: Text(
                  '-',
                  style: TextStyle(color: Colors.black, fontSize: 22),
                ),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey,
                    minimumSize: Size(20, 37),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      bottomLeft: Radius.circular(25),
                    ))),
              ),
              Obx(() => ElevatedButton(
                    onPressed: null, // El botón de cantidad solo muestra el valor
                    child: Text(
                      '${counter.value}',
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      minimumSize: Size(40, 37),
                    ),
                  )),
              ElevatedButton(
                onPressed: isProductAvailable ? () => con.addItem(product!, price, counter) : null,
                child: Text(
                  '+',
                  style: TextStyle(color: Colors.black, fontSize: 22),
                ),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey,
                    minimumSize: Size(37, 37),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                      topRight: Radius.circular(25),
                      bottomRight: Radius.circular(25),
                    ))),
              ),
              Spacer(),
              ElevatedButton(
                onPressed: isProductAvailable
                    ? () {
                        con.addToBag(product!, counter);
                        counter.value = 0;
                      }
                    : null,
                child: Text(
                  'Agregar   \$${price.value}',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: Platform.isAndroid ? 13 : 12,
                      fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  disabledBackgroundColor: Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _textPriceProduct() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(top: 15, left: 30, right: 30),
      child: Text(
        '\$${product?.price.toString() ?? ''}',
        style: TextStyle(
            fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _imageSlideshow(BuildContext context) {
  return Stack(
    children: [
      ImageSlideshow(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.4,
        initialPage: 0,
        indicatorColor: Colors.amber,
        indicatorBackgroundColor: Colors.grey,
        children: [
          FadeInImage(
            fit: BoxFit.cover,
            fadeInDuration: Duration(milliseconds: 50),
            placeholder: AssetImage('assets/img/no-image.png'),
            image: product!.image1 != null
                ? NetworkImage(product!.image1!)
                : AssetImage('assets/img/no-image.png') as ImageProvider,
          ),
        ],
      ),
      if (product?.stock == 0) // Mostrar solo si no hay stock
        Positioned.fill(
          child: Container(
            color: Colors.black.withOpacity(0.5), // Oscurecer imagen
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Transform.rotate(
                    angle: -0.2, // Inclinación de la línea
                    child: Container(
                      width: 250,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          'SIN STOCK',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
    ],
  );
}

}
