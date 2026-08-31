class SleepEntry {
  final int sleepHour;
  final int sleepMinute;
  final bool sleepPm;
  final int wakeHour;
  final int wakeMinute;
  final bool wakePm;

  const SleepEntry({
    required this.sleepHour,
    required this.sleepMinute,
    required this.sleepPm,
    required this.wakeHour,
    required this.wakeMinute,
    required this.wakePm,
  });

  Duration get duration {
    int toMinutes(int hour, int minute, bool pm) {
      var h = hour % 12;
      if (pm) h += 12;
      return h * 60 + minute;
    }

    var start = toMinutes(sleepHour, sleepMinute, sleepPm);
    var end = toMinutes(wakeHour, wakeMinute, wakePm);
    if (end <= start) end += 24 * 60;
    return Duration(minutes: end - start);
  }

  int get goalMinutes => 8 * 60;

  int get score {
    final diff = (duration.inMinutes - goalMinutes).abs();
    return (100 - (diff / goalMinutes * 100)).round().clamp(0, 100).toInt();
  }

  String get durationLabel {
    final h = duration.inHours;
    final m = duration.inMinutes % 60;
    return '${h}h ${m.toString().padLeft(2, '0')}m';
  }

  String formatTime(int hour, int minute, bool pm) =>
      '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} ${pm ? 'PM' : 'AM'}';

  String get sleepTimeLabel => formatTime(sleepHour, sleepMinute, sleepPm);
  String get wakeTimeLabel => formatTime(wakeHour, wakeMinute, wakePm);
}
