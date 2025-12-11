import 'package:get/get.dart';

import 'en_US.dart';
import 'ar_EG.dart';

class TranslationService extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': enUS,
    'ar_EG': arEG,
  };
}