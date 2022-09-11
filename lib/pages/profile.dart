import 'package:flutter/material.dart';
import 'package:fitonyashki_projeckt/user.dart';
import 'package:fitonyashki_projeckt/pages/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fitonyashki_projeckt/main.dart';
class profile extends StatefulWidget {
  const profile({Key? key}) : super(key: key);

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  final _formKey = GlobalKey<FormState>();
  String _newName = '';
  double _currentHeight = 0;
  double _currentWeight = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SharedPreferences.getInstance()
      .then((prefs){
        setState(() => preferences = prefs);
        user.name = preferences.getString('name') ?? ' ';
        user.height = preferences.getDouble('height') ?? 185;
        user.weight = preferences.getDouble('weight') ?? 72.5;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
       child: SafeArea(
         child: Center(
           child: Column(
             //crossAxisAlignment: CrossAxisAlignment.center,
             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
             children: [
               Column(
                 children: [
                   Column(
                     children: [
                       const Text('Username', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                       const SizedBox(height: 10,),
                       Container(
                           width: 250,
                           height: 40,
                           child:
                           Center(
                             child: Text(user.name,
                               style: const TextStyle(color: Color(0xFF616B83), fontSize: 18, fontWeight: FontWeight.bold),
                             ),
                           ),
                           decoration: BoxDecoration(
                             borderRadius: BorderRadius.circular(40),
                             color: const Color(0xFFC6D0EB),
                           )
                       ),
                     ],
                   ),
                   const SizedBox(height: 30,),
                   Column(
                     children: [
                       const Text('Height', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                       const SizedBox(height: 10,),
                       Container(
                           width: 100,
                           height: 40,
                           child:
                           Center(
                             child: Text('${user.height}',
                               style: const TextStyle(color: Color(0xFF616B83), fontSize: 18, fontWeight: FontWeight.bold),
                             ),
                           ),
                           decoration: BoxDecoration(
                             borderRadius: BorderRadius.circular(40),
                             color: const Color(0xFFC6D0EB),
                           )
                       ),
                     ],
                   ),
                   const SizedBox(height: 30,),
                   Column(
                     children: [
                       const Text('Weight', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                       const SizedBox(height: 10,),
                       Container(
                         width: 100,
                         height: 40,
                         child:
                           Center(
                             child: Text('${user.weight}',
                               style: const TextStyle(color: Color(0xFF616B83), fontSize: 18, fontWeight: FontWeight.bold),
                             ),
                           ),
                           decoration: BoxDecoration(
                             borderRadius: BorderRadius.circular(40),
                             color: const Color(0xFFC6D0EB),
                           )
                       ),
                     ],
                   ),
                 ],
               ),
               ElevatedButton(onPressed: (){
                 showDialog<String>(
                   context: context,
                   builder: (BuildContext context) => _form(context),
                 );
                 },
                 style: ElevatedButton.styleFrom(
                   primary: const Color(0xFFC6D0EB),
                   elevation: 0,
                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                 ),
                 child: Container(
                   height: 50,
                   width: 300,
                   child: const Center(
                     child: Text('Edit profile',
                       style: TextStyle(color: Color(0xFF616B83), fontSize: 18, fontWeight: FontWeight.bold),
                     ),
                   ),
                 ),
               ),
             ],
           ),
         ),
      ),
    );
  }

  Widget _form(context){
    return AlertDialog(
      title: const Text('Profile',
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      content:
      Form(
          key: _formKey,
          child: Container(
            height: 275,
            child: Column(
              children: [
                const SizedBox(height: 20,),
                TextFormField(
                  initialValue: user.name,
                  maxLength: 15,
                  decoration: const InputDecoration(
                    labelText: 'Your name',
                    labelStyle: TextStyle(
                        //fontWeight: FontWeight.bold,
                        color: Colors.black
                    ),
                    hintText: 'Type your new name',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF616B83), width: 1.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFC6D0EB), width: 1.5),
                    ),

                  ),
                  keyboardType: TextInputType.name,
                  validator: _validName,
                  onSaved: (value) => _newName = value!,
                ),
                const SizedBox(height: 20,),
                TextFormField(
                  initialValue: user.height.toString(),
                  decoration: const InputDecoration(
                    labelText: 'Your height',
                    labelStyle: TextStyle(
                        //fontWeight: FontWeight.bold,
                        color: Colors.black
                    ),
                    hintText: 'Type your current height (in cm)',
                    hintStyle: TextStyle(fontSize: 14),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF616B83), width: 1.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFC6D0EB), width: 1.5),
                    ),

                  ),
                  keyboardType: TextInputType.number,
                  validator: _validHeight,
                  onSaved: (value) => _currentHeight= double.parse(value!),
                ),
                const SizedBox(height: 20,),
                TextFormField(
                  initialValue: user.weight.toString(),
                  decoration: const InputDecoration(
                    labelText: 'Your weight',
                    labelStyle: TextStyle(
                        //fontWeight: FontWeight.bold,
                        color: Colors.black
                    ),
                    hintText: 'Type your current weight (in kg)',
                    hintStyle: TextStyle(fontSize: 14),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF616B83), width: 1.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFC6D0EB), width: 1.5),
                    ),

                  ),
                  keyboardType: TextInputType.number,
                  validator: _validWeight,
                  onSaved: (value) => _currentWeight = double.parse(value!),
                ),
              ],
            ),
          )
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: const Text('Cancel',
            style: TextStyle(color: Color(0xFF616B83), fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
        TextButton(
          onPressed: _submitForm,
          child: const Text('OK',
            style: TextStyle(color: Color(0xFF616B83), fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  String? _validName(String? val){
    if(val!.isEmpty){
      return 'This filed is required';
    }
    return null;
  }
  String? _validHeight(String? val){
    final _heightExp = RegExp(
        r'^[\d.]+$');
    if(val!.isEmpty){
      return 'This filed is required';
    }
    else if (!_heightExp.hasMatch(val)){
      return 'Please enter only digits and \'.\'';
    }else {
      return null;
    }
  }
  String? _validWeight(String? val){
    final _weightExp = RegExp(
        r'^[\d.]+$');
    if(val!.isEmpty){
      return 'This filed is required';
    }
    else if (!_weightExp.hasMatch(val)){
      return 'Please enter only digits and \'.\'';
    }else {
      return null;
    }
  }

  void _submitForm(){
    if(_formKey.currentState!.validate()){
      _formKey.currentState?.save();
      //setState(() {
        user.weight = _currentWeight;
        user.height = _currentHeight;
        user.name = _newName;
        _setUserPreferences(user);
      //});
      Navigator.pop(context);
    }
  }

  Future<Null> _setUserPreferences(User user) async{
    await preferences.setDouble('height', user.height);
    await preferences.setDouble('weight', user.weight);
    await preferences.setString('name', user.name);
    _loadUserPreferences();
  }

  void _loadUserPreferences(){
    setState(() {
      user.name = preferences.getString('name') ?? '_';
      user.height = preferences.getDouble('height') ?? 185;
      user.weight = preferences.getDouble('weight') ?? 72.5;
    });
  }

}
