import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(4286009476),
      surfaceTint: Color(4286009476),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4294564095),
      onPrimaryContainer: Color(4281207356),
      secondary: Color(4285094253),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4294040819),
      onSecondaryContainer: Color(4280489768),
      tertiary: Color(4286665295),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4294957783),
      onTertiaryContainer: Color(4281536784),
      error: Color(4290386458),
      onError: Color(4294967295),
      errorContainer: Color(4294957782),
      onErrorContainer: Color(4282449922),
      surface: Color(4294965243),
      onSurface: Color(4280228383),
      onSurfaceVariant: Color(4283188301),
      outline: Color(4286411901),
      outlineVariant: Color(4291740621),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281610036),
      inversePrimary: Color(4293244658),
      primaryFixed: Color(4294564095),
      onPrimaryFixed: Color(4281207356),
      primaryFixedDim: Color(4293244658),
      onPrimaryFixedVariant: Color(4284299371),
      secondaryFixed: Color(4294040819),
      onSecondaryFixed: Color(4280489768),
      secondaryFixedDim: Color(4292198615),
      onSecondaryFixedVariant: Color(4283515476),
      tertiaryFixed: Color(4294957783),
      onTertiaryFixed: Color(4281536784),
      tertiaryFixedDim: Color(4294293428),
      onTertiaryFixedVariant: Color(4284889913),
      surfaceDim: Color(4292990943),
      surfaceBright: Color(4294965243),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4294701560),
      surfaceContainer: Color(4294306802),
      surfaceContainerHigh: Color(4293912045),
      surfaceContainerHighest: Color(4293583079),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(4284036198),
      surfaceTint: Color(4286009476),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4287522460),
      onPrimaryContainer: Color(4294967295),
      secondary: Color(4283252304),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4286607235),
      onSecondaryContainer: Color(4294967295),
      tertiary: Color(4284626741),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4288309093),
      onTertiaryContainer: Color(4294967295),
      error: Color(4287365129),
      onError: Color(4294967295),
      errorContainer: Color(4292490286),
      onErrorContainer: Color(4294967295),
      surface: Color(4294965243),
      onSurface: Color(4280228383),
      onSurfaceVariant: Color(4282925129),
      outline: Color(4284832869),
      outlineVariant: Color(4286675073),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281610036),
      inversePrimary: Color(4293244658),
      primaryFixed: Color(4287522460),
      onPrimaryFixed: Color(4294967295),
      primaryFixedDim: Color(4285812097),
      onPrimaryFixedVariant: Color(4294967295),
      secondaryFixed: Color(4286607235),
      onSecondaryFixed: Color(4294967295),
      secondaryFixedDim: Color(4284962666),
      onSecondaryFixedVariant: Color(4294967295),
      tertiaryFixed: Color(4288309093),
      onTertiaryFixed: Color(4294967295),
      tertiaryFixedDim: Color(4286533453),
      onTertiaryFixedVariant: Color(4294967295),
      surfaceDim: Color(4292990943),
      surfaceBright: Color(4294965243),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4294701560),
      surfaceContainer: Color(4294306802),
      surfaceContainerHigh: Color(4293912045),
      surfaceContainerHighest: Color(4293583079),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(4281668163),
      surfaceTint: Color(4286009476),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4284036198),
      onPrimaryContainer: Color(4294967295),
      secondary: Color(4280950318),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4283252304),
      onSecondaryContainer: Color(4294967295),
      tertiary: Color(4282062614),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4284626741),
      onTertiaryContainer: Color(4294967295),
      error: Color(4283301890),
      onError: Color(4294967295),
      errorContainer: Color(4287365129),
      onErrorContainer: Color(4294967295),
      surface: Color(4294965243),
      onSurface: Color(4278190080),
      onSurfaceVariant: Color(4280820265),
      outline: Color(4282925129),
      outlineVariant: Color(4282925129),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281610036),
      inversePrimary: Color(4294764031),
      primaryFixed: Color(4284036198),
      onPrimaryFixed: Color(4294967295),
      primaryFixedDim: Color(4282457679),
      onPrimaryFixedVariant: Color(4294967295),
      secondaryFixed: Color(4283252304),
      onSecondaryFixed: Color(4294967295),
      secondaryFixedDim: Color(4281673785),
      onSecondaryFixedVariant: Color(4294967295),
      tertiaryFixed: Color(4284626741),
      onTertiaryFixed: Color(4294967295),
      tertiaryFixedDim: Color(4282917152),
      onTertiaryFixedVariant: Color(4294967295),
      surfaceDim: Color(4292990943),
      surfaceBright: Color(4294965243),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4294701560),
      surfaceContainer: Color(4294306802),
      surfaceContainerHigh: Color(4293912045),
      surfaceContainerHighest: Color(4293583079),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(4293244658),
      surfaceTint: Color(4293244658),
      onPrimary: Color(4282720595),
      primaryContainer: Color(4284299371),
      onPrimaryContainer: Color(4294564095),
      secondary: Color(4292198615),
      onSecondary: Color(4281936957),
      secondaryContainer: Color(4283515476),
      onSecondaryContainer: Color(4294040819),
      tertiary: Color(4294293428),
      onTertiary: Color(4283180324),
      tertiaryContainer: Color(4284889913),
      onTertiaryContainer: Color(4294957783),
      error: Color(4294948011),
      onError: Color(4285071365),
      errorContainer: Color(4287823882),
      onErrorContainer: Color(4294957782),
      surface: Color(4279636503),
      onSurface: Color(4293583079),
      onSurfaceVariant: Color(4291740621),
      outline: Color(4288188055),
      outlineVariant: Color(4283188301),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4293583079),
      inversePrimary: Color(4286009476),
      primaryFixed: Color(4294564095),
      onPrimaryFixed: Color(4281207356),
      primaryFixedDim: Color(4293244658),
      onPrimaryFixedVariant: Color(4284299371),
      secondaryFixed: Color(4294040819),
      onSecondaryFixed: Color(4280489768),
      secondaryFixedDim: Color(4292198615),
      onSecondaryFixedVariant: Color(4283515476),
      tertiaryFixed: Color(4294957783),
      onTertiaryFixed: Color(4281536784),
      tertiaryFixedDim: Color(4294293428),
      onTertiaryFixedVariant: Color(4284889913),
      surfaceDim: Color(4279636503),
      surfaceBright: Color(4282201917),
      surfaceContainerLowest: Color(4279307538),
      surfaceContainerLow: Color(4280228383),
      surfaceContainer: Color(4280491555),
      surfaceContainerHigh: Color(4281149486),
      surfaceContainerHighest: Color(4281873209),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(4293508087),
      surfaceTint: Color(4293244658),
      onPrimary: Color(4280812598),
      primaryContainer: Color(4289495481),
      onPrimaryContainer: Color(4278190080),
      secondary: Color(4292461787),
      onSecondary: Color(4280160802),
      secondaryContainer: Color(4288514976),
      onSecondaryContainer: Color(4278190080),
      tertiary: Color(4294622136),
      onTertiary: Color(4281076747),
      tertiaryContainer: Color(4290413440),
      onTertiaryContainer: Color(4278190080),
      error: Color(4294949553),
      onError: Color(4281794561),
      errorContainer: Color(4294923337),
      onErrorContainer: Color(4278190080),
      surface: Color(4279636503),
      onSurface: Color(4294965754),
      onSurfaceVariant: Color(4292069330),
      outline: Color(4289372329),
      outlineVariant: Color(4287266954),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4293583079),
      inversePrimary: Color(4284365164),
      primaryFixed: Color(4294564095),
      onPrimaryFixed: Color(4280418353),
      primaryFixedDim: Color(4293244658),
      onPrimaryFixedVariant: Color(4283115353),
      secondaryFixed: Color(4294040819),
      onSecondaryFixed: Color(4279766301),
      secondaryFixedDim: Color(4292198615),
      onSecondaryFixedVariant: Color(4282331459),
      tertiaryFixed: Color(4294957783),
      onTertiaryFixed: Color(4280616711),
      tertiaryFixedDim: Color(4294293428),
      onTertiaryFixedVariant: Color(4283640617),
      surfaceDim: Color(4279636503),
      surfaceBright: Color(4282201917),
      surfaceContainerLowest: Color(4279307538),
      surfaceContainerLow: Color(4280228383),
      surfaceContainer: Color(4280491555),
      surfaceContainerHigh: Color(4281149486),
      surfaceContainerHighest: Color(4281873209),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(4294965754),
      surfaceTint: Color(4293244658),
      onPrimary: Color(4278190080),
      primaryContainer: Color(4293508087),
      onPrimaryContainer: Color(4278190080),
      secondary: Color(4294965754),
      onSecondary: Color(4278190080),
      secondaryContainer: Color(4292461787),
      onSecondaryContainer: Color(4278190080),
      tertiary: Color(4294965753),
      onTertiary: Color(4278190080),
      tertiaryContainer: Color(4294622136),
      onTertiaryContainer: Color(4278190080),
      error: Color(4294965753),
      onError: Color(4278190080),
      errorContainer: Color(4294949553),
      onErrorContainer: Color(4278190080),
      surface: Color(4279636503),
      onSurface: Color(4294967295),
      onSurfaceVariant: Color(4294965754),
      outline: Color(4292069330),
      outlineVariant: Color(4292069330),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4293583079),
      inversePrimary: Color(4282260300),
      primaryFixed: Color(4294631167),
      onPrimaryFixed: Color(4278190080),
      primaryFixedDim: Color(4293508087),
      onPrimaryFixedVariant: Color(4280812598),
      secondaryFixed: Color(4294369528),
      onSecondaryFixed: Color(4278190080),
      secondaryFixedDim: Color(4292461787),
      onSecondaryFixedVariant: Color(4280160802),
      tertiaryFixed: Color(4294959325),
      onTertiaryFixed: Color(4278190080),
      tertiaryFixedDim: Color(4294622136),
      onTertiaryFixedVariant: Color(4281076747),
      surfaceDim: Color(4279636503),
      surfaceBright: Color(4282201917),
      surfaceContainerLowest: Color(4279307538),
      surfaceContainerLow: Color(4280228383),
      surfaceContainer: Color(4280491555),
      surfaceContainerHigh: Color(4281149486),
      surfaceContainerHighest: Color(4281873209),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
        useMaterial3: true,
        brightness: colorScheme.brightness,
        colorScheme: colorScheme,
        textTheme: textTheme.apply(
          bodyColor: colorScheme.onSurface,
          displayColor: colorScheme.onSurface,
        ),
        scaffoldBackgroundColor: colorScheme.background,
        canvasColor: colorScheme.surface,
      );

  List<ExtendedColor> get extendedColors => [];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}

TextTheme createTextTheme(
    BuildContext context, String bodyFontString, String displayFontString) {
  TextTheme baseTextTheme = Theme.of(context).textTheme;
  TextTheme bodyTextTheme =
      GoogleFonts.getTextTheme(bodyFontString, baseTextTheme);
  TextTheme displayTextTheme =
      GoogleFonts.getTextTheme(displayFontString, baseTextTheme);
  TextTheme textTheme = displayTextTheme.copyWith(
    bodyLarge: bodyTextTheme.bodyLarge,
    bodyMedium: bodyTextTheme.bodyMedium,
    bodySmall: bodyTextTheme.bodySmall,
    labelLarge: bodyTextTheme.labelLarge,
    labelMedium: bodyTextTheme.labelMedium,
    labelSmall: bodyTextTheme.labelSmall,
  );
  return textTheme;
}
