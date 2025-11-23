import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/attendance_providers.dart';

class DateSelector extends ConsumerWidget {
  const DateSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedDateProvider);
    final today = DateTime.now();
    final tomorrow = today.add(const Duration(days: 1));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: _DateButton(
              label: 'اليوم',
              date: today,
              isSelected: _isSameDay(selectedDate, today),
              onTap: () {
                ref.read(selectedDateProvider.notifier).state = today;
              },
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _DateButton(
              label: 'غداً',
              date: tomorrow,
              isSelected: _isSameDay(selectedDate, tomorrow),
              onTap: () {
                ref.read(selectedDateProvider.notifier).state = tomorrow;
              },
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _DateButton(
              label: 'اختر تاريخ',
              date: selectedDate,
              isSelected: !_isSameDay(selectedDate, today) &&
                  !_isSameDay(selectedDate, tomorrow),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030), // Allow future dates
                  locale: const Locale('ar', 'EG'),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: const ColorScheme.dark(
                          primary: Color(0xFFFF1744),
                          onPrimary: Colors.white,
                          surface: Color(0xFF161b22),
                          onSurface: Colors.white,
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
                if (picked != null) {
                  ref.read(selectedDateProvider.notifier).state = picked;
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

class _DateButton extends StatelessWidget {
  final String label;
  final DateTime date;
  final bool isSelected;
  final VoidCallback onTap;

  const _DateButton({
    required this.label,
    required this.date,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.primaryColor
              : (isDark ? theme.cardColor : Colors.white),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? theme.primaryColor
                : (isDark ? Colors.grey.shade800 : Colors.grey.shade300),
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: theme.primaryColor.withOpacity(0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : (isDark ? Colors.grey.shade400 : Colors.grey.shade600),
                fontWeight: FontWeight.bold,
                fontSize: 13,
                fontFamily: 'Cairo',
              ),
            ),
            const SizedBox(height: 2),
            if (label != 'اليوم' && label != 'غداً')
              Text(
                DateFormat('dd/MM', 'ar').format(date),
                style: TextStyle(
                  color: isSelected
                      ? Colors.white.withOpacity(0.9)
                      : (isDark ? Colors.grey.shade600 : Colors.grey.shade500),
                  fontSize: 11,
                  fontFamily: 'Cairo',
                ),
              ),
          ],
        ),
      ),
    );
  }
}

