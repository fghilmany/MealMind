import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../domain/planner_preference_entity.dart';

class PlannerPreferenceSheet extends StatefulWidget {
  const PlannerPreferenceSheet({super.key});

  @override
  State<PlannerPreferenceSheet> createState() => _PlannerPreferenceSheetState();
}

class _PlannerPreferenceSheetState extends State<PlannerPreferenceSheet> {
  static const _foodThemes = [
    'Nusantara',
    'Sundanese',
    'Javanese',
    'West Sumatra',
    'Betawi',
    'Chinese',
    'Japanese',
    'Thai',
    'Western',
    'Melayu',
    'Singapore',
  ];

  List<String> _selectedThemes = [];
  bool _halalOnly = true;
  int _totalDays = 7;
  final TextEditingController _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _toggleTheme(String theme) {
    setState(() {
      if (_selectedThemes.contains(theme)) {
        _selectedThemes.remove(theme);
      } else {
        _selectedThemes.add(theme);
      }
    });
  }

  void _submit() {
    final preference = PlannerPreferenceEntity(
      foodThemes: _selectedThemes,
      halalOnly: _halalOnly,
      additionalNotes: _notesController.text,
      totalDays: _totalDays,
    );
    Navigator.pop(context, preference);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Drag handle
        const SizedBox(height: 8),
        Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: AppColors.neutral300,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        // Header
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 8, 0),
          child: Row(
            children: [
              Text('Meal Plan Preferences', style: AppTextStyles.titleMedium),
              const Spacer(),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close, color: AppColors.neutral700),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        // Scrollable body
        Flexible(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Total Days ───────────────────────────────────────────
                _sectionHeader(Icons.calendar_today_outlined, 'TOTAL DAYS', null),
                const SizedBox(height: 12),
                Row(
                  children: List.generate(7, (i) {
                    final day = i + 1;
                    final isSelected = _totalDays == day;
                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(right: i < 6 ? 6 : 0),
                        child: GestureDetector(
                          onTap: () => setState(() => _totalDays = day),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.primary : AppColors.neutral100,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isSelected ? AppColors.primary : AppColors.neutral300,
                              ),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  '$day',
                                  style: AppTextStyles.titleSmall.copyWith(
                                    color: isSelected ? Colors.white : AppColors.textPrimary,
                                  ),
                                ),
                                Text(
                                  day == 1 ? 'day' : 'days',
                                  style: AppTextStyles.labelSmall.copyWith(
                                    color: isSelected ? Colors.white70 : AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 24),
                // ── Food Theme ───────────────────────────────────────────
                _sectionHeader(Icons.restaurant_menu_outlined, 'FOOD THEME', 'Optional'),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _foodThemes.map((t) {
                    final selected = _selectedThemes.contains(t);
                    return _SelectableChip(
                      label: t,
                      isSelected: selected,
                      onTap: () => _toggleTheme(t),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
                // ── Halal toggle ─────────────────────────────────────────
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.neutral200),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Halal Only', style: AppTextStyles.titleSmall),
                            const SizedBox(height: 2),
                            Text(
                              'Show only certified halal options',
                              style: AppTextStyles.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: _halalOnly,
                        onChanged: (v) => setState(() => _halalOnly = v),
                        activeThumbColor: AppColors.primary,
                        activeTrackColor: AppColors.primary300,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // ── Additional notes ─────────────────────────────────────
                _sectionHeader(Icons.edit_note_outlined, 'ADDITIONAL NOTES', null),
                const SizedBox(height: 12),
                TextField(
                  controller: _notesController,
                  maxLines: 3,
                  style: AppTextStyles.bodyMedium,
                  decoration: InputDecoration(
                    hintText: 'E.g. No seafood, low sodium, allergies...',
                    hintStyle:
                        AppTextStyles.bodyMedium.copyWith(color: AppColors.neutral400),
                    filled: true,
                    fillColor: AppColors.neutral100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.all(14),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
        // Fixed bottom button
        Container(
          padding: EdgeInsets.fromLTRB(
            20,
            12,
            20,
            12 + MediaQuery.of(context).padding.bottom,
          ),
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: Border(top: BorderSide(color: AppColors.neutral200)),
          ),
          child: AppButton(
            label: 'Generate $_totalDays-Day Meal Plan',
            icon: Icons.auto_awesome_outlined,
            isFullWidth: true,
            onPressed: _submit,
          ),
        ),
      ],
    );
  }

  Widget _sectionHeader(IconData icon, String title, String? badge) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 6),
        Text(
          title,
          style: AppTextStyles.labelSmall.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
          ),
        ),
        if (badge != null) ...[
          const Spacer(),
          Text(badge, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
        ],
      ],
    );
  }
}

class _SelectableChip extends StatelessWidget {
  const _SelectableChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.neutral100,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.neutral300,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.labelMedium.copyWith(
            color: isSelected ? Colors.white : AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
