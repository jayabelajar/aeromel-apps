import 'package:flutter_test/flutter_test.dart';
import 'package:melongrow_ai/app/app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('renders login screen', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: MelonGrowApp()));
    await tester.pumpAndSettle();

    expect(find.text('MelonGrow AI'), findsOneWidget);
    expect(find.text('Masuk'), findsOneWidget);
  });
}
