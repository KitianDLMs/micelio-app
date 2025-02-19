import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:micelio/src/models/trade..dart';
import 'package:micelio/src/models/user.dart';
import 'package:micelio/src/pages/client/home/client_home_page.dart';
import 'package:micelio/src/pages/home/home_page.dart';
import 'package:micelio/src/providers/trade_provider.dart';


class TradeHomeController extends GetxController {
  var trades = <Trade>[].obs; // Lista de trades observable
  var isLoading = false.obs;

  TradeProvider tradeProvider = TradeProvider();
  User user = User.fromJson(GetStorage().read('user') ?? {});

  TradeHomeController() {
    fetchTrades(); // Carga los trades al inicializar el controlador
  }

  void fetchTrades() async {
    isLoading.value = true;
    try {
      var result = await tradeProvider.getAll(); // Supongamos que retorna una lista de Trade
      trades.value = result;
    } catch (e) {
      print('Error al obtener los trades: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void goToClientPage() {
    // print('goToClientPage ${trade.userId}');
    // GetStorage().write('trade', trade);
    // GetStorage().write('trade${trade.id}',
    Get.off(() => ClientHomePage());
  }

  void signOut() {
    GetStorage().remove('user');
    GetStorage().remove('trade');
    Get.offNamedUntil('/home-tutorial', (route) => false);
  }
}
