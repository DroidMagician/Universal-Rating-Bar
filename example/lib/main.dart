import 'package:flutter/material.dart';
import 'package:flutter_rating_bar_universal/flutter_rating_bar_universal.dart';

void main() => runApp(const ExampleApp());

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Universal Rating Bar',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        useMaterial3: true,
      ),
      home: const RatingDemoPage(),
    );
  }
}

class RatingDemoPage extends StatefulWidget {
  const RatingDemoPage({super.key});

  @override
  State<RatingDemoPage> createState() => _RatingDemoPageState();
}

class _RatingDemoPageState extends State<RatingDemoPage> {
  double _rating = 3.5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Universal Rating Bar'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _RatingCard(
            title: 'Current rating',
            subtitle: _rating.toStringAsFixed(1),
            child: UniversalRatingBar(
              rating: _rating,
              allowHalfRating: true,
              updateOnDrag: true,
              animateRatingChange: true,
              enableScaleEffect: true,
              precision: 0.5,
              onRatingChanged: (value) => setState(() => _rating = value),
            ),
          ),
          _RatingCard(
            title: 'Default stars (auto half icon)',
            subtitle: 'Uses Icons.star_half at 0.5 precision',
            child: UniversalRatingBar(
              rating: _rating,
              onRatingChanged: (value) => setState(() => _rating = value),
            ),
          ),
          _RatingCard(
            title: 'Fractional precision',
            subtitle: 'precision: 0.1 — supports 3.7, 4.2, etc.',
            child: UniversalRatingBar(
              rating: _rating,
              precision: 0.1,
              updateOnDrag: true,
              onRatingChanged: (value) => setState(() => _rating = value),
            ),
          ),
          _RatingCard(
            title: 'Heart icons',
            child: UniversalRatingBar.icon(
              rating: _rating,
              filledIcon: Icons.favorite,
              emptyIcon: Icons.favorite_border,
              filledColor: Colors.red,
              emptyColor: Colors.grey.shade400,
              onRatingChanged: (value) => setState(() => _rating = value),
            ),
          ),
          _RatingCard(
            title: 'SVG assets',
            child: UniversalRatingBar.asset(
              rating: _rating,
              filledAsset: 'assets/icons/star_filled.svg',
              emptyAsset: 'assets/icons/star_empty.svg',
              halfAsset: 'assets/icons/star_half.svg',
              onRatingChanged: (value) => setState(() => _rating = value),
            ),
          ),
          _RatingCard(
            title: 'Emoji widgets',
            child: UniversalRatingBar.custom(
              rating: _rating,
              itemBuilder: (context, index, state) {
                return switch (state) {
                  RatingState.full => const Text('😍', style: TextStyle(fontSize: 30)),
                  RatingState.half => const Text('🙂', style: TextStyle(fontSize: 30)),
                  RatingState.empty => const Text('😐', style: TextStyle(fontSize: 30)),
                };
              },
              onRatingChanged: (value) => setState(() => _rating = value),
            ),
          ),
          _RatingCard(
            title: 'itemBuilder',
            child: UniversalRatingBar.custom(
              rating: _rating,
              itemBuilder: (context, index, state) {
                return Icon(
                  switch (state) {
                    RatingState.full => Icons.star,
                    RatingState.half => Icons.star_half,
                    RatingState.empty => Icons.star_border,
                  },
                  color: state == RatingState.empty ? Colors.grey : Colors.amber,
                  size: 32,
                );
              },
              onRatingChanged: (value) => setState(() => _rating = value),
            ),
          ),
          _RatingCard(
            title: 'Read only',
            subtitle: 'isInteractive: false',
            child: UniversalRatingBar(
              rating: _rating,
              isInteractive: false,
            ),
          ),
          _RatingCard(
            title: 'Vertical layout',
            child: Align(
              alignment: Alignment.centerLeft,
              child: UniversalRatingBar(
                rating: _rating,
                direction: Axis.vertical,
                onRatingChanged: (value) => setState(() => _rating = value),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RatingCard extends StatelessWidget {
  const _RatingCard({
    required this.title,
    required this.child,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Text(
                subtitle!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
              ),
            ],
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}
