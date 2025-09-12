import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppLanguage { english, arabic }

class LanguageCubit extends Cubit<AppLanguage> {
  LanguageCubit() : super(AppLanguage.english);

  static const String _languageKey = 'selected_language';

  Future<void> loadLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final languageCode = prefs.getString(_languageKey) ?? 'en';
      
      if (languageCode == 'ar') {
        emit(AppLanguage.arabic);
      } else {
        emit(AppLanguage.english);
      }
    } catch (e) {
      print('Error loading language: $e');
      emit(AppLanguage.english);
    }
  }

  Future<void> setLanguage(AppLanguage language) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final languageCode = language == AppLanguage.arabic ? 'ar' : 'en';
      await prefs.setString(_languageKey, languageCode);
      emit(language);
    } catch (e) {
      print('Error saving language: $e');
    }
  }

  String get languageCode {
    return state == AppLanguage.arabic ? 'ar' : 'en';
  }

  String get languageName {
    return state == AppLanguage.arabic ? 'العربية' : 'English';
  }

  String get languageShortCode {
    return state == AppLanguage.arabic ? 'AR' : 'EN';
  }

  bool get isArabic => state == AppLanguage.arabic;
  bool get isEnglish => state == AppLanguage.english;
}
