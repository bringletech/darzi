import 'dart:ui';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectLangController extends GetxController {
  final Rx<Locale?> currentLocale = Rx<Locale?>(null);

  String tailorLabel = "Tailor";
  String customerLabel = "Customer";
  String selectLanguage = "Select Your Language";

  @override
  void onInit() {
    super.onInit();
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    String? code = prefs.getString('selectedLanguage');
    if (code != null) {
      currentLocale.value = Locale(code);
      updateLabels(Locale(code));
    }
  }

  Future<void> saveLanguage(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedLanguage', locale.languageCode);
    currentLocale.value = locale;
    updateLabels(locale);
  }

  void updateLabels(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        tailorLabel = "Tailor";
        customerLabel = "Customer";
        selectLanguage = "Select  Your Language";
        break;
      case 'hi':
        tailorLabel = "दर्जी";
        customerLabel = "ग्राहक";
        selectLanguage = "अपनी भाषा चुनें।";
        break;
      case 'pa':
        tailorLabel = "ਦਰਜੀ";
        customerLabel = "ਗਾਹਕ";
        selectLanguage = "ਆਪਣੀ ਭਾਸ਼ਾ ਚੁਣੋ।";
        break;
      case 'te':
        tailorLabel = "దర్జీ";
        customerLabel = "ఖాతాదారు";
        selectLanguage = "మీ భాషను ఎంచుకోండి";
        break;
      case 'ta':
        tailorLabel = "தையாலகர்";
        customerLabel = "வாடிக்கையாளர்";
        selectLanguage = "உங்கள் மொழியைத் தேர்வுசெய்க";
        break;
      case 'kn':
        tailorLabel = "ದರ್ಜಿತ";
        customerLabel = "ಗ್ರಾಹಕ";
        selectLanguage = "ನಿಮ್ಮ ಭಾಷೆ ಆಯ್ಕೆಮಾಡಿ";
        break;
      case 'ml':
        tailorLabel = "തൈലോർ";
        customerLabel = "ഉപഭോക്താവ്";
        selectLanguage = "നിങ്ങളുടെ ഭാഷ തിരഞ്ഞെടുക്കുക";
        break;
      case 'gu':
        tailorLabel = "દરજી";
        customerLabel = "ગ્રાહક";
        selectLanguage = "તમારી ભાષા પસંદ કરો";
        break;
      case 'mr':
        tailorLabel = "शिंपी";
        customerLabel = "ग्राहक";
        selectLanguage = "आपली भाषा निवडा";
        break;
    }
    update();
  }
}
