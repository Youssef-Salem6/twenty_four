part of 'themes_cubit.dart';

@immutable
sealed class ThemesState {
  final bool isDarkMode;

  const ThemesState({required this.isDarkMode});
}

final class ThemesInitial extends ThemesState {
  const ThemesInitial() : super(isDarkMode: false);
}

final class ThemesLoaded extends ThemesState {
  const ThemesLoaded({required super.isDarkMode});
}
