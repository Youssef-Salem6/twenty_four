import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:twenty_four/core/themes/manager/themesCubit/themes_cubit.dart';
import 'package:twenty_four/core/themes/themes.dart';
import 'package:twenty_four/features/home/manager/get_home_news/home_news_cubit.dart';
import 'package:twenty_four/features/splash/splash_view.dart';

// Global SharedPreferences instance
late SharedPreferences prefs;

void main() async {
  // ضروري لتشغيل SharedPreferences قبل runApp
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SharedPreferences globally
  prefs = await SharedPreferences.getInstance();

  // فقط في المرة الأولى، قم بتعيين القيمة الافتراضية
  if (!prefs.containsKey("isDarkMode")) {
    await prefs.setBool("isDarkMode", false); // الوضع الداكن افتراضياً
  }

  debugPaintSizeEnabled = false;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThemesCubit()..loadTheme(), // تحميل الثيم المحفوظ
      child: const AppView(),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemesCubit, ThemesState>(
      builder: (context, state) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => HomeNewsCubit()),
            // BlocProvider(create: (context) => SubjectBloc()),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: '24',
            theme: AppThemes.lightTheme,
            darkTheme: AppThemes.darkTheme,
            themeMode: state.isDarkMode ? ThemeMode.dark : ThemeMode.light,

            // إضافة دعم RTL للغة العربية
            locale: const Locale('ar', 'EG'), // اللغة العربية - مصر
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('ar', 'EG'), // العربية
              Locale('en', 'US'), // الإنجليزية كبديل
            ],

            // تحديد اتجاه النص من اليمين إلى اليسار
            builder: (context, child) {
              return Directionality(
                textDirection: TextDirection.rtl,
                child: child!,
              );
            },

            home: const SplashView(),
          ),
        );
      },
    );
  }
}
