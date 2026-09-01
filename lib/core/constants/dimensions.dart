import 'typography.dart';

class AppDimensions {
  AppDimensions._();

  // Shared readable type sizes for child-focused content.
  static const double cardTitleFont = AppTypeScale.itemTitle;
  static const double cardSubtitleFont = AppTypeScale.secondary;
  static const double cardPadding = 12;

  static const double learningGridSpacing = 14;
  static const double learningGridPadding = 16;
  static const double learningCardMinWidth = 145;
  static const double alphabetCardMinWidth = 120;

  static int responsiveColumnCount({
    required double availableWidth,
    required double minimumCardWidth,
    int maxColumns = 4,
  }) {
    final usableWidth = availableWidth - (learningGridPadding * 2);
    final count =
        ((usableWidth + learningGridSpacing) /
                (minimumCardWidth + learningGridSpacing))
            .floor();
    return count.clamp(2, maxColumns);
  }
}
