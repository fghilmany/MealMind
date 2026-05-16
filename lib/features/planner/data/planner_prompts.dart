import 'package:app/features/planner/domain/planner_preference_entity.dart';

class PlannerPrompts {
  PlannerPrompts._();

  static String generatePlan(PlannerPreferenceEntity preference) {
    final themeClause = preference.foodThemes.isEmpty
        ? ''
        : 'Preferensi tema makanan: ${preference.foodThemes.join(', ')}.';

    final halalClause = preference.halalOnly ? 'Semua hidangan harus halal.' : '';

    final notesClause = preference.additionalNotes.trim().isNotEmpty
        ? 'Catatan tambahan: ${preference.additionalNotes.trim()}.'
        : '';

    return '''
Buatkan rencana makan selama ${preference.totalDays} hari untuk saya.
$themeClause
$halalClause
$notesClause

Setiap hari terdiri dari 3 waktu makan: Sarapan, Makan Siang, dan Makan Malam.
Pastikan tidak ada pengulangan hidangan yang sama dalam ${preference.totalDays} hari.

Balas HANYA dengan JSON valid tanpa markdown, tanpa penjelasan lain, dengan format berikut:
{
  "days": [
    {
      "day": "string — nama hari dalam Bahasa Indonesia (contoh: Senin)",
      "meals": [
        {
          "mealType": "Sarapan",
          "title": "string — nama hidangan",
          "category": "string — tema makanan (contoh: Nusantara)",
          "prepTime": "string — contoh: 20 Menit",
          "calories": "string — contoh: 350"
        },
        {
          "mealType": "Makan Siang",
          "title": "string",
          "category": "string",
          "prepTime": "string",
          "calories": "string"
        },
        {
          "mealType": "Makan Malam",
          "title": "string",
          "category": "string",
          "prepTime": "string",
          "calories": "string"
        }
      ]
    }
  ]
}

Semua teks dalam Bahasa Indonesia.
''';
  }
}
