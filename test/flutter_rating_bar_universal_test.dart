import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_rating_bar_universal/flutter_rating_bar_universal.dart';

void main() {
  group('RatingMath', () {
    test('stateForIndex handles full, half, and empty', () {
      expect(
        RatingMath.stateForIndex(
          index: 0,
          rating: 1,
          allowHalfRating: true,
          precision: 0.5,
        ),
        RatingState.full,
      );
      expect(
        RatingMath.stateForIndex(
          index: 2,
          rating: 2.5,
          allowHalfRating: true,
          precision: 0.5,
        ),
        RatingState.half,
      );
      expect(
        RatingMath.stateForIndex(
          index: 3,
          rating: 2.5,
          allowHalfRating: true,
          precision: 0.5,
        ),
        RatingState.empty,
      );
    });

    test('fillFractionForIndex returns precise fractions', () {
      expect(
        RatingMath.fillFractionForIndex(
          index: 3,
          rating: 3.7,
          allowHalfRating: true,
          precision: 0.1,
        ),
        closeTo(0.7, 0.001),
      );
    });

    test('normalize snaps to precision and clamps range', () {
      expect(
        RatingMath.normalize(
          rawRating: 3.26,
          itemCount: 5,
          precision: 0.25,
          minRating: 0,
          allowHalfRating: true,
        ),
        3.25,
      );
      expect(
        RatingMath.normalize(
          rawRating: 10,
          itemCount: 5,
          precision: 0.5,
          minRating: 0,
          allowHalfRating: true,
        ),
        5,
      );
    });

    test('ratingFromItemTap supports half taps', () {
      expect(
        RatingMath.ratingFromItemTap(
          index: 2,
          localPosition: 4,
          itemExtent: 32,
          allowHalfRating: true,
          precision: 0.5,
          minRating: 0,
        ),
        2.5,
      );
      expect(
        RatingMath.ratingFromItemTap(
          index: 2,
          localPosition: 20,
          itemExtent: 32,
          allowHalfRating: true,
          precision: 0.5,
          minRating: 0,
        ),
        3,
      );
    });
  });

  group('UniversalRatingBar', () {
    testWidgets('renders default star icons', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UniversalRatingBar(rating: 3.5),
          ),
        ),
      );

      expect(find.byType(Icon), findsNWidgets(5));
    });

    testWidgets('uses Icons.star_half for default half rating', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UniversalRatingBar(rating: 2.5),
          ),
        ),
      );

      expect(find.byIcon(Icons.star_half), findsOneWidget);
      expect(find.byIcon(Icons.star), findsNWidgets(2));
      expect(find.byIcon(Icons.star_border), findsNWidgets(2));
    });

    testWidgets('clips icons for fractional non-half ratings', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UniversalRatingBar(
              rating: 3.7,
              precision: 0.1,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.star_half), findsNothing);
      expect(find.byType(ClipRect), findsOneWidget);
    });

    testWidgets('uses custom icons in icon mode', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UniversalRatingBar.icon(
              rating: 4,
              filledIcon: Icons.favorite,
              emptyIcon: Icons.favorite_border,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.favorite), findsWidgets);
      expect(find.byIcon(Icons.favorite_border), findsWidgets);
    });

    testWidgets('calls onRatingChanged when tapped', (tester) async {
      double? changed;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UniversalRatingBar(
              rating: 2,
              allowHalfRating: false,
              updateOnDrag: false,
              onRatingChanged: (value) => changed = value,
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.star).first);
      await tester.pump();

      expect(changed, 1);
    });

    testWidgets('does not call onRatingChanged in read-only mode', (tester) async {
      var changed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UniversalRatingBar(
              rating: 2,
              isInteractive: false,
              onRatingChanged: (_) => changed = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(Icon).first);
      await tester.pump();

      expect(changed, isFalse);
    });

    testWidgets('itemBuilder receives correct states', (tester) async {
      final states = <RatingState>[];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UniversalRatingBar.custom(
              rating: 2.5,
              itemBuilder: (context, index, state) {
                states.add(state);
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      expect(states, [
        RatingState.full,
        RatingState.full,
        RatingState.half,
        RatingState.empty,
        RatingState.empty,
      ]);
    });

    testWidgets('supports vertical layout', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UniversalRatingBar(
              rating: 3,
              direction: Axis.vertical,
            ),
          ),
        ),
      );

      expect(find.byType(Column), findsOneWidget);
    });

    testWidgets('FlexRatingBar is an alias', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FlexRatingBar(rating: 1),
          ),
        ),
      );

      expect(find.byType(UniversalRatingBar), findsOneWidget);
    });
  });
}
