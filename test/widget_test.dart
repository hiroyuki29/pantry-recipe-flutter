import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:pantry_recipe_flutter/main.dart';

void main() {
  testWidgets('sign in page test', (WidgetTester tester) async {
    await tester.pumpWidget(ProviderScope(child: MyApp()));

    expect(find.text('ログイン'), findsOneWidget);
    expect(find.text('ログアウト'), findsNothing);
    expect(find.byType(MaterialButton), findsNWidgets(3));
    expect(find.byType(TextButton), findsOneWidget);
    //
    await tester.tap(find.byType(TextButton));
    await tester.pumpAndSettle();
    //
    expect(find.text('パスワード再設定'), findsOneWidget);

  });
}
