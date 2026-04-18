/// Theme barrel export
/// Chỉ cần import 1 dòng này trong toàn app:
/// ```dart
/// import 'package:your_app/core/theme/theme.dart';
/// ```

// Factory
export 'app_theme.dart';

// Extensions (ThemeExtension)
export 'extensions/app_colors_extension.dart';
export 'extensions/app_text_styles_extension.dart';
export 'extensions/app_theme_context_extension.dart';

// Raw tokens (chỉ dùng trong layer theme, không dùng trong UI)
export 'colors/color_palette.dart';
export 'colors/light_color_tokens.dart';
export 'colors/dark_color_tokens.dart';

// Typography
export 'typography/app_text_styles.dart';
export 'typography/app_font_weights.dart';
export 'typography/app_text_theme.dart';
