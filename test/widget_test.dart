import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mi_nueva_app/main.dart';

void main() {
  testWidgets('calendar navigates months and updates the agenda', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1200, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const MyApp());

    expect(find.text('Septiembre 2026'), findsNWidgets(2));
    expect(find.text('Presentación de proyecto'), findsOneWidget);

    await tester.tap(find.byKey(const Key('next_month')));
    await tester.pumpAndSettle();

    expect(find.text('Octubre 2026'), findsNWidgets(2));
    expect(find.text('Un día sin pendientes'), findsOneWidget);
  });

  testWidgets('selecting a marked day shows its event on mobile', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const MyApp());
    await tester.tap(find.byKey(const ValueKey('day_2026_9_5')));
    await tester.pumpAndSettle();

    expect(find.text('Reunión de equipo'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('a new event can be created for the selected day', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1200, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const MyApp());
    await tester.tap(find.byKey(const ValueKey('day_2026_9_22')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('add_event_button')));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('event_title_field')),
      'Diseñar nueva experiencia',
    );
    await tester.pump();
    await tester.tap(find.byKey(const Key('save_event_button')));
    await tester.pumpAndSettle();

    expect(find.text('Diseñar nueva experiencia'), findsOneWidget);
    expect(find.text('1 evento'), findsOneWidget);
  });
}
