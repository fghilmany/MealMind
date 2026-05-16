import 'package:equatable/equatable.dart';

class UserPreferenceEntity extends Equatable {
  const UserPreferenceEntity({
    this.foodThemes = const [],
    this.mealTime,
    this.course,
    this.halalOnly = true,
    this.additionalNotes = '',
  });

  /// Multi-select food themes e.g. ['Nusantara', 'Chinese']
  final List<String> foodThemes;

  /// Single optional: 'Breakfast' | 'Lunch' | 'Dinner' | null
  final String? mealTime;

  /// Single optional: 'Appetizer' | 'Main' | 'Dessert' | null
  final String? course;

  final bool halalOnly;
  final String additionalNotes;

  UserPreferenceEntity copyWith({
    List<String>? foodThemes,
    Object? mealTime = _sentinel,
    Object? course = _sentinel,
    bool? halalOnly,
    String? additionalNotes,
  }) {
    return UserPreferenceEntity(
      foodThemes: foodThemes ?? this.foodThemes,
      mealTime: mealTime == _sentinel ? this.mealTime : mealTime as String?,
      course: course == _sentinel ? this.course : course as String?,
      halalOnly: halalOnly ?? this.halalOnly,
      additionalNotes: additionalNotes ?? this.additionalNotes,
    );
  }

  Map<String, dynamic> toJson() => {
        'foodThemes': foodThemes,
        'mealTime': mealTime,
        'course': course,
        'halalOnly': halalOnly,
        'additionalNotes': additionalNotes,
      };

  factory UserPreferenceEntity.fromJson(Map<String, dynamic> json) {
    return UserPreferenceEntity(
      foodThemes: (json['foodThemes'] as List?)?.cast<String>() ?? const [],
      mealTime: json['mealTime'] as String?,
      course: json['course'] as String?,
      halalOnly: json['halalOnly'] as bool? ?? true,
      additionalNotes: json['additionalNotes'] as String? ?? '',
    );
  }

  @override
  List<Object?> get props => [foodThemes, mealTime, course, halalOnly, additionalNotes];
}

const _sentinel = Object();
