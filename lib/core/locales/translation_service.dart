import 'package:get/get.dart';

import 'en_us.dart';
import 'ar_eg.dart';

class TranslationService extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': enUS,
    'ar_EG': arEG,
  };
}