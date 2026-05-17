class AiDishTag {
  const AiDishTag({required this.label, required this.colorKey, this.iconKey});
  final String label;
  final String colorKey; // 'spicy' | 'time' | 'category' | 'healthy'
  final String? iconKey; // 'fire' | 'clock' | 'category' | 'leaf'

  factory AiDishTag.fromJson(Map<String, dynamic> json) => AiDishTag(
        label: json['label'] as String,
        colorKey: json['color'] as String? ?? 'category',
        iconKey: json['icon'] as String?,
      );
}

class AiDishResult {
  const AiDishResult({
    required this.title,
    required this.imageQuery,
    required this.prepTime,
    required this.servings,
    required this.tags,
    required this.ingredients,
    required this.steps,
    required this.nutrition,
  });

  final String title;
  final String imageQuery;
  final String prepTime;
  final String servings;
  final List<AiDishTag> tags;
  final List<String> ingredients;
  final List<String> steps;
  final Map<String, String> nutrition;

  factory AiDishResult.fromJson(Map<String, dynamic> json) => AiDishResult(
        title: json['title'] as String,
        imageQuery: json['imageQuery'] as String? ?? json['title'] as String,
        prepTime: json['prepTime'] as String,
        servings: json['servings'] as String? ?? '2 Porsi',
        tags: (json['tags'] as List? ?? [])
            .map((t) => AiDishTag.fromJson(t as Map<String, dynamic>))
            .toList(),
        ingredients: (json['ingredients'] as List? ?? []).cast<String>(),
        steps: (json['steps'] as List? ?? []).cast<String>(),
        nutrition: Map<String, String>.from(json['nutrition'] as Map? ?? {}),
      );
}

/// The parsed AI response. type is 'dish' | 'text' | 'redirect'
class AiAssistantResponse {
  const AiAssistantResponse({
    required this.type,
    required this.message,
    this.dish,
  });

  final String type;
  final String message;
  final AiDishResult? dish;

  factory AiAssistantResponse.fromJson(Map<String, dynamic> json) => AiAssistantResponse(
        type: json['type'] as String? ?? 'text',
        message: json['message'] as String? ?? '',
        dish: json['dish'] != null
            ? AiDishResult.fromJson(json['dish'] as Map<String, dynamic>)
            : null,
      );
}
