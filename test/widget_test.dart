import 'package:flutter_test/flutter_test.dart';
import 'package:aeromel/app/app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('renders login screen', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: AeroMelApp()));
    await tester.pumpAndSettle();

    expect(find.text('AeroMel'), findsOneWidget);
    expect(find.text('Masuk'), findsOneWidget);
  });
}
