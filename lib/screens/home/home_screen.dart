import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../models/water_log_entry.dart';
import '../onboarding/gender_name_screen.dart';
import 'username_setup_sheet.dart';
import 'water/add_intake_sheet.dart';
import 'water/water_recent_updates_screen.dart';
import '../rin_ai/rin_ai_screen.dart';

enum WaterCardState { normal, goalCompleted, dayEndingSoon, aboveGoal }

class HomeScreen extends StatefulWidget {
  final String name;
  final Gender gender;

  const HomeScreen({super.key, required this.name, required this.gender});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final double _waterGoalL = 2.5;
  int _bottomNavIndex = 0;
  int _carouselIndex = 0;

  // All logged drinks today, most recent first. Only entries with
  // category == water count toward the hydration goal ring.
  // TODO: this resets on app restart — persist once a backend/local DB exists.
  final List<WaterLogEntry> _waterLog = [];

  // Custom drink names the user has typed before, remembered for reuse
  // in the "Other Drinks" tab, per the mockup's "added to the system for
  // next use" note. TODO: persist beyond this session once backend exists.
  final List<String> _savedCustomDrinks = [];

  // TODO: wire this to the real Temperature & Activity screen once it's
  // built. Per the mockup, water tracking should disable itself if those
  // values haven't been updated in the last 24h. Defaulting to "just
  // updated" so the feature isn't disabled out of the box.
  DateTime _lastTempGymUpdate = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) UsernameSetupSheet.show(context);
    });
  }

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning,';
    if (hour < 17) return 'Good Afternoon,';
    return 'Good Evening,';
  }

  IconData get _greetingIcon {
    final hour = DateTime.now().hour;
    if (hour < 17) return Icons.wb_sunny_outlined;
    return Icons.nights_stay_outlined;
  }

  String get _avatarAsset => widget.gender == Gender.male
      ? 'lib/assets/images/avatar_male.png'
      : 'lib/assets/images/avatar_female.png';

  // ---- Water data derived from the log ----

  int get _waterIntakeMl => _waterLog
      .where((e) => e.category == DrinkCategory.water)
      .fold(0, (sum, e) => sum + e.amountMl);

  double get _waterIntakeL => _waterIntakeMl / 1000;

  int get _waterPercent =>
      _waterGoalL == 0 ? 0 : ((_waterIntakeL / _waterGoalL) * 100).round();

  bool get _isTrackingDisabled =>
      DateTime.now().difference(_lastTempGymUpdate) > const Duration(hours: 24);

  WaterCardState get _waterState {
    if (_waterIntakeL > _waterGoalL) return WaterCardState.aboveGoal;
    if (_waterIntakeL == _waterGoalL && _waterGoalL > 0) return WaterCardState.goalCompleted;
    // TODO: tie this to the user's actual day-end/bedtime setting instead
    // of a hardcoded hour once that preference exists.
    if (DateTime.now().hour >= 21) return WaterCardState.dayEndingSoon;
    return WaterCardState.normal;
  }

  List<WaterLogEntry> get _recentWaterEntries => _waterLog.take(2).toList();

  void _logEntry(WaterLogEntry entry) {
    setState(() {
      _waterLog.insert(0, entry);
      if (entry.category == DrinkCategory.custom &&
          !_savedCustomDrinks.contains(entry.label)) {
        _savedCustomDrinks.add(entry.label);
      }
    });
  }

  // Swipe-up shortcut: quick-add 100ml of water directly from the avatar.
  void _quickAddWater(int ml) {
    _logEntry(
      WaterLogEntry(
        id: UniqueKey().toString(),
        label: 'Water',
        category: DrinkCategory.water,
        amountMl: ml,
        time: DateTime.now(),
      ),
    );
  }

  // Swipe-down shortcut: removes ml from the most recent water entry,
  // per the mockup note "swipe down, removes 100 ml ... for WATER only".
  void _quickRemoveWater(int ml) {
    setState(() {
      final waterEntries = _waterLog.where((e) => e.category == DrinkCategory.water);
      if (waterEntries.isEmpty) return;
      final latest = waterEntries.first;
      final newAmount = latest.amountMl - ml;
      final index = _waterLog.indexWhere((e) => e.id == latest.id);
      if (newAmount <= 0) {
        _waterLog.removeAt(index);
      } else {
        _waterLog[index] = latest.copyWith(amountMl: newAmount);
      }
    });
  }

  Future<void> _openAddIntake() async {
    if (_isTrackingDisabled) return;
    final entry = await AddIntakeSheet.show(context, savedCustomDrinks: _savedCustomDrinks);
    if (entry != null) _logEntry(entry);
  }

  void _openRecentUpdates() {
    if (_carouselIndex != 0) return; // Meal/Sleep recent-updates come later
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => WaterRecentUpdatesScreen(
          recentEntries: _recentWaterEntries,
          onUpdate: (id, newAmountMl) {
            setState(() {
              final index = _waterLog.indexWhere((e) => e.id == id);
              if (index != -1) {
                _waterLog[index] = _waterLog[index].copyWith(amountMl: newAmountMl);
              }
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Greeting
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _greeting,
                        style: TextStyle(fontSize: 15, color: AppColors.textGrey),
                      ),
                      Row(
                        children: [
                          Text(
                            widget.name,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textDark,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Icon(_greetingIcon, size: 20, color: Colors.orange.shade300),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Avatar area with carousel dots
            Expanded(
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  // Avatar image — swipe up/down adjusts water when on the
                  // Water page. Greyed out entirely when tracking is disabled.
                  Positioned.fill(
                    child: GestureDetector(
                      onVerticalDragEnd: (details) {
                        if (_carouselIndex != 0 || _isTrackingDisabled) return;
                        final velocity = details.primaryVelocity ?? 0;
                        if (velocity < -250) {
                          _quickAddWater(100);
                        } else if (velocity > 250) {
                          _quickRemoveWater(100);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: ColorFiltered(
                          colorFilter: _isTrackingDisabled
                              ? const ColorFilter.matrix(<double>[
                                  0.2126, 0.7152, 0.0722, 0, 0,
                                  0.2126, 0.7152, 0.0722, 0, 0,
                                  0.2126, 0.7152, 0.0722, 0, 0,
                                  0, 0, 0, 1, 0,
                                ])
                              : ColorFilter.mode(
                                  AppColors.primaryBlue.withValues(alpha: 0.12),
                                  BlendMode.srcATop,
                                ),
                          child: Image.asset(
                            _avatarAsset,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Right side action icons
                  Positioned(
                    right: 16,
                    top: 8,
                    child: Column(
                      children: [
                        _buildCircleIcon(Icons.more_vert),
                        const SizedBox(height: 12),
                        _buildCircleIcon(Icons.ios_share), // TODO: wire up avatar sharing
                        const SizedBox(height: 12),
                        GestureDetector(
                          onTap: _openRecentUpdates,
                          child: _buildCircleIcon(Icons.info_outline, iconColor: AppColors.primaryBlue),
                        ),
                      ],
                    ),
                  ),

                  // Water tracker card, top-left
                  Positioned(
                    left: 16,
                    top: 8,
                    child: _buildWaterCard(),
                  ),

                  // Carousel dots
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(3, (index) {
                        final isActive = index == _carouselIndex;
                        return GestureDetector(
                          onTap: () => setState(() => _carouselIndex = index),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isActive ? AppColors.primaryBlue : Colors.grey.shade300,
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),

            // Add Water/Drink button — only wired for the Water page (index 0).
            // TODO: swap in Add Food / Sleep actions for indexes 1 and 2.
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: ElevatedButton(
                onPressed: (_carouselIndex == 0 && !_isTrackingDisabled) ? _openAddIntake : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  disabledBackgroundColor: AppColors.lightBlue,
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Add Water/Drink', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    SizedBox(width: 8),
                    Icon(Icons.add_circle_outline, size: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildWaterCard() {
    final state = _waterState;
    final disabled = _isTrackingDisabled;

    String caption;
    Color captionColor;
    IconData? captionIcon;

    if (disabled) {
      caption = 'Update Temperature & Activity';
      captionColor = AppColors.textGrey;
      captionIcon = Icons.lock_outline;
    } else {
      switch (state) {
        case WaterCardState.goalCompleted:
          caption = 'Goal Completed';
          captionColor = Colors.green;
          captionIcon = Icons.check_circle;
          break;
        case WaterCardState.dayEndingSoon:
          caption = 'Day ending soon';
          captionColor = Colors.orange;
          captionIcon = Icons.access_time_filled;
          break;
        case WaterCardState.aboveGoal:
          caption = 'Above Goal';
          captionColor = Colors.orange;
          captionIcon = Icons.warning_amber_rounded;
          break;
        case WaterCardState.normal:
          caption = _waterIntakeL == 0 ? "Let's get started!" : 'Keep it up!';
          captionColor = Colors.green;
          captionIcon = null;
      }
    }

    return Opacity(
      opacity: disabled ? 0.55 : 1.0,
      child: Container(
        width: 150,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.water_drop, size: 16, color: AppColors.primaryBlue),
                const SizedBox(width: 6),
                Text('Water', style: TextStyle(fontSize: 13, color: AppColors.textGrey)),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '${_waterIntakeL.toStringAsFixed(2)}L',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.primaryBlue),
                ),
                const Spacer(),
                // Per the mockup: once above goal, stop showing the % ring
                // and just show a small warning icon instead.
                if (!disabled && state != WaterCardState.aboveGoal)
                  SizedBox(
                    width: 28,
                    height: 28,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircularProgressIndicator(
                          value: (_waterIntakeL / _waterGoalL).clamp(0, 1),
                          strokeWidth: 3,
                          backgroundColor: Colors.grey.shade200,
                          valueColor: AlwaysStoppedAnimation(
                            state == WaterCardState.dayEndingSoon ? Colors.orange : AppColors.primaryBlue,
                          ),
                        ),
                        Text('$_waterPercent%', style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  )
                else if (!disabled)
                  Icon(Icons.warning_amber_rounded, size: 22, color: Colors.orange.shade400),
              ],
            ),
            Text(
              'of ${_waterGoalL}L goal',
              style: TextStyle(fontSize: 11, color: AppColors.textGrey),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                if (captionIcon != null) ...[
                  Icon(captionIcon, size: 12, color: captionColor),
                  const SizedBox(width: 4),
                ],
                Expanded(
                  child: Text(
                    caption,
                    style: TextStyle(fontSize: 11, color: captionColor, fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircleIcon(IconData icon, {Color? iconColor}) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 6, offset: const Offset(0, 2)),
        ],
      ),
      child: Icon(icon, size: 18, color: iconColor ?? AppColors.textDark),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, -2)),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavIcon(Icons.home_outlined, 'Home', 0),
              _buildNavIcon(Icons.groups_outlined, 'Care Circle', 1),
              _buildNavIcon(Icons.auto_awesome_outlined, 'Rin AI', 2),
              _buildNavIcon(Icons.person_outline, 'Profile', 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavIcon(IconData icon, String label, int index) {
    final isSelected = _bottomNavIndex == index;
    final color = isSelected ? AppColors.primaryBlue : Colors.grey.shade400;
    return GestureDetector(
      onTap: () {
        if (index == 2) {
          Navigator.push(context, MaterialPageRoute(builder: (_) => RinAiScreen(name: widget.name, gender: widget.gender)));
        } else {
          setState(() => _bottomNavIndex = index);
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 24, color: color),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
