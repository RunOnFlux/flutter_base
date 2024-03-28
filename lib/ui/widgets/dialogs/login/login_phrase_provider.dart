import 'package:flutter/material.dart';
import 'package:flutter_base/auth/service/auth_service.dart';

class LoginPhraseProvider with ChangeNotifier {
  clearData() {
    //nodeIP = null;
    loginPhrase = null;
    status = null;
    notifyListeners();
  }

  Future<void> fetchData() async {
    clearData();

    //nodeIP = await AuthService().getFluxNodeIP();
    //nodeIP = 'https://${nodeIP!.replaceAll('.', '-').replaceAll(':', '-')}.node.api.runonflux.io';
    //nodeIP = 'http://$nodeIP';
    //debugPrint(nodeIP);
    //if (nodeIP != null) {
    try {
      var value = await AuthService().getLoginPhrase();
      loginPhrase = value.loginPhrase;
      //debugPrint(loginPhrase);
      notifyListeners();
    } catch (err) {
      debugPrint(err.toString());
      if (err.toString().contains('CONNERROR')) {
        var value = await AuthService().getEmergencyLoginPhrase();
        if (value == null) {
          status = 'Failed to fetch login message';
        } else {
          loginPhrase = value.loginPhrase;
        }
        //debugPrint(loginPhrase);
        notifyListeners();
      }
    }
    //}
  }

  String? status;
  String? loginPhrase;
  //String? nodeIP;
}
