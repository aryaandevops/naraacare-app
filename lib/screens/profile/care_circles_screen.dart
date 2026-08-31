import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../core/app_state.dart';
import '../home/home_screen.dart';
import '../onboarding/gender_name_screen.dart';
import '../rin_ai/rin_ai_screen.dart';
import 'profile_screen.dart';

class CareCirclesScreen extends StatefulWidget {
  const CareCirclesScreen({super.key});
  @override State<CareCirclesScreen> createState() => _CareCirclesScreenState();
}

class _CareCirclesScreenState extends State<CareCirclesScreen> {
  bool hasUsername = true;
  final circles = <_Circle>[const _Circle('Best Friends', 3, 0), const _Circle('Family', 4, 2)];
  final connections = <_Person>[const _Person('@aara_sharma', 'Last active today'), const _Person('@aara_sharma1', 'Last active yesterday'), const _Person('@aara_sharma12', 'Last active 3 days ago'), const _Person('@aarasharma.1', 'Last active 1 week ago'), const _Person('@aaraaaa123_sharma', 'Last active 1 month ago')];

  Future<void> createCircle() async {
    if (!hasUsername) {
      final ok = await showModalBottomSheet<bool>(context: context, builder: (_) => const SizedBox(height: 250, child: Center(child: Text('Create your NaraaCare username'))));
      if (ok != true || !mounted) return;
      hasUsername = true;
    }
    final circle = await Navigator.push<_Circle>(context, MaterialPageRoute(builder: (_) => CreateCircleScreen(existingConnections: connections)));
    if (circle != null && mounted) setState(() => circles.add(circle));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 26, 20, 16),
              child: Row(children: [
                const Expanded(child: Text('Your Circles', style: TextStyle(fontSize: 24, color: AppColors.textDark))),
                GestureDetector(onTap: createCircle, child: Container(width: 30, height: 30, decoration: const BoxDecoration(shape: BoxShape.circle, border: Border.fromBorderSide(BorderSide(color: AppColors.textDark, width: 2))), child: const Icon(Icons.add))),
              ]),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                children: [
                  Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: const Color(0xFFF0F5FF), borderRadius: BorderRadius.circular(12)), child: const Text('Create a Care Circle\nInvite friends and family to share avatars and support each other', style: TextStyle(fontSize: 15, height: 1.4))),
                  const SizedBox(height: 30),
                  ...circles.map((circle) => Padding(padding: const EdgeInsets.only(bottom: 10), child: GestureDetector(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CircleDetailScreen(circle: circle))), child: Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: .06), blurRadius: 14)]), child: Row(children: [Container(width: 40, height: 40, decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), gradient: const LinearGradient(colors: [Color(0xFFFFB35B), Color(0xFFB4D957), Color(0xFF33AEEB)]))), const SizedBox(width: 16), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(circle.name, style: const TextStyle(fontSize: 18)), const SizedBox(height: 4), Text('${circle.members} members • ${circle.updates == 0 ? 'No new updates' : '${circle.updates} updates today'}', style: const TextStyle(color: Color(0xFF7A8A93)))])), if (circle.updates > 0) CircleAvatar(radius: 10, backgroundColor: AppColors.primaryBlue, child: Text('${circle.updates}', style: const TextStyle(fontSize: 10, color: Colors.white)))]))))),
                  const SizedBox(height: 25),
                  const Text('Invites', style: TextStyle(fontSize: 18, color: Color(0xFF71838C))),
                  const SizedBox(height: 10),
                  GestureDetector(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CircleInviteScreen(invite: _CircleInvite('Gym Buddies', 5, 'Sahil')))), child: Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: .05), blurRadius: 12)]), child: const Row(children: [CircleAvatar(radius: 20, backgroundColor: Color(0xFFE4E8ED)), SizedBox(width: 16), Text('Gym Buddies', style: TextStyle(fontSize: 18))]))),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const _SubpageBottomNav(),
    );
  }
}

class CreateCircleScreen extends StatefulWidget {
  final List<_Person> existingConnections;
  const CreateCircleScreen({super.key, required this.existingConnections});
  @override State<CreateCircleScreen> createState() => _CreateCircleScreenState();
}
class _CreateCircleScreenState extends State<CreateCircleScreen> {
  final _name = TextEditingController();
  @override void dispose(){_name.dispose();super.dispose();}
  @override Widget build(BuildContext context)=>Scaffold(backgroundColor:Colors.white,body:SafeArea(bottom:false,child:Column(children:[_bar(context,'Create a Circle'),Expanded(child:ListView(padding:const EdgeInsets.fromLTRB(48,54,48,30),children:[Center(child:Container(width:120,height:120,decoration:const BoxDecoration(shape:BoxShape.circle,color:Color(0xFFF3F8FF)),child:const Icon(Icons.groups_outlined,size:82,color:AppColors.primaryBlue))),const SizedBox(height:52),const Text('Circle name',style:TextStyle(fontSize:20,color:AppColors.textDark)),const SizedBox(height:12),TextField(controller:_name,decoration:CareCirclesScreenStyle.input('Enter a care circle name')),const SizedBox(height:8),const Text('You can change this later',style:TextStyle(fontSize:12,color:Color(0xFF7F96A5))),const SizedBox(height:190),ElevatedButton(onPressed:_next,child:const Row(mainAxisAlignment:MainAxisAlignment.center,children:[Text('Add Members'),SizedBox(width:10),Icon(Icons.arrow_forward)]))])),]),),bottomNavigationBar:const _SubpageBottomNav());
  Future<void> _next() async { final n=_name.text.trim(); if(n.isEmpty)return; final members=await Navigator.push<List<_Person>>(context,MaterialPageRoute(builder:(_)=>AddMembersScreen(connections:widget.existingConnections))); if(!mounted||members==null)return; final ok=await Navigator.push<bool>(context,MaterialPageRoute(builder:(_)=>ShareWithCircleScreen(circleName:n,members:members))); if(mounted&&ok==true)Navigator.pop(context,_Circle(n,members.length+1,0)); }
}

class AddMembersScreen extends StatefulWidget { final List<_Person> connections; const AddMembersScreen({super.key,required this.connections}); @override State<AddMembersScreen> createState()=>_AddMembersScreenState(); }
class _AddMembersScreenState extends State<AddMembersScreen>{ int tab=0; final search=TextEditingController(); String q=''; final Set<String> selected={}; @override void dispose(){search.dispose();super.dispose();}
 @override Widget build(BuildContext context)=>Scaffold(backgroundColor:Colors.white,body:SafeArea(bottom:false,child:Column(children:[_bar(context,'Add Members'),SizedBox(height:60,child:Row(children:[_tab('People on NaraaCare',0),_tab('Invite Link',1)])),Padding(padding:const EdgeInsets.fromLTRB(29,42,29,0),child:TextField(controller:search,onChanged:(v)=>setState(()=>q=v.toLowerCase()),decoration:CareCirclesScreenStyle.input('Search by username').copyWith(prefixIcon:const Icon(Icons.search)))),const SizedBox(height:25),Expanded(child:tab==0?_people():_invite()),Padding(padding:const EdgeInsets.fromLTRB(90,0,90,26),child:ElevatedButton(onPressed:()=>Navigator.pop(context,connections(),),child:const Row(mainAxisAlignment:MainAxisAlignment.center,children:[Text('Continue'),SizedBox(width:10),Icon(Icons.arrow_forward)]))) ])),bottomNavigationBar:const _SubpageBottomNav());
 List<_Person> connections()=>widget.connections.where((p)=>selected.contains(p.username)).toList(); Widget _tab(String t,int i)=>Expanded(child:GestureDetector(onTap:()=>setState(()=>tab=i),child:Column(mainAxisAlignment:MainAxisAlignment.end,children:[Text(t,style:TextStyle(color:tab==i?AppColors.primaryBlue:const Color(0xFF6C7E87))),const SizedBox(height:15),Container(height:2,color:tab==i?AppColors.primaryBlue:const Color(0xFFD8E0E4))]))); Widget _people()=>ListView(padding:const EdgeInsets.fromLTRB(28,0,20,20),children:[const Text('CONNECTED ON NARAACARE',style:TextStyle(fontSize:13,color:Color(0xFF586A73))),const SizedBox(height:8),...widget.connections.where((p)=>q.isEmpty||p.username.toLowerCase().contains(q)).map((p)=>_person(p))]); Widget _person(_Person p)=>Padding(padding:const EdgeInsets.symmetric(vertical:8),child:Row(children:[const CircleAvatar(radius:22,backgroundColor:Color(0xFFE5E9ED)),const SizedBox(width:14),Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(p.username,style:const TextStyle(fontSize:16)),Text(p.activity,style:const TextStyle(fontSize:12,color:Color(0xFF7C8D95)))])),IconButton(onPressed:()=>setState(()=>selected.contains(p.username)?selected.remove(p.username):selected.add(p.username)),icon:Icon(selected.contains(p.username)?Icons.verified_outlined:Icons.add_circle_outline,color:selected.contains(p.username)?AppColors.primaryBlue:const Color(0xFF4E5C63),size:31))])); Widget _invite()=>Column(children:[const SizedBox(height:56),const Icon(Icons.link,size:80,color:Color(0xFF52616A)),const SizedBox(height:60),const Text('Invite people on NaraaCare',style:TextStyle(fontSize:19,color:AppColors.primaryBlue)),const SizedBox(height:8),const Padding(padding:EdgeInsets.symmetric(horizontal:40),child:Text('Share this invite link with someone who isn’t on NaraaCare yet and join your circle.',textAlign:TextAlign.center,style:TextStyle(color:Color(0xFF6D7E88)))),const SizedBox(height:28),ElevatedButton(style:ElevatedButton.styleFrom(backgroundColor:const Color(0xFF63747D)),onPressed:()=>ClipboardDemo.share(),child:const Row(mainAxisSize:MainAxisSize.min,children:[Text('Share Invite Link'),SizedBox(width:8),Icon(Icons.link)]))]);
}

class ShareWithCircleScreen extends StatefulWidget { final String circleName; final List<_Person> members; const ShareWithCircleScreen({super.key,required this.circleName,required this.members}); @override State<ShareWithCircleScreen> createState()=>_ShareWithCircleScreenState(); }
class _ShareWithCircleScreenState extends State<ShareWithCircleScreen>{ bool hydration=true,nutrition=true,sleep=false; @override Widget build(BuildContext context){final can=hydration||nutrition||sleep; return Scaffold(backgroundColor:Colors.white,body:SafeArea(bottom:false,child:Column(children:[_bar(context,'Share with ${widget.circleName}'),const SizedBox(height:36),const Text('Choose atleast 1 avatar to share with all\nmembers of this circle.',textAlign:TextAlign.center,style:TextStyle(color:Color(0xFF6B7B84))),const SizedBox(height:22),_switch('💧','Hydration',hydration,(v)=>setState(()=>hydration=v)),_switch('🍽️','Nutrition',nutrition,(v)=>setState(()=>nutrition=v)),_switch('😴','Sleep',sleep,(v)=>setState(()=>sleep=v),locked:true),const SizedBox(height:12),Container(margin:const EdgeInsets.symmetric(horizontal:28),padding:const EdgeInsets.all(16),decoration:BoxDecoration(color:const Color(0xFFF7F0FF),borderRadius:BorderRadius.circular(14)),child:const Text('★ Why STAR?\nSTAR members can share and view sleep insights with their care circles.')),const SizedBox(height:12),Container(margin:const EdgeInsets.symmetric(horizontal:28),padding:const EdgeInsets.all(16),decoration:BoxDecoration(color:const Color(0xFFEFF3FF),borderRadius:BorderRadius.circular(12)),child:const Text('ⓘ  You can change these anytime from the circle Settings.')),const Spacer(),SizedBox(width:212,child:ElevatedButton(onPressed:can?()=>Navigator.pop(context,true):null,child:const Text('Create Circle'))),const SizedBox(height:24)])),bottomNavigationBar:const _SubpageBottomNav()); }
 Widget _switch(String icon,String title,bool value,ValueChanged<bool> onChanged,{bool locked=false})=>Padding(padding:const EdgeInsets.symmetric(horizontal:28,vertical:7),child:Row(children:[Text(icon,style:const TextStyle(fontSize:25)),const SizedBox(width:10),Expanded(child:Text(title,style:const TextStyle(fontSize:18,color:AppColors.textDark))),Switch(value:value,onChanged:locked?null:onChanged,activeColor:Colors.white,activeTrackColor:AppColors.primaryBlue)])); }

class CircleDetailScreen extends StatelessWidget { final _Circle circle; const CircleDetailScreen({super.key,required this.circle}); @override Widget build(BuildContext context)=>Scaffold(backgroundColor:Colors.white,body:SafeArea(bottom:false,child:Column(children:[Padding(padding:const EdgeInsets.fromLTRB(20,24,20,12),child:Row(children:[IconButton(onPressed:()=>Navigator.pop(context),icon:const Icon(Icons.arrow_back_ios_new)),const CircleAvatar(radius:22,backgroundColor:Color(0xFFE4E8ED)),const SizedBox(width:10),Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(circle.name,style:const TextStyle(fontSize:17)),Text('${circle.members} members',style:const TextStyle(fontSize:12,color:Color(0xFF80909A)))])),_headerIcon(Icons.notifications_none),const SizedBox(width:8),GestureDetector(onTap:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>CircleSettingsScreen(circle:circle))),child:_headerIcon(Icons.settings_outlined))])),Expanded(child:ListView(padding:const EdgeInsets.fromLTRB(20,0,20,24),children:[Row(children:[const Expanded(child:Text('Members',style:TextStyle(fontSize:20))),TextButton(onPressed:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>AllMembersScreen())),child:const Text('View Members ›',style:TextStyle(color:AppColors.primaryBlue)))]),SizedBox(height:78,child:ListView(scrollDirection:Axis.horizontal,children:[for(int i=0;i<5;i++)Padding(padding:const EdgeInsets.only(right:16),child:Column(children:[const CircleAvatar(radius:22,backgroundColor:Color(0xFFE5E9ED)),const SizedBox(height:6),Text(i==0?'You':'@user$i',style:const TextStyle(fontSize:10,color:Color(0xFF75858E)))])),Column(children:[Container(width:44,height:44,decoration:BoxDecoration(shape:BoxShape.circle,color:const Color(0xFFEAF6FF),border:Border.all(color:AppColors.primaryBlue)),child:const Center(child:Text('+2',style:TextStyle(color:AppColors.primaryBlue)))),const SizedBox(height:6),const Text('More',style:TextStyle(fontSize:10,color:AppColors.primaryBlue))])])),const SizedBox(height:14),GestureDetector(onTap:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>CircleChatScreen(circle:circle))),child:Container(padding:const EdgeInsets.all(18),decoration:BoxDecoration(color:const Color(0xFFEAF7FF),borderRadius:BorderRadius.circular(20),border:Border.all(color:const Color(0xFFBBE2FA))),child:Row(children:[const CircleAvatar(radius:26,backgroundColor:Colors.white,child:Icon(Icons.forum_outlined,color:AppColors.primaryBlue)),const SizedBox(width:14),const Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text('Circle Chat',style:TextStyle(fontSize:19)),SizedBox(height:4),Text('Aarav: Good workout today!',style:TextStyle(color:Color(0xFF6B7B84))),Text('5 unread messages',style:TextStyle(color:AppColors.primaryBlue))])),const Icon(Icons.chevron_right)]))),const SizedBox(height:22),Container(padding:const EdgeInsets.all(18),decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(22),boxShadow:[BoxShadow(color:Colors.black.withValues(alpha:.05),blurRadius:16)]),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Row(children:[const Expanded(child:Text('Recent Updates',style:TextStyle(fontSize:19))),TextButton(onPressed:(){},child:const Text('View All',style:TextStyle(color:AppColors.primaryBlue)))]),_update('You completed your hydr...','2.5 L / 2.5 L','1h ago'),_update('@priya updated nutrition.','Meal logged','3h ago'),_update('@aarav12 updated sleep.','8h 02m sleep','Yesterday')]))]))])),bottomNavigationBar:const _SubpageBottomNav());
 static Widget _headerIcon(IconData i)=>Container(width:44,height:44,decoration:const BoxDecoration(shape:BoxShape.circle,color:Color(0xFFF1F2F5)),child:Icon(i,size:23,color:Color(0xFF4A565C)));
 static Widget _update(String t,String s,String time)=>Padding(padding:const EdgeInsets.symmetric(vertical:10),child:Row(children:[const CircleAvatar(radius:21,backgroundColor:Color(0xFFE5E9ED)),const SizedBox(width:14),Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(t,style:const TextStyle(fontSize:14)),Text(s,style:const TextStyle(fontSize:12,color:AppColors.primaryBlue))])),Text(time,style:const TextStyle(fontSize:12,color:Color(0xFF7B8A93)))])); }

class CircleSettingsScreen extends StatelessWidget { final _Circle circle; const CircleSettingsScreen({super.key,required this.circle}); @override Widget build(BuildContext context)=>Scaffold(backgroundColor:Colors.white,body:SafeArea(bottom:false,child:Column(children:[_bar(context,'Settings'),const SizedBox(height:18),Container(width:96,height:96,decoration:const BoxDecoration(shape:BoxShape.circle,color:Color(0xFFDCE7FF)),child:const Icon(Icons.groups,size:48,color:Color(0xFF0C64C8))),const SizedBox(height:20),Text(circle.name,style:const TextStyle(fontSize:24)),const SizedBox(height:4),Text('Created by you • ${circle.members} members',style:const TextStyle(color:Color(0xFF8BA1AD))),const SizedBox(height:22),_tile(context,Icons.people_outline,'Manage Members',()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>ManageCircleMembersScreen(circle:circle)))),_tile(context,Icons.person_add_alt_1_outlined,'Add Members',()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>AddMembersScreen(connections:const [_Person('@aara_sharma','Last active today'),_Person('@priya.singh','Last active yesterday')])))),_tile(context,Icons.share_outlined,'Your Shared Avatars',()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>SharedAvatarSettingsScreen(circle:circle)))),_tile(context,Icons.notifications_none,'Notifications',()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>CircleNotificationSettingsScreen(circle:circle)))),const Spacer(),Padding(padding:const EdgeInsets.only(bottom:24),child:OutlinedButton(onPressed:()=>_leave(context),style:OutlinedButton.styleFrom(foregroundColor:const Color(0xFFD1264D),side:const BorderSide(color:Color(0xFFD1264D))),child:Text('Leave ${circle.name}')))])),bottomNavigationBar:const _SubpageBottomNav());
 void _leave(BuildContext context)=>showDialog(context:context,builder:(_)=>AlertDialog(title:const Text('Leave this circle?'),content:const Text('You will no longer be able to see this circle’s chat or shared health updates.'),actions:[TextButton(onPressed:()=>Navigator.pop(context),child:const Text('Cancel')),TextButton(onPressed:(){Navigator.pop(context);Navigator.pop(context);},child:const Text('Leave',style:TextStyle(color:Color(0xFFD1264D))))]));
 Widget _tile(BuildContext c,IconData i,String t,VoidCallback tap)=>Padding(padding:const EdgeInsets.fromLTRB(20,6,20,0),child:ListTile(onTap:tap,shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(12),side:const BorderSide(color:Color(0xFFB8D7F2))),leading:Icon(i,size:28),title:Text(t),trailing:const Icon(Icons.chevron_right)));
}

class ManageCircleMembersScreen extends StatefulWidget { final _Circle circle; const ManageCircleMembersScreen({super.key,required this.circle}); @override State<ManageCircleMembersScreen> createState()=>_ManageCircleMembersScreenState(); }
class _ManageCircleMembersScreenState extends State<ManageCircleMembersScreen>{ final users=[const _Person('@sahil.123','Circle Admin'),const _Person('@priya.singh','Joined since 5 days'),const _Person('@priya.singh','Joined since 5 days'),const _Person('@priya.singh','Joined since 5 days'),const _Person('@priya.singh','Joined since 5 days'),const _Person('@riya','Invited')]; @override Widget build(BuildContext context)=>Scaffold(backgroundColor:Colors.white,body:SafeArea(bottom:false,child:Column(children:[_bar(context,'Manage Members'),Padding(padding:const EdgeInsets.all(20),child:TextField(decoration:CareCirclesScreenStyle.input('Search by username').copyWith(prefixIcon:const Icon(Icons.search)))),Expanded(child:ListView(padding:const EdgeInsets.symmetric(horizontal:20),children:[const Text('Admins',style:TextStyle(color:Color(0xFF8BA1AD))),_card(context,users.first),const SizedBox(height:18),const Text('Members',style:TextStyle(color:Color(0xFF8BA1AD))),...users.skip(1).take(4).map((p)=>_card(context,p)),const SizedBox(height:14),const Text('Invited(1)',style:TextStyle(color:Color(0xFF8BA1AD))),_card(context,users.last)]))])),bottomNavigationBar:const _SubpageBottomNav());
 Widget _card(BuildContext c,_Person p)=>GestureDetector(onTap:()=>Navigator.push(c,MaterialPageRoute(builder:(_)=>CircleMemberScreen(username:p.username))),child:Container(margin:const EdgeInsets.symmetric(vertical:7),padding:const EdgeInsets.all(16),decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(16),boxShadow:[BoxShadow(color:Colors.black.withValues(alpha:.05),blurRadius:12)]),child:Row(children:[const CircleAvatar(radius:28,backgroundColor:Color(0xFFE5E9ED)),const SizedBox(width:16),Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(p.username,style:const TextStyle(fontSize:18)),Text(p.activity,style:const TextStyle(fontSize:14,color:Color(0xFF7D8E97)))])),const Icon(Icons.chevron_right)])));
}

class CircleMemberScreen extends StatelessWidget { final String username; const CircleMemberScreen({super.key,required this.username}); @override Widget build(BuildContext context)=>Scaffold(backgroundColor:Colors.white,body:SafeArea(bottom:false,child:Column(children:[_bar(context,'Member'),const SizedBox(height:28),const CircleAvatar(radius:48,backgroundColor:Color(0xFFE5E9ED)),const SizedBox(height:18),Text(username,style:const TextStyle(fontSize:24)),const Text('@username',style:TextStyle(color:Color(0xFF8EA3AE))),const SizedBox(height:28),_action(context,'View Profile',()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>MemberAvatarScreen(username:username)))),_action(context,'View Shared Avatars',()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>MemberAvatarScreen(username:username)))),const Spacer(),_action(context,'Remove from circle',(){},danger:true),const SizedBox(height:30)])),bottomNavigationBar:const _SubpageBottomNav());
 Widget _action(BuildContext c,String t,VoidCallback f,{bool danger=false})=>Padding(padding:const EdgeInsets.fromLTRB(20,7,20,0),child:ListTile(onTap:f,shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(12),side:const BorderSide(color:Color(0xFFB8D7F2))),leading:Icon(danger?Icons.delete_outline:Icons.person_outline,color:danger?const Color(0xFFD1264D):const Color(0xFF637984)),title:Text(t,style:TextStyle(color:danger?const Color(0xFFD1264D):Colors.black87)),trailing:const Icon(Icons.chevron_right)));
}

class SharedAvatarSettingsScreen extends StatefulWidget { final _Circle circle; const SharedAvatarSettingsScreen({super.key,required this.circle}); @override State<SharedAvatarSettingsScreen> createState()=>_SharedAvatarSettingsScreenState(); }
class _SharedAvatarSettingsScreenState extends State<SharedAvatarSettingsScreen>{bool hydration=true,nutrition=true,sleep=false; @override Widget build(BuildContext context)=>Scaffold(backgroundColor:Colors.white,body:SafeArea(bottom:false,child:Column(children:[_bar(context,'Your Shared Avatars'),const SizedBox(height:34),_share('💧','Hydration',hydration,(v)=>setState(()=>hydration=v)),_share('🍽️','Nutrition',nutrition,(v)=>setState(()=>nutrition=v)),_share('😴','Sleep',sleep,(v)=>setState(()=>sleep=v),locked:true),const Spacer(),SizedBox(width:212,child:ElevatedButton(onPressed:()=>Navigator.pop(context),child:const Text('Save Changes'))),const SizedBox(height:24)])),bottomNavigationBar:const _SubpageBottomNav()); Widget _share(String i,String t,bool v,ValueChanged<bool> on,{bool locked=false})=>Padding(padding:const EdgeInsets.symmetric(horizontal:28,vertical:8),child:Row(children:[Text(i,style:const TextStyle(fontSize:25)),const SizedBox(width:12),Expanded(child:Text(t,style:const TextStyle(fontSize:18))),Switch(value:v,onChanged:locked?null:on,activeColor:Colors.white,activeTrackColor:AppColors.primaryBlue)]));}

class CircleNotificationSettingsScreen extends StatefulWidget { final _Circle circle; const CircleNotificationSettingsScreen({super.key,required this.circle}); @override State<CircleNotificationSettingsScreen> createState()=>_CircleNotificationSettingsScreenState(); }
class _CircleNotificationSettingsScreenState extends State<CircleNotificationSettingsScreen>{bool joins=true,updates=true,goals=true,avatars=true,mentions=true,messages=true; @override Widget build(BuildContext context)=>Scaffold(backgroundColor:Colors.white,body:SafeArea(bottom:false,child:Column(children:[_bar(context,'Notification Settings'),const SizedBox(height:20),const Padding(padding:EdgeInsets.symmetric(horizontal:32),child:Text('Manage what notifications you receive from your circle.',textAlign:TextAlign.center,style:TextStyle(color:Color(0xFF71838C)))),Expanded(child:ListView(padding:const EdgeInsets.all(20),children:[_group('Circle Activity',[_setting('Member joins or leaves','Get notified when members join or leave this circle.',joins,(v)=>setState(()=>joins=v)),_setting('Circle updates','Stay informed about important circle changes.',updates,(v)=>setState(()=>updates=v))]),_group('Avatar updates',[_setting('Goal completions','Celebrate members reaching their health goals.',goals,(v)=>setState(()=>goals=v)),_setting('Avatar updates','Know when shared information is updated.',avatars,(v)=>setState(()=>avatars=v))]),_group('Chat',[_setting('Mentions','Get notified if someone mentions you in chat.',mentions,(v)=>setState(()=>mentions=v)),_setting('New Message','Stay up to date with new messages in chats.',messages,(v)=>setState(()=>messages=v))])]))])),bottomNavigationBar:const _SubpageBottomNav()); Widget _group(String t,List<Widget> w)=>Padding(padding:const EdgeInsets.only(bottom:22),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(t,style:const TextStyle(color:Color(0xFF8EA4B1))),const SizedBox(height:10),Container(decoration:BoxDecoration(borderRadius:BorderRadius.circular(18),border:Border.all(color:const Color(0xFFF0F2F4))),child:Column(children:w))])); Widget _setting(String t,String s,bool v,ValueChanged<bool> on)=>ListTile(title:Text(t),subtitle:Text(s,style:const TextStyle(fontSize:12,color:Color(0xFF9BB0BE))),trailing:Switch(value:v,onChanged:on,activeColor:Colors.white,activeTrackColor:AppColors.primaryBlue)); }

class CircleAppearanceScreen extends StatefulWidget {
  final _Circle circle;
  const CircleAppearanceScreen({super.key, required this.circle});
  @override State<CircleAppearanceScreen> createState() => _CircleAppearanceScreenState();
}

class _CircleAppearanceScreenState extends State<CircleAppearanceScreen> {
  late TextEditingController n;
  int selected = 0;

  @override void initState() {
    super.initState();
    n = TextEditingController(text: widget.circle.name);
  }
  @override void dispose() { n.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    const colors = [
      Color(0xFFE8EEF9), Color(0xFFEAF7FF), Color(0xFFF4EAFE), Color(0xFFFFF0E8),
      Color(0xFFE8F5EC), Color(0xFFFFEEF4), Color(0xFFEDE9FE), Color(0xFFF0F4F7),
    ];
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _bar(context, 'Profile'),
            const SizedBox(height: 24),
            const CircleAvatar(radius: 48, backgroundColor: Color(0xFFDCE7FF), child: Icon(Icons.groups, size: 48, color: Color(0xFF0C64C8))),
            const SizedBox(height: 28),
            const Align(alignment: Alignment.centerLeft, child: Padding(padding: EdgeInsets.only(left: 28), child: Text('SELECT WALLPAPER', style: TextStyle(color: Color(0xFF8EA4B1))))),
            const SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: GridView.builder(
                shrinkWrap: true, itemCount: 8,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, crossAxisSpacing: 18, mainAxisSpacing: 18),
                itemBuilder: (context, i) => GestureDetector(
                  onTap: () => setState(() => selected = i),
                  child: Container(decoration: BoxDecoration(shape: BoxShape.circle, color: colors[i], border: selected == i ? Border.all(color: AppColors.primaryBlue, width: 2) : null)),
                ),
              ),
            ),
            const SizedBox(height: 48),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: TextField(controller: n, decoration: CareCirclesScreenStyle.input('Circle name'))),
            const Spacer(),
            SizedBox(width: 212, child: ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Save Changes'))),
            const SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: const _SubpageBottomNav(),
    );
  }
}

class CircleChatScreen extends StatefulWidget {
  final _Circle circle;
  const CircleChatScreen({super.key, required this.circle});
  @override State<CircleChatScreen> createState() => _CircleChatScreenState();
}

class _CircleChatScreenState extends State<CircleChatScreen> {
  final controller = TextEditingController();
  final messages = <Map<String, String>>[
    {'u':'@aarav.1234','t':'Good workout today! 💪','m':'0'},
    {'u':'@priya.singh','t':'Good workout today!','m':'0'},
    {'u':'You','t':'Yes! Feeling great after that session 🔥','m':'1'},
  ];
  @override void dispose(){controller.dispose();super.dispose();}
  @override Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _bar(context, widget.circle.name),
            const Chip(label: Text('Today')),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: messages.map((m) {
                  final mine = m['m'] == '1';
                  return Align(
                    alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 18),
                      padding: const EdgeInsets.all(14),
                      constraints: const BoxConstraints(maxWidth: 270),
                      decoration: BoxDecoration(color: mine ? AppColors.primaryBlue : Colors.white, border: Border.all(color: const Color(0xFFD8E7EF)), borderRadius: BorderRadius.circular(18)),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        if (!mine) Text(m['u']!, style: const TextStyle(fontSize: 11, color: Color(0xFF7E8D96))),
                        Text(m['t']!, style: TextStyle(color: mine ? Colors.white : AppColors.textDark, fontSize: 15)),
                        const Text('10:32 AM', style: TextStyle(fontSize: 9, color: Color(0xFFAAB6BE))),
                      ]),
                    ),
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 8, 28, 18),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(28), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: .12), blurRadius: 16)]),
                child: Row(children: [
                  Expanded(child: TextField(controller: controller, decoration: const InputDecoration(hintText: 'Type here..', border: InputBorder.none))),
                  IconButton(onPressed: () { final t=controller.text.trim(); if(t.isNotEmpty){setState((){messages.add({'u':'You','t':t,'m':'1'});controller.clear();});}}, icon: const Icon(Icons.send_outlined, color: AppColors.primaryBlue)),
                ]),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const _SubpageBottomNav(),
    );
  }
}

class AllMembersScreen extends StatelessWidget { const AllMembersScreen({super.key}); @override Widget build(BuildContext context){const users=['@sahil.123','@priya.singh','@priya.singh','@priya.singh','@priya.singh','@riya']; return Scaffold(backgroundColor:Colors.white,body:SafeArea(bottom:false,child:Column(children:[_bar(context,'All Members'),Padding(padding:const EdgeInsets.all(20),child:TextField(decoration:CareCirclesScreenStyle.input('Search by username').copyWith(prefixIcon:const Icon(Icons.search)))),Expanded(child:ListView(padding:const EdgeInsets.symmetric(horizontal:20),children:[const Text('Admins',style:TextStyle(color:Color(0xFF8BA1AD))),_member(context,users[0],'Circle Admin'),const SizedBox(height:18),const Text('Members',style:TextStyle(color:Color(0xFF8BA1AD))),...users.skip(1).take(4).map((u)=>_member(context,u,'Joined since 5 days')),const Text('Invited(1)',style:TextStyle(color:Color(0xFF8BA1AD))),_member(context,users.last,'Invited')]))])),bottomNavigationBar:const _SubpageBottomNav()); } static Widget _member(BuildContext c,String u,String s)=>GestureDetector(onTap:()=>Navigator.push(c,MaterialPageRoute(builder:(_)=>MemberAvatarScreen(username:u))),child:Container(margin:const EdgeInsets.symmetric(vertical:7),padding:const EdgeInsets.all(16),decoration:BoxDecoration(borderRadius:BorderRadius.circular(16),boxShadow:[BoxShadow(color:Colors.black.withValues(alpha:.05),blurRadius:12)]),child:Row(children:[const CircleAvatar(radius:28,backgroundColor:Color(0xFFE5E9ED)),const SizedBox(width:16),Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(u,style:const TextStyle(fontSize:18)),Text(s,style:const TextStyle(color:Color(0xFF7D8E97)))])])));
}

class MemberAvatarScreen extends StatefulWidget { final String username; const MemberAvatarScreen({super.key,required this.username}); @override State<MemberAvatarScreen> createState()=>_MemberAvatarScreenState(); }
class _MemberAvatarScreenState extends State<MemberAvatarScreen>{int page=0; @override Widget build(BuildContext context)=>Scaffold(backgroundColor:Colors.white,body:SafeArea(bottom:false,child:Column(children:[Padding(padding:const EdgeInsets.fromLTRB(28,24,20,10),child:Row(children:[IconButton(onPressed:()=>Navigator.pop(context),icon:const Icon(Icons.arrow_back_ios_new)),Expanded(child:Text(widget.username,style:const TextStyle(fontSize:24))),OutlinedButton(onPressed:(){},child:const Text('View Profile'))])),Expanded(child:PageView(onPageChanged:(i)=>setState(()=>page=i),children:[_avatar('💧 Water','2.1 L',true),_avatar('🍽️ Meal','',false,lockedText:'This member has not shared\ntheir nutrition avatar.'),_avatar('😴 Sleep','',false,lockedText:'Sleep avatar is available with STAR plan.')]))])),bottomNavigationBar:const _SubpageBottomNav());
 Widget _avatar(String title,String value,bool unlocked,{String? lockedText})=>Stack(children:[Center(child:Image.asset('assets/images/avatar_male.png',width:300,height:520,fit:BoxFit.contain)),Positioned(left:20,top:50,child:Container(width:112,padding:const EdgeInsets.all(10),decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(14),boxShadow:[BoxShadow(color:Colors.black.withValues(alpha:.1),blurRadius:16)]),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(title,style:const TextStyle(fontSize:14)),const SizedBox(height:8),if(unlocked)Text(value,style:const TextStyle(fontSize:20,color:AppColors.primaryBlue)),if(unlocked)const Text('of 2.5 L goal',style:TextStyle(fontSize:9,color:Color(0xFF9AABB3))),if(!unlocked)Text(lockedText??'',style:const TextStyle(fontSize:10,height:1.35,color:Color(0xFF8797A0))),if(!unlocked&&title.contains('Sleep'))const SizedBox(height:8)])))]); }

class CircleInviteScreen extends StatelessWidget { final _CircleInvite invite; const CircleInviteScreen({super.key,required this.invite}); @override Widget build(BuildContext context)=>Scaffold(backgroundColor:Colors.white,body:SafeArea(bottom:false,child:Column(children:[const Spacer(),const Icon(Icons.person_add_alt_1_outlined,size:86,color:AppColors.primaryBlue),const SizedBox(height:40),const Text('You are invited to join',style:TextStyle(color:Color(0xFF7F8A90))),const SizedBox(height:8),Text(invite.name,style:const TextStyle(fontSize:24,color:AppColors.primaryBlue)),const SizedBox(height:4),Text('Invited by ${invite.invitedBy}',style:const TextStyle(color:Color(0xFF67757D))),const SizedBox(height:24),Text('${invite.members} members',style:const TextStyle(color:Color(0xFF65737B))),const SizedBox(height:30),Container(margin:const EdgeInsets.symmetric(horizontal:40),padding:const EdgeInsets.all(20),decoration:BoxDecoration(color:const Color(0xFFF1F6FF),borderRadius:BorderRadius.circular(16)),child:const Text('By joining, you can connect, chat and view shared health updates.',textAlign:TextAlign.center,style:TextStyle(color:Color(0xFF7152A8)))),const Spacer(),SizedBox(width:212,child:ElevatedButton(onPressed:()=>Navigator.pop(context),child:const Text('Join Circle →'))),TextButton(onPressed:()=>Navigator.pop(context),child:const Text('Decline')),const SizedBox(height:24)])),bottomNavigationBar:const _SubpageBottomNav()); }

class _SubpageBottomNav extends StatelessWidget { const _SubpageBottomNav(); @override Widget build(BuildContext context)=>Container(height:64,decoration:BoxDecoration(color:Colors.white,boxShadow:[BoxShadow(color:Colors.black.withValues(alpha:.08),blurRadius:8,offset:const Offset(0,-2))]),child:SafeArea(top:false,child:Row(mainAxisAlignment:MainAxisAlignment.spaceEvenly,children:[_n(Icons.home_outlined,'Home'),_n(Icons.groups_outlined,'Care Circle',true),_n(Icons.auto_awesome_outlined,'Rin AI'),_n(Icons.person_outline,'Profile')])));
  static Widget _n(IconData i,String t,[bool selected=false]){final c=selected?AppColors.primaryBlue:const Color(0xFF4A565C);return Column(mainAxisAlignment:MainAxisAlignment.center,children:[Icon(i,size:25,color:c),const SizedBox(height:2),Text(t,style:TextStyle(fontSize:10,color:c))]);}}

class _Circle { final String name; final int members; final int updates; const _Circle(this.name,this.members,this.updates); }
class _CircleInvite { final String name; final int members; final String invitedBy; const _CircleInvite(this.name,this.members,this.invitedBy); }
class _Person { final String username; final String activity; const _Person(this.username,this.activity); }

Widget _bar(BuildContext context,String title)=>Padding(padding:const EdgeInsets.fromLTRB(20,8,20,0),child:Row(children:[IconButton(onPressed:()=>Navigator.pop(context),icon:const Icon(Icons.arrow_back_ios_new)),Expanded(child:Center(child:Text(title,style:const TextStyle(fontSize:24,color:AppColors.textDark)))),const SizedBox(width:48)]));

class CareCirclesScreenStyle { static InputDecoration input(String hint)=>InputDecoration(hintText:hint,contentPadding:const EdgeInsets.symmetric(horizontal:16,vertical:16),enabledBorder:OutlineInputBorder(borderRadius:BorderRadius.all(Radius.circular(12)),borderSide:BorderSide(color:Color(0xFF9FB0B8))),focusedBorder:OutlineInputBorder(borderRadius:BorderRadius.all(Radius.circular(12)),borderSide:BorderSide(color:AppColors.primaryBlue))); }
class ClipboardDemo { static void share(){} }
