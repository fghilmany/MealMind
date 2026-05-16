class PlannerPreferenceEntity {
  const PlannerPreferenceEntity({
    this.foodThemes = const [],
    this.halalOnly = true,
    this.additionalNotes = '',
    this.totalDays = 7,
  });

  final List<String> foodThemes;
  final bool halalOnly;
  final String additionalNotes;
  final int totalDays; // 1–7

  @override
  String toString() =>
      'PlannerPreference(themes: $foodThemes, halal: $halalOnly, days: $totalDays, notes: $additionalNotes)';
}
