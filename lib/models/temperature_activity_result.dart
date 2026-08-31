enum GymIntensity { low, moderate, high }

String gymIntensityLabel(GymIntensity intensity) {
  switch (intensity) {
    case GymIntensity.low:
      return 'Low';
    case GymIntensity.moderate:
      return 'Moderate';
    case GymIntensity.high:
      return 'High';
  }
}

class TemperatureActivityResult {
  final int temperatureCelsius;
  final GymIntensity intensity;
  final int durationMinutes;

  const TemperatureActivityResult({
    required this.temperatureCelsius,
    required this.intensity,
    required this.durationMinutes,
  });
}
