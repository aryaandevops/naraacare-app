import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../models/temperature_activity_result.dart';

/// Lets the user set today's temperature and gym activity. Saving this
/// is what keeps water tracking on Home "unlocked" — see the 24h-disable
/// rule in home_screen.dart, which reads the timestamp of the last save here.
class TemperatureActivityScreen extends StatefulWidget {
  final int initialTemperatureCelsius;
  final GymIntensity? initialIntensity;
  final int? initialDurationMinutes;

  const TemperatureActivityScreen({
    super.key,
    this.initialTemperatureCelsius = 22,
    this.initialIntensity,
    this.initialDurationMinutes,
  });

  @override
  State<TemperatureActivityScreen> createState() => _TemperatureActivityScreenState();
}

class _TemperatureActivityScreenState extends State<TemperatureActivityScreen> {
  static const int _minC = -10;
  static const int _maxC = 50;

  late int _temperatureCelsius = widget.initialTemperatureCelsius.clamp(_minC, _maxC);
  bool _isFahrenheit = false;
  GymIntensity? _selectedIntensity;
  late final _durationController =
      TextEditingController(text: widget.initialDurationMinutes?.toString() ?? '');
  late final FixedExtentScrollController _wheelController;

  @override
  void initState() {
    super.initState();
    _selectedIntensity = widget.initialIntensity;
    _wheelController = FixedExtentScrollController(
      initialItem: _temperatureCelsius - _minC,
    );
  }

  @override
  void dispose() {
    _durationController.dispose();
    _wheelController.dispose();
    super.dispose();
  }

  bool get _isFormValid =>
      _selectedIntensity != null && (int.tryParse(_durationController.text.trim()) ?? 0) > 0;

  String _tempLabel(int celsius) {
    if (_isFahrenheit) {
      final f = (celsius * 9 / 5 + 32).round();
      return '$f';
    }
    return '$celsius';
  }

  void _submit() {
    final duration = int.tryParse(_durationController.text.trim());
    if (_selectedIntensity == null || duration == null || duration <= 0) return;
    Navigator.of(context).pop(
      TemperatureActivityResult(
        temperatureCelsius: _temperatureCelsius,
        intensity: _selectedIntensity!,
        durationMinutes: duration,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey.shade400),
                      ),
                      child: const Icon(Icons.close, size: 18),
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      'Temperature & Activity',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(width: 32),
                ],
              ),
              const SizedBox(height: 24),

              Row(
                children: [
                  const Icon(Icons.thermostat, size: 18, color: AppColors.textDark),
                  const SizedBox(width: 6),
                  const Text('Current Temperature', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => setState(() => _isFahrenheit = !_isFahrenheit),
                    child: Text(
                      _isFahrenheit ? '°C' : '°F',
                      style: TextStyle(fontSize: 13, color: AppColors.textGrey, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Temperature wheel picker
              Container(
                height: 180,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.yellow.shade50, Colors.blue.shade50],
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 44,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlue.withValues(alpha: 0.85),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    ListWheelScrollView.useDelegate(
                      controller: _wheelController,
                      itemExtent: 44,
                      diameterRatio: 1.6,
                      physics: const FixedExtentScrollPhysics(),
                      onSelectedItemChanged: (index) {
                        setState(() => _temperatureCelsius = _minC + index);
                      },
                      childDelegate: ListWheelChildBuilderDelegate(
                        childCount: _maxC - _minC + 1,
                        builder: (context, index) {
                          final celsius = _minC + index;
                          final isSelected = celsius == _temperatureCelsius;
                          return Center(
                            child: Text(
                              _tempLabel(celsius),
                              style: TextStyle(
                                fontSize: isSelected ? 20 : 15,
                                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w400,
                                color: isSelected ? Colors.white : Colors.black45,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Positioned(
                      right: 20,
                      child: Text(
                        _isFahrenheit ? '°F' : '°C',
                        style: const TextStyle(fontSize: 14, color: AppColors.textGrey, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              Row(
                children: const [
                  Icon(Icons.fitness_center, size: 18, color: AppColors.textDark),
                  SizedBox(width: 6),
                  Text('Gym Activity', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                ],
              ),
              const SizedBox(height: 12),
              const Text('Intensity Level', style: TextStyle(fontSize: 13, color: AppColors.textGrey)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: GymIntensity.values.map((level) {
                  final isSelected = _selectedIntensity == level;
                  return ChoiceChip(
                    label: Text(gymIntensityLabel(level)),
                    selected: isSelected,
                    onSelected: (_) => setState(() => _selectedIntensity = level),
                    selectedColor: AppColors.lightBlue,
                    labelStyle: TextStyle(
                      color: isSelected ? AppColors.primaryBlue : AppColors.textGrey,
                      fontWeight: FontWeight.w600,
                    ),
                    backgroundColor: Colors.white,
                    side: BorderSide(color: Colors.grey.shade300),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              const Text('Duration', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
              const SizedBox(height: 10),
              TextField(
                controller: _durationController,
                keyboardType: TextInputType.number,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Enter gym duration',
                  suffixText: 'min',
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColors.primaryBlue),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [15, 30, 45, 60].map((min) {
                  final isSelected = _durationController.text.trim() == min.toString();
                  return ChoiceChip(
                    label: Text('$min min'),
                    selected: isSelected,
                    onSelected: (_) => setState(() => _durationController.text = min.toString()),
                    selectedColor: AppColors.lightBlue,
                    labelStyle: TextStyle(
                      color: isSelected ? AppColors.primaryBlue : AppColors.textGrey,
                      fontWeight: FontWeight.w600,
                    ),
                    backgroundColor: Colors.white,
                    side: BorderSide(color: Colors.grey.shade300),
                  );
                }).toList(),
              ),
              const SizedBox(height: 28),

              ElevatedButton(
                onPressed: _isFormValid ? _submit : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  disabledBackgroundColor: AppColors.lightBlue,
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text('Save Details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
