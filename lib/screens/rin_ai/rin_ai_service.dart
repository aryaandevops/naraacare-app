/// UI-phase service abstraction for Rin AI.
///
/// Later, this class can call your backend, and the backend can securely call
/// OpenAI. Do not put an OpenAI API key in the Flutter app.
class RinAiService {
  Future<String> sendMessage(String message) async {
    await Future<void>.delayed(const Duration(milliseconds: 450));
    final text = message.toLowerCase();

    if (text.contains('dinner') || text.contains('eat')) {
      return 'Based on your nutrition today, a high-protein, balanced dinner would be perfect.\n\nHere are some ideas:\n• Dal + roti + curd\n• Paneer with vegetables\n• Moong dal khichdi + salad';
    }
    if (text.contains('water') || text.contains('hydration')) {
      return "You're doing well with hydration today. You're at 1.8 L versus a 2.5 L goal. 💧";
    }
    if (text.contains('sleep') || text.contains('tired')) {
      return 'Your recent sleep looks close to your goal. Try keeping a consistent bedtime and reducing screen time before sleep.';
    }
    if (text.contains('doing') || text.contains('today')) {
      return "You're doing well with hydration today. Your nutrition is slightly low in protein, so adding 30–40 g more today could help.";
    }
    if (text.contains('log')) {
      return 'Sure — I can help you log food, water, or sleep. Tell me what you would like to add.';
    }
    return 'I’m here to help with your hydration, nutrition, sleep, activity, and daily health habits. Tell me what you need.';
  }
}
