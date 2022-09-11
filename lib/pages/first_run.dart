import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fitonyashki_projeckt/user.dart';
import 'package:fitonyashki_projeckt/main.dart';
class firstRun extends StatefulWidget {
  const firstRun({Key? key}) : super(key: key);

  @override
  State<firstRun> createState() => _firstRunState();
}

class _firstRunState extends State<firstRun> {
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
      user.name = preferences.getString('name') ?? '';
      user.height = preferences.getDouble('height') ?? 0;
      user.weight = preferences.getDouble('weight') ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            //color: Color(0xFFC6D0EB),
            image: DecorationImage(
                image: AssetImage("assets/images/back.jpg"),
                fit: BoxFit.cover),
          ),
          child: _firstForm(context),
        )
    );
  }

  Widget _firstForm(context){
    return
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 70,),
          Form(
              key: _formKey,
              child: Container(
                height: 320,
                width: 270,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: Colors.black.withOpacity(0.7),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Column(
                      children: [
                        SizedBox(
                          child: TextFormField(
                            style: const TextStyle(color: Colors.white),
                            initialValue: null,//user.name,
                            maxLength: 20,
                            decoration: const InputDecoration(
                              helperStyle: TextStyle(
                                  color: Colors.white
                              ),
                              labelText: 'Your name',
                              labelStyle: TextStyle(
                                  color: Colors.white
                              ),
                              hintText: 'Type your new name',
                              hintStyle: TextStyle(
                                  color: Colors.white
                              ),

                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Color(0xFF616B83), width: 1.5),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Color(0xFFC6D0EB), width: 1.5),
                              ),

                            ),
                            keyboardType: TextInputType.name,
                            validator: _validName,
                            onSaved: (value) => _newName = value!,
                          ),
                        ),
                        const SizedBox(height: 20,),
                        TextFormField(
                          style: const TextStyle(color: Colors.white),
                          initialValue: null,//user.height.toString(),
                          decoration: const InputDecoration(
                            labelText: 'Your height',
                            labelStyle: TextStyle(
                                color: Colors.white
                            ),
                            hintText: 'Type your current height (in cm)',
                            hintStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 14
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF616B83), width: 1.5),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFC6D0EB), width: 1.5),
                            ),

                          ),
                          keyboardType: TextInputType.number,
                          validator: _validHeight,
                          onSaved: (value) => _currentHeight= double.parse(value!),
                        ),
                        const SizedBox(height: 20,),
                        TextFormField(
                          style: const TextStyle(color: Colors.white),
                          initialValue: null,//user.weight.toString(),
                          decoration: const InputDecoration(
                            labelText: 'Your weight',
                            labelStyle: TextStyle(
                                color: Colors.white
                            ),
                            hintText: 'Type your current weight (in kg)',
                            hintStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 14
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF616B83), width: 1.5),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFC6D0EB), width: 1.5),
                            ),

                          ),
                          keyboardType: TextInputType.number,
                          validator: _validWeight,
                          onSaved: (value) => _currentWeight = double.parse(value!),
                        ),
                      ],
                    ),
                  ),
                ),
              )
          ),
          TextButton(
            onPressed: _submitFirstForm,
            child: const Text('OK',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
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
    }else if(double.parse(val) < 0.1){
       return 'Height must be above zero';
     }
    else {
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
    }else if(double.parse(val) < 0.1){
    return 'Weight must be above zero';
    }
    else {
      return null;
    }
  }

  void _submitFirstForm(){
    if(_formKey.currentState!.validate()){
      _formKey.currentState?.save();
      //setState(() {
      print(_currentHeight);
      print(_currentWeight);
      print(_newName);
      user.weight = _currentWeight;
      user.height = _currentHeight;
      user.name = _newName;
      //});
      _setPreferences(user);

    }
  }

  Future<Null> _setPreferences(User user) async{
    await preferences.setDouble('height', user.height);
    await preferences.setDouble('weight', user.weight);
    await preferences.setString('name', user.name);
    await preferences.setBool('seen', true);
    _loadPreferences();
  }

  void _loadPreferences(){
    setState(() {
      user.name = preferences.getString('name') ?? '';
      user.height = preferences.getDouble('height') ?? 0;
      user.weight = preferences.getDouble('weight') ?? 0;
      seen = preferences.getBool('seen') ?? false;
    });
    Navigator.popAndPushNamed(context, '/');
  }
}
