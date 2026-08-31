import 'package:flutter/material.dart';
import '../../core/app_state.dart';
import '../../core/theme.dart';
import '../profile/settings/subscription_screens.dart';
import '../profile/care_circles_screen.dart';
import '../profile/profile_screen.dart';
import '../onboarding/gender_name_screen.dart';
import 'rin_ai_service.dart';

class RinAiScreen extends StatelessWidget {
  final String name;
  final Gender gender;

  const RinAiScreen({super.key, required this.name, required this.gender});

  @override
  Widget build(BuildContext context) {
    return AppState.starUnlocked
        ? RinAiChatScreen(name: name, gender: gender)
        : RinAiLockedScreen(name: name, gender: gender);
  }
}

class RinAiLockedScreen extends StatelessWidget {
  final String name;
  final Gender gender;
  const RinAiLockedScreen({super.key, required this.name, required this.gender});

  @override
  Widget build(BuildContext context) {
    return _RinScaffold(
      name: name,
      gender: gender,
      selectedIndex: 2,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 22, 20, 14),
        child: Column(
          children: [
            const SizedBox(height: 8),
            const Icon(Icons.auto_awesome_rounded, size: 66, color: AppColors.textDark),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Unlock Rin AI', style: TextStyle(fontSize: 29, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(color: const Color(0xFFF6EEFF), border: Border.all(color: const Color(0xFF8C5BE6)), borderRadius: BorderRadius.circular(5)),
                  child: const Text('STAR', style: TextStyle(fontSize: 10, color: Color(0xFF7A3FD1), fontWeight: FontWeight.w700)),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text('Your personal AI health companion.\nUnderstand your health, take\nguidance and take action.', textAlign: TextAlign.center, style: TextStyle(fontSize: 17, color: Color(0xFF5F5A5A), height: 1.45)),
            const SizedBox(height: 25),
            _benefit(Icons.chat_bubble_outline, Colors.lightBlue, 'Chat & get personalized insights/'),
            _benefit(Icons.alarm_add_outlined, Colors.redAccent, 'Log food, water & sleep by voice/text.'),
            _benefit(Icons.lightbulb_outline, Colors.deepOrange, 'Smart recommendations just for you.'),
            _benefit(Icons.notifications_none, const Color(0xFFE988FF), 'Reflect updates on your avatar.'),
            const SizedBox(height: 22),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SubscriptionListScreen())),
                icon: const Icon(Icons.star, size: 20),
                label: const Text('Upgrade to STAR plan', style: TextStyle(fontSize: 18)),
                style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(76), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _benefit(IconData icon, Color color, String title) => Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFB9D3EA))),
        child: Row(children: [Icon(icon, color: color, size: 29), const SizedBox(width: 18), Expanded(child: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black87)))]),
      );
}

class RinAiChatScreen extends StatefulWidget {
  final String name;
  final Gender gender;
  const RinAiChatScreen({super.key, required this.name, required this.gender});

  @override
  State<RinAiChatScreen> createState() => _RinAiChatScreenState();
}

class _RinAiChatScreenState extends State<RinAiChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final RinAiService _service = RinAiService();
  final List<_ChatMessage> _messages = [];
  bool _sending = false;

  @override
  void initState() {
    super.initState();
    _messages.addAll([
      _ChatMessage.bot('You’re doing well with hydration today. You’re at 1.8 L over 2.5 L goal. 💧'),
      _ChatMessage.bot('Your nutrition is slightly low in protein. You can add 30–40g more today for a balanced day.'),
    ]);
  }

  Future<void> _send(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty || _sending) return;
    _controller.clear();
    setState(() {
      _sending = true;
      _messages.add(_ChatMessage.user(trimmed));
    });
    final reply = await _service.sendMessage(trimmed);
    if (!mounted) return;
    setState(() {
      _messages.add(_ChatMessage.bot(reply));
      _sending = false;
    });
  }

  void _openActions() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(14, 16, 14, 18),
          decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(width: 44, height: 4, decoration: BoxDecoration(color: Colors.grey.shade400, borderRadius: BorderRadius.circular(8))),
            const SizedBox(height: 16),
            _sheetAction(Icons.search, 'Search History', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RinAiSearchScreen()))),
            _sheetAction(Icons.help_outline, 'Help', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RinAiHelpScreen()))),
            _sheetAction(Icons.delete_outline, 'Delete Chat', () { setState(() => _messages.clear()); Navigator.pop(context); }, danger: true),
          ]),
        ),
      ),
    );
  }

  Widget _sheetAction(IconData icon, String title, VoidCallback onTap, {bool danger = false}) => Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(border: Border.all(color: const Color(0xFFB9D3EA)), borderRadius: BorderRadius.circular(12)),
        child: ListTile(onTap: onTap, leading: Icon(icon, color: danger ? Colors.red : const Color(0xFF41525B)), title: Text(title, style: TextStyle(color: danger ? Colors.red : Colors.black87)), trailing: Icon(Icons.chevron_right, color: danger ? Colors.red : const Color(0xFF75828A))),
      );

  @override
  Widget build(BuildContext context) {
    return _RinScaffold(
      name: widget.name,
      gender: widget.gender,
      selectedIndex: 2,
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
          child: Row(children: [const Text('Rin AI', style: TextStyle(fontSize: 23, color: AppColors.textDark)), const Spacer(), GestureDetector(onTap: _openActions, child: Container(width: 40, height: 40, decoration: const BoxDecoration(color: Color(0xFFF1F3F6), shape: BoxShape.circle), child: const Icon(Icons.more_vert))) ]),
        ),
        Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5), decoration: BoxDecoration(color: const Color(0xFFF1EAFE), borderRadius: BorderRadius.circular(16)), child: const Text('Today', style: TextStyle(color: Color(0xFF6F7980), fontSize: 12))),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
            itemCount: _messages.length + (_sending ? 1 : 0),
            itemBuilder: (_, i) {
              if (_sending && i == _messages.length) return _typing();
              final m = _messages[i];
              return Align(
                alignment: m.isUser ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * .70),
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(color: m.isUser ? AppColors.primaryBlue : Colors.white, border: m.isUser ? null : Border.all(color: const Color(0xFFD7E0E7)), borderRadius: BorderRadius.only(topLeft: const Radius.circular(18), topRight: const Radius.circular(18), bottomLeft: Radius.circular(m.isUser ? 18 : 4), bottomRight: Radius.circular(m.isUser ? 4 : 18))),
                  child: Text(m.text, style: TextStyle(color: m.isUser ? Colors.white : const Color(0xFF4A565F), fontSize: 15, height: 1.4)),
                ),
              );
            },
          ),
        ),
        _composer(),
      ]),
    );
  }

  Widget _typing() => Align(alignment: Alignment.centerLeft, child: Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), margin: const EdgeInsets.only(bottom: 8), decoration: BoxDecoration(color: Colors.white, border: Border.all(color: const Color(0xFFD7E0E7)), borderRadius: BorderRadius.circular(18)), child: const Text('Rin is thinking…', style: TextStyle(color: Color(0xFF7A8790)))));

  Widget _composer() => SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(28, 4, 28, 10),
          child: Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: .08), blurRadius: 14, offset: const Offset(0, 4))]),
            child: Row(children: [Expanded(child: TextField(controller: _controller, onSubmitted: _send, decoration: const InputDecoration(hintText: 'Type here..', border: InputBorder.none))), IconButton(onPressed: () {}, icon: const Icon(Icons.mic_none, color: Color(0xFF5E737E))), IconButton(onPressed: () => _send(_controller.text), icon: const Icon(Icons.send_outlined, color: AppColors.primaryBlue))]),
          ),
        ),
      );
}

class RinAiSearchScreen extends StatefulWidget { const RinAiSearchScreen({super.key}); @override State<RinAiSearchScreen> createState()=>_RinAiSearchScreenState(); }
class _RinAiSearchScreenState extends State<RinAiSearchScreen>{final c=TextEditingController();final recents=['dinner suggestions','meal update','water level','sleep and stress','yesterday'];final conversations=['How am I doing today?','Dinner suggestion','Logged lunch','Protein intake'];String q='';@override Widget build(BuildContext context)=>Scaffold(backgroundColor:Colors.white,body:SafeArea(child:Column(children:[_bar(context,'Search in Rin AI'),Padding(padding:const EdgeInsets.fromLTRB(20,8,20,0),child:TextField(controller:c,onChanged:(v)=>setState(()=>q=v.toLowerCase()),decoration:InputDecoration(hintText:'Search conversations',prefixIcon:const Icon(Icons.search),border:OutlineInputBorder(borderRadius:BorderRadius.circular(12))))),const SizedBox(height:26),_section('RECENT SEARCHES'),Padding(padding:const EdgeInsets.symmetric(horizontal:20),child:Wrap(spacing:6,runSpacing:6,children:recents.map((e)=>_chip(e)).toList())),const SizedBox(height:24),_section('CONVERSATIONS'),Expanded(child:ListView(padding:const EdgeInsets.fromLTRB(20,4,20,20),children:conversations.where((e)=>q.isEmpty||e.toLowerCase().contains(q)).map((e)=>Container(margin:const EdgeInsets.only(bottom:10),padding:const EdgeInsets.all(16),decoration:BoxDecoration(border:Border.all(color:const Color(0xFFB9D3EA)),borderRadius:BorderRadius.circular(12)),child:Row(children:[Expanded(child:Text(e)),const Text('Yesterday',style:TextStyle(fontSize:11,color:Color(0xFF798A93)))]))).toList()) )])));Widget _section(String s)=>Align(alignment:Alignment.centerLeft,child:Padding(padding:const EdgeInsets.symmetric(horizontal:20),child:Text(s,style:const TextStyle(color:Color(0xFF708795),fontSize:13,fontWeight:FontWeight.w600))));Widget _chip(String s)=>Container(padding:const EdgeInsets.symmetric(horizontal:12,vertical:8),decoration:BoxDecoration(color:Colors.white,border:Border.all(color:const Color(0xFFB9DFFF)),borderRadius:BorderRadius.circular(18)),child:Text(s,style:const TextStyle(color:AppColors.primaryBlue,fontSize:12)));Widget _bar(BuildContext c,String t)=>Padding(padding:const EdgeInsets.fromLTRB(10,12,20,0),child:Row(children:[IconButton(onPressed:()=>Navigator.pop(c),icon:const Icon(Icons.close_rounded)),Expanded(child:Center(child:Text(t,style:const TextStyle(fontSize:17,fontWeight:FontWeight.w600,color:AppColors.textDark)))),const SizedBox(width:48)]));}

class RinAiHelpScreen extends StatelessWidget { const RinAiHelpScreen({super.key}); @override Widget build(BuildContext context)=>Scaffold(backgroundColor:Colors.white,body:SafeArea(child:Column(children:[_bar(context,'Rin AI help'),const SizedBox(height:54),const Text('About Rin AI',style:TextStyle(fontSize:28,fontWeight:FontWeight.w700,color:AppColors.textDark)),const SizedBox(height:22),const Padding(padding:EdgeInsets.symmetric(horizontal:42),child:Text('Rin is your AI health companion. It understands your health data and helps you make better choices everyday.',textAlign:TextAlign.center,style:TextStyle(fontSize:16,color:Color(0xFF625E5E),height:1.45))),const SizedBox(height:24),_benefit(Icons.chat_bubble_outline,Colors.lightBlue,'Chat & get personalized insights/'),_benefit(Icons.alarm_add_outlined,Colors.redAccent,'Log food, water & sleep by voice/text.'),_benefit(Icons.lightbulb_outline,Colors.deepOrange,'Smart recommendations just for you.'),_benefit(Icons.notifications_none,const Color(0xFFE988FF),'Reflect updates on your avatar.'),const SizedBox(height:16),Container(margin:const EdgeInsets.symmetric(horizontal:28),padding:const EdgeInsets.all(16),decoration:BoxDecoration(color:const Color(0xFFEFF3FF),borderRadius:BorderRadius.circular(14)),child:const Text('ⓘ  Rin AI is a support tool, not substitute for professional medical advice.',style:TextStyle(color:Color(0xFF59676F),fontSize:15,height:1.45)))])));Widget _benefit(IconData i,Color c,String t)=>Container(margin:const EdgeInsets.fromLTRB(20,0,20,8),padding:const EdgeInsets.symmetric(horizontal:20,vertical:14),decoration:BoxDecoration(border:Border.all(color:const Color(0xFFB9D3EA)),borderRadius:BorderRadius.circular(12)),child:Row(children:[Icon(i,color:c,size:28),const SizedBox(width:18),Expanded(child:Text(t,style:const TextStyle(fontSize:14.5)))]));Widget _bar(BuildContext c,String t)=>Padding(padding:const EdgeInsets.fromLTRB(10,12,20,0),child:Row(children:[IconButton(onPressed:()=>Navigator.pop(c),icon:const Icon(Icons.close_rounded)),Expanded(child:Center(child:Text(t,style:const TextStyle(fontSize:17,fontWeight:FontWeight.w600,color:AppColors.textDark)))),const SizedBox(width:48)]));}

class _RinScaffold extends StatelessWidget {
  final Widget child; final String name; final Gender gender; final int selectedIndex;
  const _RinScaffold({required this.child, required this.name, required this.gender, required this.selectedIndex});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(child: child),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          height: 66,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: .08), blurRadius: 8, offset: const Offset(0, -2))],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _item(context, Icons.home_outlined, 'Home', 0, () => Navigator.pop(context)),
              _item(context, Icons.groups_outlined, 'Care Circle', 1, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CareCirclesScreen()))),
              _item(context, Icons.auto_awesome_outlined, 'Rin AI', 2, () => Navigator.pop(context)),
              _item(context, Icons.person_outline, 'Profile', 3, () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileScreen(name: name, gender: gender)))),
            ],
          ),
        ),
      ),
    );
  }
  Widget _item(BuildContext context,IconData i,String label,int idx,VoidCallback tap){final selected=idx==selectedIndex;final color=selected?AppColors.primaryBlue:const Color(0xFF56636B);return GestureDetector(onTap:tap,child:Column(mainAxisAlignment:MainAxisAlignment.center,children:[Icon(i,size:25,color:color),const SizedBox(height:2),Text(label,style:TextStyle(fontSize:10,color:color,fontWeight:selected?FontWeight.w600:FontWeight.w500))]));}
}

class _ChatMessage { final String text; final bool isUser; const _ChatMessage.bot(this.text):isUser=false; const _ChatMessage.user(this.text):isUser=true; }
