/// Design System public API barrel file.
///
/// This is the single entry-point that app/sandbox should import.
/// Keep exports curated to avoid leaking internal implementation details.
/// The DS remains package-ready and feature-agnostic.
library design_system;

// =======================
// Tokens (selective)
// =======================
export 'src/tokens/breakpoint_tokens.dart';
export 'src/tokens/opacity_tokens.dart';
export 'src/tokens/motion_tokens.dart';
export 'src/tokens/color_palette.dart'; // For custom preset creation

// =======================
// Foundations
// =======================
export 'src/foundations/app_colors.dart';
export 'src/foundations/app_typography.dart';
export 'src/foundations/app_spacing.dart';
export 'src/foundations/app_shape.dart';
export 'src/foundations/app_elevation.dart';
export 'src/foundations/app_motion.dart';

// =======================
// Theme
// =======================
export 'src/theme/app_theme.dart';
export 'src/theme/app_color_scheme.dart';
export 'src/theme/app_text_theme.dart';
export 'src/theme/theme_builder.dart';

// Theme selection + palettes
export 'src/theme/theme_selection_types.dart';
export 'src/theme/palette_preset.dart';
export 'src/theme/palette_registry.dart';

// Presets
export 'src/theme/presets/white_preset.dart';
export 'src/theme/presets/milk_white_preset.dart';
export 'src/theme/presets/dark_preset.dart';
export 'src/theme/presets/semi_dark_preset.dart';
export 'src/theme/presets/gray_preset.dart';
// export 'src/theme/presets/green_brand_preset.dart'; // optional

// Theme extensions (DS API surface)
export 'src/theme/theme_extensions/ds_extensions.dart';
export 'src/theme/theme_extensions/spacing_ext.dart';
export 'src/theme/theme_extensions/radii_ext.dart';
export 'src/theme/theme_extensions/elevation_ext.dart';
export 'src/theme/theme_extensions/component_styles_ext.dart';

// =======================
// Layouts
// =======================
export 'src/layouts/app_scaffold.dart';
export 'src/layouts/page_padding.dart';
export 'src/layouts/safe_area_wrapper.dart';
export 'src/layouts/section.dart';
export 'src/layouts/responsive_builder.dart';

// =======================
// Utils
// =======================
export 'src/utils/ds_context_x.dart';
export 'src/utils/accessibility_utils.dart';
export 'src/utils/responsive_utils.dart';

// =======================
// Components
// =======================

// Buttons
export 'src/components/buttons/app_button.dart';
export 'src/components/buttons/app_icon_button.dart';
export 'src/components/buttons/button_variants.dart';

// Cards
export 'src/components/cards/app_card.dart';
export 'src/components/cards/card_variants.dart';

// Navigation
export 'src/components/navigation/app_app_bar.dart';
export 'src/components/navigation/app_bottom_bar.dart';
export 'src/components/navigation/app_bottom_bar_center_action.dart'; // NEW
export 'src/components/navigation/app_drawer.dart';
export 'src/components/navigation/navigation_item.dart';

// Inputs
export 'src/components/inputs/app_text_field.dart';
export 'src/components/inputs/app_dropdown.dart';
export 'src/components/inputs/app_date_picker.dart';
export 'src/components/inputs/input_style_resolver.dart';

// Feedback
export 'src/components/feedback/app_snackbar.dart';
export 'src/components/feedback/app_toast.dart';
export 'src/components/feedback/app_loading.dart';
export 'src/components/feedback/app_empty_state.dart';

// Data display
export 'src/components/data_display/app_list_tile.dart';
export 'src/components/data_display/app_chip.dart';
export 'src/components/data_display/app_tag.dart';
export 'src/components/data_display/app_divider.dart';
export 'src/components/data_display/app_avatar.dart';

// Dialogs
export 'src/components/dialogs/app_alert_dialog.dart';
export 'src/components/dialogs/app_bottom_sheet.dart';
export 'src/components/dialogs/dialog_variants.dart';

// Icons
export 'src/components/icons/app_icon.dart';
export 'src/components/icons/icon_source.dart';
