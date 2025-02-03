import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:micelio/src/providers/blocs/notifications/notifications_bloc.dart';
import 'package:micelio/src/providers/preferences/pref_usuarios.dart';
import 'package:url_launcher/url_launcher.dart';

class ClientHomeTutorialPage extends StatefulWidget {
  // ClientHomeTutorialPage({super.key});

  @override
  State<ClientHomeTutorialPage> createState() => _ClientHomeTutorialPageState();
}

class _ClientHomeTutorialPageState extends State<ClientHomeTutorialPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final Uri _termsAndConditionsUrl =
      Uri.parse('https://micelio-terms.netlify.app/');

  Future<void> _launchTermsAndConditions() async {
    if (!await launchUrl(_termsAndConditionsUrl)) {
      throw 'No se pudo abrir el enlace $_termsAndConditionsUrl';
    }
  }

  @override
  Widget build(BuildContext context) {   
    return Scaffold(
      body: Container(
        color: const Color(0xffF2F2F2),
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentPage = index;
            });
          },
          children: [
            _buildFirstTutorialPage(
              context,
              title: "¡Bienvenido a Micelio!",
              description: "(para realizar compras debes iniciar sesión)",
              image: Icons.motorcycle,
            ),
            _buildTutorialPage(
              context,
              title: "Explora Productos",
              description: "Encuentra productos increíbles en nuestra tienda.",
              image: Icons.shopping_cart,
            ),
            _buildLastTutorialPage(
              context,
              title: "Gestiona tus pedidos",
              description: "Realiza y gestiona tus pedidos fácilmente.",
              image: Icons.list_alt,
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _currentPage > 0
                      ? ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Color.fromARGB(255, 240, 240, 240))),
                          onPressed: () {
                            _pageController.previousPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                          child: Text("Atrás",
                              style: TextStyle(color: Colors.black)),
                        )
                      : SizedBox.shrink(),
                  if (_currentPage < 2)
                    ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color.fromARGB(255, 240, 240, 240))),
                      onPressed: () {
                        _pageController.nextPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: Text(
                        "Siguiente",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: _launchTermsAndConditions,
                child: const Text(
                  "Términos y Condiciones",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Echnelapp ®",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFirstTutorialPage(BuildContext context,
      {required String title,
      required String description,
      required IconData image}) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _imageCover(),
          const SizedBox(height: 32),
          Text(
            title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Color.fromARGB(255, 240, 240, 240))),
                onPressed: () {
                  // Get.offAllNamed('/');
                  Get.offNamedUntil('/', (route) => false);
                },
                child: Text("Iniciar sesión",
                    style: TextStyle(color: Colors.black)),
              ),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Color.fromARGB(255, 240, 240, 240))),
                onPressed: () {
                  Get.offAllNamed(
                      '/client/home'); // Navega a la pantalla principal
                },
                child: Text("Omitir", style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTutorialPage(BuildContext context,
      {required String title,
      required String description,
      required IconData image}) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(image, size: 150, color: Colors.amber),
          SizedBox(height: 32),
          Text(
            title,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          Text(
            description,
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLastTutorialPage(BuildContext context,
      {required String title,
      required String description,
      required IconData image}) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(image, size: 150, color: Colors.amber),
          SizedBox(height: 32),
          Text(
            title,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          Text(
            description,
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Color.fromARGB(255, 240, 240, 240))),
                onPressed: () {
                  Get.offAllNamed('/'); // Navega al login
                },
                child: Text("Iniciar sesión",
                    style: TextStyle(color: Colors.black)),
              ),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Color.fromARGB(255, 240, 240, 240))),
                onPressed: () {
                  Get.offAllNamed(
                      '/client/home'); // Navega a la pantalla principal
                },
                child: Text("Omitir", style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _imageCover() {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(top: 20, bottom: 15),
        alignment: Alignment.center,
        child: Column(
          children: [
            Image.asset(
              'assets/img/logo_micelio_polera.png',
              width: 180,
              height: 180,
            ),
          ],
        ),
      ),
    );
  }
}
