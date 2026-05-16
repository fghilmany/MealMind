import '../domain/entities/user_preference_entity.dart';

class HomePrompts {
  HomePrompts._();

  static String recommendation(UserPreferenceEntity preference) {
    final themeClause = preference.foodThemes.isEmpty
        ? ''
        : 'Preferensi tema makanan saya: ${preference.foodThemes.join(', ')}.';

    final mealTimeClause = preference.mealTime != null
        ? 'Waktu makan yang diinginkan: ${preference.mealTime}.'
        : '';

    final courseClause = preference.course != null
        ? 'Jenis hidangan: ${preference.course}.'
        : '';

    final halalClause = preference.halalOnly
        ? 'Semua rekomendasi harus halal.'
        : '';

    final notesClause = preference.additionalNotes.trim().isNotEmpty
        ? 'Catatan tambahan: ${preference.additionalNotes.trim()}.'
        : '';

    return '''
Berikan saya rekomendasi makanan yang cocok untuk saya.
$themeClause
$mealTimeClause
$courseClause
$halalClause
$notesClause

Balas HANYA dengan JSON valid tanpa markdown, tanpa penjelasan, dengan format berikut:
{
  "greeting": "string — sapaan SINGKAT maksimal 4 kata, contoh: Selamat Pagi, Chef!",
  "subtitle": "string — 1 kalimat motivasi singkat konteks hari ini",
  "hero": {
    "title": "string — nama hidangan TERENAK dan TERBAIK yang paling direkomendasikan hari ini",
    "prepTime": "string (contoh: 20 Menit)",
    "badge": "Pilihan Terbaik AI",
    "detail": {
      "prepTime": "string",
      "servings": "string (contoh: 2 Porsi)",
      "badges": ["string", "string"],
      "ingredients": ["string","string","string","string","string"],
      "nutrition": {
        "calories": "string angka saja",
        "protein": "string dengan satuan g",
        "carbs": "string dengan satuan g",
        "fat": "string dengan satuan g"
      },
      "steps": [
        "string — instruksi langkah 1 (contoh: Potong ayam menjadi beberapa bagian, taburi garam dan merica, aduk rata.)",
        "string — instruksi langkah 2",
        "string — dan seterusnya sesuai kebutuhan resep"
      ]
    }
  },
  "recommendations": [
    {
      "mealType": "Sarapan",
      "title": "string",
      "category": "string",
      "rating": number antara 4.5 dan 5.0,
      "whyYoullLoveIt": "string",
      "prepTime": "string",
      "servings": "string",
      "badges": ["string","string"],
      "ingredients": ["string","string","string","string","string"],
      "nutrition": {
        "calories": "string",
        "protein": "string",
        "carbs": "string",
        "fat": "string"
      },
      "steps": [
        "string — instruksi langkah 1",
        "string — dan seterusnya"
      ]
    },
    {
      "mealType": "Makan Siang",
      "title": "string",
      "category": "string",
      "rating": number antara 4.5 dan 5.0,
      "whyYoullLoveIt": "string",
      "prepTime": "string",
      "servings": "string",
      "badges": ["string","string"],
      "ingredients": ["string","string","string","string","string"],
      "nutrition": {
        "calories": "string",
        "protein": "string",
        "carbs": "string",
        "fat": "string"
      },
      "steps": [
        "string — instruksi langkah 1",
        "string — dan seterusnya"
      ]
    },
    {
      "mealType": "Makan Malam",
      "title": "string",
      "category": "string",
      "rating": number antara 4.5 dan 5.0,
      "whyYoullLoveIt": "string",
      "prepTime": "string",
      "servings": "string",
      "badges": ["string","string"],
      "ingredients": ["string","string","string","string","string"],
      "nutrition": {
        "calories": "string",
        "protein": "string",
        "carbs": "string",
        "fat": "string"
      },
      "steps": [
        "string — instruksi langkah 1",
        "string — dan seterusnya"
      ]
    }
  ]
}

Semua teks dalam Bahasa Indonesia.
''';
  }
}
