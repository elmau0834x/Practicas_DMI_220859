import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tok_tik/config/theme/app_theme.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    dotenv.loadFromString(
      envString: 'CHRISTMAS_START=12-01\nCHRISTMAS_END=01-06',
    );
  });

  test('Christmas season includes dates on both sides of New Year', () {
    final appTheme = AppTheme();

    expect(appTheme.seasonAt(DateTime(2026, 12, 1)), AppSeason.christmas);
    expect(
      appTheme.seasonAt(DateTime(2026, 12, 1, 23, 59, 59)),
      AppSeason.christmas,
    );
    expect(appTheme.seasonAt(DateTime(2026, 12, 25, 13)), AppSeason.christmas);
    expect(
      appTheme.seasonAt(DateTime(2027, 1, 6, 23, 59, 59)),
      AppSeason.christmas,
    );
  });

  test('dates outside the Christmas season keep the normal theme', () {
    expect(AppTheme().seasonAt(DateTime(2027, 1, 7)), AppSeason.normal);
  });
}
