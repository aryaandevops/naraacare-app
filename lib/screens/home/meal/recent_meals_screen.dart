import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../models/meal_entry.dart';

class RecentMealsScreen extends StatefulWidget {
  const RecentMealsScreen({super.key});
  @override State<RecentMealsScreen> createState() => _RecentMealsScreenState();
}

class _RecentMealsScreenState extends State<RecentMealsScreen> {
  final List<MealFood> saved = [
    MealFood(id: 'saved1', name: 'Moong Dal', serving: '2 Katori(4 items)', imageAsset: 'lib/assets/images/food/moong_dal_cooked.png', calories: 62, protein: 5, carbs: 10, fat: 1, fiber: 2),
    MealFood(id: 'saved2', name: 'Moong Dal', serving: '2 Katori(4 items)', imageAsset: 'lib/assets/images/food/moong_dal_cooked.png', calories: 62, protein: 5, carbs: 10, fat: 1, fiber: 2),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    body: SafeArea(child: Column(children: [
      Padding(padding: const EdgeInsets.fromLTRB(20, 10, 20, 14), child: Row(children: [IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_ios_new, size: 20)), const Expanded(child: Center(child: Text('Recent Updates', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)))), const SizedBox(width: 48)])),
      Expanded(child: SingleChildScrollView(padding: const EdgeInsets.symmetric(horizontal: 20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [_mini('Roti','roti.png'), _mini('Moong Dal','moong_dal_cooked.png'), _mini('Rice','rice.png'), _mini('Curd','curd.png'), _mini('Aloo Sabz','aloo_sabz.png')]),
        const SizedBox(height: 10),
        Row(children: [_mini('Roti','roti.png'), _mini('Moong Dal','moong_dal_cooked.png'), _mini('Rice','rice.png'), _mini('Curd','curd.png'), _mini('Aloo Sabz','aloo_sabz.png')]),
        const SizedBox(height: 25),
        const Text('Saved Meals', style: TextStyle(fontSize: 19, color: AppColors.textGrey, fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        ...saved.map((e) => _savedCard(e)),
        const SizedBox(height: 20),
        const Text('Last 2 Updates', style: TextStyle(fontSize: 19, color: AppColors.textGrey, fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        _updateCard('1 Apple', '2 mins ago', true),
        _updateCard('Moong Dal - 2 Katori(4 items)', '8:45 AM', true),
      ]))),
    ])),
  );

  Widget _mini(String label, String file) => Expanded(child: Column(children: [Container(width: 56,height:56,padding:const EdgeInsets.all(3),decoration:BoxDecoration(shape:BoxShape.circle,border:Border.all(color:const Color(0xFFBAC8D1))),child:ClipOval(child:Image.asset('lib/assets/images/food/$file',fit:BoxFit.cover))),const SizedBox(height:4),Text(label,maxLines:1,overflow:TextOverflow.ellipsis,style:const TextStyle(fontSize:11))]));
  Widget _savedCard(MealFood e) => Container(width:double.infinity,margin:const EdgeInsets.only(bottom:12),padding:const EdgeInsets.symmetric(vertical:18),decoration:BoxDecoration(border:Border.all(color:const Color(0xFFB8C6CF)),borderRadius:BorderRadius.circular(11)),child:Center(child:Text('${e.name} - ${e.serving}',style:const TextStyle(color:Color(0xFFB7C0C6),fontSize:15))));
  Widget _updateCard(String title,String time,bool editable) => Container(width:double.infinity,margin:const EdgeInsets.only(bottom:12),padding:const EdgeInsets.symmetric(horizontal:14,vertical:12),decoration:BoxDecoration(border:Border.all(color:const Color(0xFFB8C6CF)),borderRadius:BorderRadius.circular(11)),child:Row(children:[Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(title,style:const TextStyle(color:Color(0xFFB7C0C6),fontSize:15)),Text(time,style:const TextStyle(color:Color(0xFFCBD0D4),fontSize:11))])),IconButton(onPressed:editable?()=>_edit(title):null,icon:const Icon(Icons.edit_outlined,color:Color(0xFFADB7BD)))]));
  void _edit(String title)=>showModalBottomSheet(context:context,isScrollControlled:true,backgroundColor:Colors.white,builder:(_)=>Padding(padding:const EdgeInsets.fromLTRB(20,24,20,30),child:Column(mainAxisSize:MainAxisSize.min,children:[const Text('Edit your entry',style:TextStyle(fontSize:18,fontWeight:FontWeight.w600)),const SizedBox(height:20),ListTile(title:Text(title),trailing:const Icon(Icons.delete_outline,color:Colors.redAccent)),const SizedBox(height:10),ElevatedButton(onPressed:()=>Navigator.pop(context),child:const Text('Update Entry'))])));
}
