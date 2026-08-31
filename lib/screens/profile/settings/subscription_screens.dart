import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../core/app_state.dart';

class SubscriptionListScreen extends StatefulWidget {
  const SubscriptionListScreen({super.key});
  @override
  State<SubscriptionListScreen> createState() => _SubscriptionListScreenState();
}

class _SubscriptionListScreenState extends State<SubscriptionListScreen> {
  bool yearly = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _bar(context, 'My Subscriptions'),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
                children: [
                  _billingToggle(),
                  const SizedBox(height: 28),
                  _planCard(
                    context,
                    'STANDARD',
                    '₹0',
                    '/ month',
                    true,
                    const [
                      'Hydration & Nutrition tracking',
                      'Care Circle',
                      'Basic health reports',
                      '4 meal logs/day',
                      '30 day free STAR plan with referral program',
                      'Ticket Support',
                    ],
                    false,
                  ),
                  const SizedBox(height: 16),
                  _planCard(
                    context,
                    'STAR',
                    yearly ? '₹949' : '₹99',
                    yearly ? '/ year' : '/ month',
                    false,
                    const [
                      'Everything in Standard',
                      'Advanced insights & trends',
                      'Rin AI',
                      'Custom health reports',
                      '8 meal logs/day',
                      'Sleep Avatar unlocked',
                      'Voice input available',
                      'Priority support',
                      '50 day free STAR plan with referral program',
                    ],
                    true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _billingToggle() {
    return Center(
      child: Container(
        width: 270,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(color: const Color(0xFFF2F3F7), borderRadius: BorderRadius.circular(24)),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => yearly = false),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(color: !yearly ? AppColors.primaryBlue : Colors.transparent, borderRadius: BorderRadius.circular(22)),
                  alignment: Alignment.center,
                  child: const Text('Monthly', style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => yearly = true),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  alignment: Alignment.center,
                  child: const Text('Yearly  SAVE 20%', style: TextStyle(color: Color(0xFF5B6D79), fontSize: 12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _planCard(BuildContext context, String title, String price, String suffix, bool active, List<String> points, bool starPlan) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 22, 24, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: starPlan ? const Color(0xFF6F45A9) : const Color(0xFFBAC9D8), width: starPlan ? 2 : 1),
        boxShadow: starPlan ? [BoxShadow(color: Colors.black.withValues(alpha: .08), blurRadius: 12)] : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(title, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: starPlan ? const Color(0xFF6F45A9) : AppColors.primaryBlue, letterSpacing: 1)),
              const Spacer(),
              if (active) _badge('Active'),
              if (starPlan) ...[
                if (active) const SizedBox(width: 6),
                _badge('RECOMMENDED', purple: true),
              ],
            ],
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(price, style: TextStyle(fontSize: 30, color: starPlan ? const Color(0xFF6F45A9) : AppColors.textDark, fontWeight: FontWeight.w500)),
              Text(suffix, style: const TextStyle(fontSize: 14, color: Color(0xFF71838C))),
            ],
          ),
          const SizedBox(height: 14),
          ...points.map((p) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.check_circle_outline, color: AppColors.primaryBlue, size: 19),
                    const SizedBox(width: 10),
                    Expanded(child: Text(p, style: const TextStyle(fontSize: 14, color: Color(0xFF4F5D66)))),
                  ],
                ),
              )),
          if (active)
            Container(
              height: 54,
              decoration: BoxDecoration(color: const Color(0xFFEFEFF1), borderRadius: BorderRadius.circular(12)),
              alignment: Alignment.center,
              child: const Text('Your Current Plan', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF61666B))),
            )
          else
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6F45A9)),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => UpgradeStarScreen(yearly: yearly))),
                child: const Text('Upgrade to STAR'),
              ),
            ),
        ],
      ),
    );
  }

  Widget _badge(String text, {bool purple = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: purple ? const Color(0xFF6F45A9) : const Color(0xFF13A36F)),
        color: purple ? const Color(0xFF6F45A9) : Colors.white,
      ),
      child: Text(text, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: purple ? Colors.white : const Color(0xFF13A36F))),
    );
  }

  Widget _bar(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      child: Row(
        children: [
          IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_ios_new)),
          Expanded(child: Center(child: Text(title, style: const TextStyle(fontSize: 24, color: AppColors.textDark)))),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}

class UpgradeStarScreen extends StatelessWidget {
  final bool yearly;
  const UpgradeStarScreen({super.key, this.yearly = false});

  @override
  Widget build(BuildContext context) {
    final price = yearly ? '₹949' : '₹99';
    final suffix = yearly ? '/ year' : '/month';
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _bar(context, 'Upgrade to STAR'),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [Color(0xFF9C7BFF), Color(0xFF6250ED)]),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('STAR Plan', style: TextStyle(color: Colors.white, fontSize: 18)),
                          const SizedBox(height: 8),
                          Text(price, style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w600)),
                          Text(suffix, style: const TextStyle(color: Colors.white, fontSize: 14)),
                          const SizedBox(height: 10),
                          const Text('First 100 users', style: TextStyle(color: Colors.white70)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 38),
                    const Text('Billing Cycle', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 14),
                    _billing('Monthly', '₹99 / mo', true),
                    const SizedBox(height: 8),
                    _info('Starts today', '11 June 2026'),
                    const SizedBox(height: 8),
                    _info('Renews on', yearly ? '11 June 2027' : '11 July 2026'),
                    const SizedBox(height: 8),
                    _info('Payment via', 'App Store / Google Play'),
                    const SizedBox(height: 8),
                    _billing('Yearly', '₹949 / year', false),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: const Color(0xFFEFF3FF), borderRadius: BorderRadius.circular(14)),
                      child: const Text("You'll be charged through your Apple App Store/ Google Play account. You can manage or cancel anytime.", style: TextStyle(fontSize: 15, color: Color(0xFF566670))),
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: SizedBox(
                        width: 212,
                        child: ElevatedButton(
                          onPressed: () {
                            AppState.starUnlocked = true;
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => SubscriptionSuccessScreen(yearly: yearly)));
                          },
                          child: const Text('Confirm & Subscribe'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _billing(String title, String price, bool selected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: selected ? Colors.blue : const Color(0xFFE0E5EA), width: selected ? 2 : 1)),
      child: Row(
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)), Text(price, style: const TextStyle(color: Color(0xFF6D7A82)))]),
          const Spacer(),
          Icon(selected ? Icons.radio_button_checked : Icons.radio_button_unchecked, color: selected ? Colors.blue : const Color(0xFFB8C2CC), size: 28),
        ],
      ),
    );
  }

  Widget _info(String label, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFFEAEFF4))),
      child: Row(children: [Text(label, style: const TextStyle(color: Color(0xFF6D7A82))), const Spacer(), Text(value, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF44515A)))]),
    );
  }

  Widget _bar(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      child: Row(children: [IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_ios_new)), Expanded(child: Center(child: Text(title, style: const TextStyle(fontSize: 24, color: AppColors.textDark)))), const SizedBox(width: 48)]),
    );
  }
}

class SubscriptionSuccessScreen extends StatelessWidget {
  final bool yearly;
  const SubscriptionSuccessScreen({super.key, this.yearly = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            const Icon(Icons.verified_outlined, color: Color(0xFF0FA675), size: 100),
            const SizedBox(height: 30),
            const Text("You're now on\nSTAR plan.", textAlign: TextAlign.center, style: TextStyle(fontSize: 34, fontWeight: FontWeight.w600, color: AppColors.textDark)),
            const SizedBox(height: 10),
            const Text('Your health journey just got a\nmajor upgrade.', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Color(0xFF6D7F89))),
            const SizedBox(height: 38),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: .06), blurRadius: 14)]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(children: [Text('CURRENT PLAN', style: TextStyle(fontSize: 12, color: Color(0xFF66737A))), Spacer(), Text('Active', style: TextStyle(color: Color(0xFF0FA675), fontWeight: FontWeight.w700))]),
                  const SizedBox(height: 8),
                  const Text('STAR Plan', style: TextStyle(fontSize: 18)),
                  const Divider(height: 28),
                  const Text('Annual Price', style: TextStyle(color: Color(0xFF6D7F89))),
                  const SizedBox(height: 6),
                  Text(yearly ? '₹949 / year' : '₹99 / month', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 14),
                  const Text('Next billing date', style: TextStyle(color: Color(0xFF6D7F89))),
                  const SizedBox(height: 6),
                  const Text('11 June 2026', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 14),
                  const Text('Auto-renewal     On', style: TextStyle(fontSize: 14, color: Color(0xFF4F5D66))),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(width: 212, child: ElevatedButton(onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ActiveSubscriptionScreen())), child: const Text('Go to My Subscriptions'))),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class ActiveSubscriptionScreen extends StatelessWidget {
  const ActiveSubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _bar(context, 'My Subscriptions'),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 22, 20, 30),
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF5A3FF0), Color(0xFF7B35EC)]), borderRadius: BorderRadius.circular(14)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Current Plan', style: TextStyle(color: Colors.white70)), SizedBox(height: 4), Text('STAR Plan', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600))]),
                            const Spacer(),
                            Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)), child: const Text('Active', style: TextStyle(color: Color(0xFF09A46D), fontWeight: FontWeight.w700))),
                          ],
                        ),
                        const SizedBox(height: 18),
                        const Text('₹949 / year', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w600)),
                        const Divider(color: Colors.white38, height: 28),
                        Row(
                          children: [
                            const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Next billing date', style: TextStyle(color: Colors.white70)), SizedBox(height: 4), Text('11 June 2026', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600))]),
                            const Spacer(),
                            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [const Text('Auto-renewal', style: TextStyle(color: Colors.white70)), const SizedBox(height: 4), Switch(value: true, onChanged: null, activeColor: Colors.white, activeTrackColor: Colors.lightBlueAccent)]),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 44),
                  const Text('Your Plan Includes:', style: TextStyle(color: Color(0xFF8AA3B2))),
                  const SizedBox(height: 10),
                  _featureList(),
                  const SizedBox(height: 44),
                  const Text('Actions', style: TextStyle(color: Color(0xFF8AA3B2))),
                  const SizedBox(height: 10),
                  _action(context, Icons.history, 'Billing History', false, () {}),
                  _action(context, Icons.credit_card, 'Update Payment Method', false, () {}),
                  _action(context, Icons.cancel_outlined, 'Cancel Subscription', true, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CancelSubscriptionScreen()))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _featureList() {
    const features = [
      'Everything in Standard',
      'Advanced insights & trends',
      'Rin AI',
      'Custom health reports',
      '8 meal logs/day',
      'Sleep Avatar unlocked',
      'Voice input available',
      'Priority support',
      '50 day free STAR plan with referral program',
    ];
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE0E6EC))),
      child: Column(
        children: features.map((x) => Padding(padding: const EdgeInsets.only(bottom: 14), child: Row(children: [const Icon(Icons.check_circle_outline, color: AppColors.primaryBlue, size: 19), const SizedBox(width: 10), Expanded(child: Text(x, style: const TextStyle(fontSize: 14, color: Color(0xFF4F5D66))))]))).toList(),
      ),
    );
  }

  Widget _action(BuildContext context, IconData icon, String title, bool danger, VoidCallback onTap) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: danger ? const Color(0xFFD1264D) : const Color(0xFF40505A)),
      title: Text(title, style: TextStyle(color: danger ? const Color(0xFFD1264D) : const Color(0xFF40505A))),
      trailing: Icon(Icons.chevron_right, color: danger ? const Color(0xFFD1264D) : const Color(0xFF7B858B)),
    );
  }

  Widget _bar(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      child: Row(children: [IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_ios_new)), Expanded(child: Center(child: Text(title, style: const TextStyle(fontSize: 24, color: AppColors.textDark)))), const SizedBox(width: 48)]),
    );
  }
}

class CancelSubscriptionScreen extends StatelessWidget {
  const CancelSubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _bar(context, 'Cancel Subscription'),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF5A3FF0), Color(0xFF7B35EC)]), borderRadius: BorderRadius.circular(14)),
                    child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Current Plan', style: TextStyle(color: Colors.white70)), SizedBox(height: 4), Text('STAR Plan', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600)), SizedBox(height: 20), Text('₹949 / year', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w600)), Divider(color: Colors.white38, height: 28), Text('Next billing date: 11 June 2026', style: TextStyle(color: Colors.white70))]),
                  ),
                  const SizedBox(height: 36),
                  const Text('If you cancel:', style: TextStyle(color: Color(0xFF8AA3B2))),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE0E6EC))),
                    child: Column(children: [_line('You will have access till 11th June 2026.'), _line('Auto renewal will be turned off.'), _line("You won’t be charged again.")]),
                  ),
                  const SizedBox(height: 22),
                  Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: const Color(0xFFEFF3FF), borderRadius: BorderRadius.circular(14)), child: const Text('You can upgrade back to STAR anytime if you change your mind.', style: TextStyle(fontSize: 16, color: Color(0xFF566670), height: 1.45))),
                  const SizedBox(height: 34),
                  Center(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(foregroundColor: const Color(0xFFD1264D), side: const BorderSide(color: Color(0xFFD1264D)), padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14)),
                      onPressed: () {
                        AppState.starUnlocked = false;
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const SubscriptionCancelledScreen()));
                      },
                      child: const Text('Cancel Subscription'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(child: TextButton(onPressed: () => Navigator.pop(context), child: const Text('Stay on STAR', style: TextStyle(decoration: TextDecoration.underline, color: AppColors.textDark)))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _line(String text) => Padding(padding: const EdgeInsets.only(bottom: 16), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [const Icon(Icons.check_circle_outline, color: AppColors.primaryBlue, size: 18), const SizedBox(width: 10), Expanded(child: Text(text, style: const TextStyle(fontSize: 14, color: Color(0xFF4F5D66))))]));
  Widget _bar(BuildContext context, String title) => Padding(padding: const EdgeInsets.fromLTRB(20, 8, 20, 0), child: Row(children: [IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_ios_new)), Expanded(child: Center(child: Text(title, style: const TextStyle(fontSize: 24, color: AppColors.textDark)))), const SizedBox(width: 48)]));
}

class SubscriptionCancelledScreen extends StatelessWidget {
  const SubscriptionCancelledScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            const Icon(Icons.block_outlined, color: Color(0xFFD1264D), size: 100),
            const SizedBox(height: 34),
            const Text('Subscription\nCancelled', textAlign: TextAlign.center, style: TextStyle(fontSize: 34, fontWeight: FontWeight.w600, color: AppColors.textDark)),
            const SizedBox(height: 10),
            const Text('Your STAR plan subscription\nhas been cancelled.', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Color(0xFF6D7F89))),
            const SizedBox(height: 56),
            Container(margin: const EdgeInsets.symmetric(horizontal: 20), padding: const EdgeInsets.all(18), decoration: BoxDecoration(color: const Color(0xFFEFF3FF), borderRadius: BorderRadius.circular(14)), child: const Text('You have access to STAR plan features till 11th June 2026. After that you will be moved to STANDARD plan.', style: TextStyle(fontSize: 16, color: Color(0xFF566670), height: 1.45))),
            const Spacer(),
            SizedBox(width: 212, child: ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Go to My Subscriptions'))),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
