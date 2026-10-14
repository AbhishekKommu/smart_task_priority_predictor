import 'package:flutter_test/flutter_test.dart';
import 'package:smart_task_priority_predictor/services/priority_predictor.dart';

void main() {
  final now = DateTime(2026, 1, 1, 9);

  test('urgent + important task is High', () {
    final s = PriorityPredictor.score(
      deadline: now.add(const Duration(hours: 10)),
      importance: 5,
      effortHours: 6,
      now: now,
    );
    expect(PriorityPredictor.level(s), 'High');
  });

  test('far deadline + low importance is Low', () {
    final s = PriorityPredictor.score(
      deadline: now.add(const Duration(days: 60)),
      importance: 1,
      effortHours: 1,
      now: now,
    );
    expect(PriorityPredictor.level(s), 'Low');
  });

  test('score stays within 0..100', () {
    final s = PriorityPredictor.score(
      deadline: now.subtract(const Duration(days: 5)),
      importance: 5,
      effortHours: 40,
      now: now,
    );
    expect(s, inInclusiveRange(0, 100));
  });
}
