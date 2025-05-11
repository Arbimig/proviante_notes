import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<bool> {
  ThemeCubit() : super(false) {
    loadTheme();
  }

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('isDark') ?? false;
    emit(isDark);
  }

  Future<void> toggleTheme() async {
    final newIsDark = !state;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDark', newIsDark);
    emit(newIsDark);
  }

  
}
