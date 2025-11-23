import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../../core/theme/theme_provider.dart';
import '../providers/attendance_providers.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../widgets/date_selector.dart';
import '../widgets/stats_card.dart';
import '../widgets/dashboard_charts_section.dart';
import '../widgets/rider_tile.dart';
import '../../domain/models/rider_attendance.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _refreshController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onRefresh() async {
    ref.invalidate(ridersAttendanceProvider);
    await Future.delayed(const Duration(milliseconds: 500));
    _refreshController.refreshCompleted();
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد'),
        content: const Text('هل تريد تسجيل الخروج؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref.read(authControllerProvider.notifier).logout();
              if (mounted) {
                context.go('/login');
              }
            },
            child: const Text('تسجيل الخروج'),
          ),
        ],
      ),
    );
  }

  List<RiderAttendance> _filterRiders(List<RiderAttendance> riders) {
    if (_searchQuery.isEmpty) return riders;
    
    final query = _searchQuery.toLowerCase();
    return riders.where((riderAttendance) {
      final name = riderAttendance.rider.name.toLowerCase();
      final id = riderAttendance.rider.id.toString();
      return name.contains(query) || id.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final ridersAsync = ref.watch(ridersAttendanceProvider);
    final currentUser = ref.watch(authControllerProvider).value;

    return Scaffold(
      appBar: AppBar(
        title: const Text('MR DELIVERY - لوحة المشرف'),
        actions: [
          IconButton(
            icon: Icon(
              ref.watch(themeModeProvider) == ThemeMode.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: () {
              ref.read(themeModeProvider.notifier).toggleTheme();
            },
            tooltip: ref.watch(themeModeProvider) == ThemeMode.dark
                ? 'الوضع الفاتح'
                : 'الوضع الداكن',
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _handleLogout,
            tooltip: 'تسجيل الخروج',
          ),
        ],
      ),
      body: Column(
        children: [
          // Header Section with Gradient
          Container(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                // Date Selector
                const DateSelector(),
                
                const SizedBox(height: 12),
                
                // Search Field
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'بحث عن طيار...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: Theme.of(context).scaffoldBackgroundColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 1,
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() => _searchQuery = value);
                  },
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),

          // Content
          Expanded(
            child: ridersAsync.when(
              data: (riders) {
                if (riders.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inbox,
                          size: 64,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'لا توجد بيانات لهذا اليوم.',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Colors.grey,
                              ),
                        ),
                      ],
                    ),
                  );
                }

                final filteredRiders = _filterRiders(riders);
                
                // Mock logic for new hires (e.g., riders with specific status or just a placeholder for now)
                // In a real scenario, we would filter by 'joining_date' or similar.
                // For now, let's assume the last 3 riders are "New Hires" for demonstration if requested.
                final newHires = riders.length > 3 ? riders.sublist(riders.length - 3) : [];

                return SmartRefresher(
                  controller: _refreshController,
                  onRefresh: _onRefresh,
                  enablePullDown: true,
                  child: filteredRiders.isEmpty
                      ? ListView(
                          children: [
                            StatsCard(riders: riders),
                            DashboardChartsSection(riders: riders),
                            const SizedBox(height: 50),
                            Center(
                              child: Text(
                                'لا توجد نتائج للبحث',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(color: Colors.grey),
                              ),
                            ),
                          ],
                        )
                      : ListView.builder(
                          itemCount: filteredRiders.length + 3, // Stats + Charts + New Hires + Riders
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return StatsCard(riders: riders);
                            }
                            if (index == 1) {
                              return DashboardChartsSection(riders: riders);
                            }
                            if (index == 2) {
                              // New Hires Section
                              if (newHires.isEmpty) return const SizedBox.shrink();
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    child: Row(
                                      children: [
                                        Icon(Icons.person_add_alt_1, color: Theme.of(context).primaryColor),
                                        const SizedBox(width: 8),
                                        Text(
                                          'التعيينات الجديدة',
                                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 140,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      padding: const EdgeInsets.symmetric(horizontal: 8),
                                      itemCount: newHires.length,
                                      itemBuilder: (context, i) {
                                        final rider = newHires[i];
                                        return Container(
                                          width: 280,
                                          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          child: Card(
                                            elevation: 2,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                            child: Padding(
                                              padding: const EdgeInsets.all(12),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      CircleAvatar(
                                                        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                                                        child: Icon(Icons.person, color: Theme.of(context).primaryColor),
                                                      ),
                                                      const SizedBox(width: 8),
                                                      Expanded(
                                                        child: Text(
                                                          rider.rider.name,
                                                          maxLines: 1,
                                                          overflow: TextOverflow.ellipsis,
                                                          style: const TextStyle(fontWeight: FontWeight.bold),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const Spacer(),
                                                  Text('المنطقة: ${rider.rider.zone ?? "غير محدد"}'),
                                                  Text('الهاتف: ${rider.rider.phone}'),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    child: Divider(),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    child: Text(
                                      'جميع الطيارين',
                                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }
                            
                            final riderAttendance = filteredRiders[index - 3];
                            return RiderTile(
                              riderAttendance: riderAttendance,
                              onTap: () {
                                context.push(
                                  '/rider/${riderAttendance.rider.id}',
                                );
                              },
                            );
                          },
                        ),
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red[300],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'حدث خطأ في تحميل البيانات',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      error.toString(),
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        ref.invalidate(ridersAttendanceProvider);
                      },
                      child: const Text('إعادة المحاولة'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

