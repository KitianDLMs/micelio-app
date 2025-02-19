import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:get/get.dart';
import 'package:micelio/src/models/product.dart';
import 'package:micelio/src/pages/restaurant/products/detail/restaurant_products_detail_controller.dart';

class RestaurantProductsDetailPage extends StatelessWidget {
  Product? product;
  late RestaurantProductsDetailController con;
  var counter = 0.obs;
  var price = 0.0.obs;

  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController priceController;
  var stock = 0.obs;
  RestaurantProductsDetailPage({@required this.product}) {
    con = Get.put(RestaurantProductsDetailController());

    nameController = TextEditingController(text: product?.name ?? '');
    descriptionController =
        TextEditingController(text: product?.description ?? '');
    priceController =
        TextEditingController(text: product?.price.toString() ?? '0.0');
    stock.value = product?.stock ?? 0;
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
              _textPriceProduct(),
              _textStockProduct()
            ],
          ),
        ));
  }

  Widget _textNameProduct() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.only(top: 30, left: 30, right: 30),
      child: TextField(        
        controller: nameController,
        style: const TextStyle(color: Colors.black), 
        decoration: const InputDecoration(          
          labelText: "Nombre del Producto",
          labelStyle: TextStyle(color: Colors.black),
          border: OutlineInputBorder(),          
        ),
      ),
    );
  }

  Widget _textStockProduct() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.only(top: 15, left: 30, right: 30),
      child: TextField(
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          labelText: "Stock Disponible",
          labelStyle: TextStyle(color: Colors.black),
          border: OutlineInputBorder(),
        ),
        controller: TextEditingController(text: stock.value.toString()),
        style: const TextStyle(color: Colors.black), 
        onChanged: (value) {
          stock.value = int.tryParse(value) ?? 0; // Actualizar stock
        },
      ),
    );
  }

  Widget _textDescriptionProduct() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.only(top: 30, left: 30, right: 30),
      child: TextField(
        controller: descriptionController,
        style: const TextStyle(color: Colors.black), 
        maxLines: 3,
        decoration: const InputDecoration(
          labelText: "Descripción",
          labelStyle: TextStyle(color: Colors.black),
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _textPriceProduct() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.only(top: 15, left: 30, right: 30),
      child: TextField(
        controller: priceController,
        style: const TextStyle(color: Colors.black), 
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          labelText: "Precio",
          labelStyle: TextStyle(color: Colors.black),
          border: OutlineInputBorder(),
          prefixText: "\$",
        ),
        onChanged: (value) {
          // Actualizar precio cuando cambia el campo
          price.value = double.tryParse(value) ?? 0.0;
        },
      ),
    );
  }

  Widget _buttonsAddToBag() {
    return Column(
      children: [
        Divider(height: 1, color: Colors.grey[400]),
        Container(
          margin: const EdgeInsets.only(left: 20, right: 20, top: 25),
          child: Row(
            children: [
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  // Llamamos al método updateProduct para actualizar los datos del producto
                  con.updateProduct(
                    product!,
                    nameController.text,
                    descriptionController.text,
                    double.tryParse(priceController.text) ?? 0.0,
                    stock.value,
                  );
                  // Después de actualizar, podemos reiniciar el contador o realizar cualquier otra acción
                  counter.value = 0;
                },
                child: Text(
                  'Actualizar Producto',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: Platform.isAndroid ? 13 : 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _imageSlideshow(BuildContext context) {
    return ImageSlideshow(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.4,
        initialPage: 0,
        indicatorColor: Colors.amber,
        indicatorBackgroundColor: Colors.grey,
        children: [
          FadeInImage(
              fit: BoxFit.cover,
              fadeInDuration: const Duration(milliseconds: 50),
              placeholder: const AssetImage('assets/img/no-image.png'),
              image: product!.image1 != null
                  ? NetworkImage(product!.image1!)
                  : const AssetImage('assets/img/no-image.png')
                      as ImageProvider),
        ]);
  }
}
