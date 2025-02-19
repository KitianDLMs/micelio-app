import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:micelio/src/environment/environment.dart';
import 'package:micelio/src/providers/apple_signin_service.dart';
import 'package:micelio/src/providers/google_signin_service.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:url_launcher/url_launcher.dart';

class ClientHomeTutorialPage extends StatefulWidget {
  @override
  State<ClientHomeTutorialPage> createState() => _ClientHomeTutorialPageState();
}

class _ClientHomeTutorialPageState extends State<ClientHomeTutorialPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final Uri _termsAndConditionsUrl = Uri.parse(Environment.termsApp);

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
              title: "¡Pedidos Huertos!",
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
                      ?                        
                        ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                            255, 240, 240, 240),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                            _pageController.previousPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Atrás",
                            style: TextStyle(
                              color: Colors
                                  .black,
                              fontSize: 17,
                            ),
                          ),
                        ],
                      ),
                    )
                      : SizedBox.shrink(),
                  if (_currentPage < 2)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                            255, 240, 240, 240),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {                        
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Siguente",
                            style: TextStyle(
                              color: Colors
                                  .black,
                              fontSize: 17,
                            ),
                          ),
                        ],
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
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MaterialButton(
                splashColor: Colors.transparent,
                minWidth: double.infinity,
                height: 40,
                color: Colors.blue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/img/repartidor.png',
                      height: 20,
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      "  Iniciar sesión",
                      style: TextStyle(color: Colors.white, fontSize: 17),
                    ),
                  ],
                ),
                onPressed: () {
                  Get.offNamedUntil('/', (route) => false);
                },
              ),
              MaterialButton(
                  splashColor: Colors.transparent,
                  minWidth: double.infinity,
                  height: 40,
                  color: Colors.red,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(FontAwesomeIcons.google, color: Colors.white),
                      Text(
                        '  Iniciar con Google',
                        style: TextStyle(color: Colors.white, fontSize: 17),
                      )
                    ],
                  ),
                  onPressed: () {
                    GoogleSignInService.signInWithGoogle();
                  }),
              const SignInWithAppleButton(
                text: 'Iniciar con Apple',
                onPressed: AppleSignInService.signIn,
              ),
              MaterialButton(
                splashColor: Colors.transparent,
                minWidth: double.infinity,
                height: 40,
                color: const Color.fromARGB(255, 240, 240, 240),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.arrow_circle_up_rounded),
                    const SizedBox(width: 10),
                    const Text(
                      "Omitir",
                      style: TextStyle(color: Colors.black, fontSize: 17),
                    ),
                  ],
                ),
                onPressed: () {
                  Get.offAllNamed(
                      '/trade');
                },
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
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MaterialButton(
                splashColor: Colors.transparent,
                minWidth: double.infinity,
                height: 40,
                color: Colors.blue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/img/repartidor.png',
                      height: 20,
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      "  Iniciar sesión",
                      style: TextStyle(color: Colors.white, fontSize: 17),
                    ),
                  ],
                ),
                onPressed: () {
                  Get.offNamedUntil('/', (route) => false);
                },
              ),
              MaterialButton(
                splashColor: Colors.transparent,
                minWidth: double.infinity,
                height: 40,
                color: Colors.red,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(FontAwesomeIcons.google, color: Colors.white),
                    Text(
                      '  Iniciar con Google',
                      style: TextStyle(color: Colors.white, fontSize: 17),
                    )
                  ],
                ),
                onPressed: () {
                  GoogleSignInService.signInWithGoogle();
                },
              ),
              const SignInWithAppleButton(
                text: 'Iniciar con Apple',
                onPressed: AppleSignInService.signIn,
              ),
              MaterialButton(
                splashColor: Colors.transparent,
                minWidth: double.infinity,
                height: 40,
                color: const Color.fromARGB(255, 240, 240, 240),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.arrow_circle_up_rounded),
                    const SizedBox(width: 10),
                    const Text(
                      "Omitir",
                      style: TextStyle(color: Colors.black, fontSize: 17),
                    ),
                  ],
                ),
                onPressed: () {
                  Get.offAllNamed(
                      '/trade');
                },
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
              'assets/img/repartidor.png',
              width: 180,
              height: 180,
            ),
          ],
        ),
      ),
    );
  }
}
