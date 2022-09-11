import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fitonyashki_projeckt/db/database.dart';
import 'package:fitonyashki_projeckt/pages/profile.dart';
import 'package:fitonyashki_projeckt/conversion.dart';
import 'package:fitonyashki_projeckt/models/activity.dart';
import 'package:fitonyashki_projeckt/user.dart';
import 'package:fitonyashki_projeckt/pages/stat_page.dart';
import 'package:fitonyashki_projeckt/main.dart';



class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    home(),
    stat(),
    profile(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.grey,
      appBar: AppBar(
        //title: const Icon(Icons.circle),
        //centerTitle: true,
        actions: [IconButton(
          icon:
            Icon(Icons.help),
            onPressed: (){
              Navigator.pushNamed(context, '/Help');
            },
          ),
        ],
        backgroundColor: const Color(0xFF87A2D6),
      ),
      //backgroundColor: Colors.grey,
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            label: 'Statistics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xFF616B83),
        onTap: _onItemTapped,
        backgroundColor: const Color(0xFF87A2D6),
        unselectedItemColor: Colors.white,
      ),
    );
  }
}


Future<List<Activity>>? activityList;
List<Activity>? activityListToStat;

class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);

  @override
  State<home> createState() => homeState();
}

class homeState extends State<home> {


  final _formKey = GlobalKey<FormState>();
  String typeOfActivity = 'Walking';
  String formVal = '';
  final List<String> _modes = ['kcals->km', 'km->kcals',];
  String? _selectedMode = 'kcals->km';


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateActivityList();

    SharedPreferences.getInstance()
        .then((prefs){
      setState(() => preferences = prefs);
      user.name = preferences.getString('name') ?? ' ';
      user.height = preferences.getDouble('height') ?? 185;
      user.weight = preferences.getDouble('weight') ?? 72.5;
    });
  }

  updateActivityList(){
    setState(() {
      activityList = DBProvider.db.getActivities();
    });
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('Hello, ${user.name}!',
                  style: const TextStyle(color: Colors.black,fontSize: 20, fontWeight: FontWeight.bold),
                ),

                const Center(child: Text('Time to workout',
                    style: TextStyle(color: Color(0xff87A2D6), fontSize: 15, fontWeight: FontWeight.bold),
                  )
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                        onTap: (){
                          typeOfActivity = 'Walking';
                          showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => _form(context),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            image: const DecorationImage(
                              fit: BoxFit.fill,
                              image: AssetImage('assets/images/Group_8.png'),
                            )
                          ),
                          width: 150.0,
                          height: 150.0,

                        )
                    ),
                    GestureDetector(
                        onTap: (){
                          typeOfActivity = 'Running';
                          showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => _form(context),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              //color: const Color(0xFF58B789),
                              borderRadius: BorderRadius.circular(40),
                              image: const DecorationImage(
                                fit: BoxFit.fill,
                                image: AssetImage('assets/images/Group_9.png'),
                              )
                          ),
                          width: 150.0,
                          height: 150.0,

                        )
                    ),
                  ],),

                const SizedBox(height: 5,),
                Column(
                  children: [
                    const Center(child: Text('Keep up',
                      style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
                    )
                    ),

                    const SizedBox(height: 5,),
                    Container(
                      width: 360,
                      height: 240,
                      //child: Expanded(
                        child: FutureBuilder(
                          future: activityList,
                          builder: (context, snapshot){
                            if(snapshot.hasData){
                              return _myListView((snapshot.data as List<Activity>));
                            }
                            return const Center(child: CircularProgressIndicator());
                          },
                        ),
                    ),
                  ],
                )
              ],
            ),
          )
      ),
    );
  }

  String? _validForm(String? val){
    final _kcalexp = RegExp(_selectedMode == 'kcals->km'
      ?r'^[\d]+$'
      :r'^[\d.]+$');
    if(val!.isEmpty){
      return 'This filed is required';
    }
    else if (!_kcalexp.hasMatch(val)){
      return _selectedMode == 'kcals->km'
          ?'Please enter only digits'
          :'Please enter only digits and \'.\'';
    }else {
      return null;
    }
  }

  void _submitForm(){
    if(_formKey.currentState!.validate()){
      _formKey.currentState?.save();
      Activity newActivity = conversion(user, formVal, _selectedMode!, typeOfActivity);
      _navigateAndDisplaySelection(context, newActivity);
    }
  }

  void _navigateAndDisplaySelection(BuildContext context, Activity newActivity) async {
    var result = await Navigator.popAndPushNamed(context, '/CurrentActivity', arguments: newActivity);
    if(result == 'completed'){
      setState(() {
        DBProvider.db.insertActivity(newActivity);
      });
      updateActivityList();
    }
  }

  Widget _form(context){
    return AlertDialog(
      title: Text(typeOfActivity,
        style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
        ),
      ),
      content:
      Form(
        key: _formKey,
        child: Container(
          height: 175,
          child: Column(
            children: [
              DropdownButtonFormField(
                decoration: const InputDecoration(
                  labelText: 'What mode?',
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 15
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF87A2D6), width: 1.5),
                  ),
                ),
                items: _modes.map((mode){
                  return DropdownMenuItem(child: Text(mode), value: mode,);
                }).toList(),
                onChanged: (String? mode) {
                  setState(() {
                    _selectedMode = mode;
                  });
                },
                value: _selectedMode,
              ),
              const SizedBox(height: 20,),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'How many',
                  labelStyle: TextStyle(
                      color: Colors.black
                  ),
                  hintText: 'Type how many',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff87A2D6), width: 1.5),
                  ),

                ),
                keyboardType: TextInputType.number,
                validator: _validForm,
                onSaved: (value) => formVal = value!,
              ),
            ],
          ),
        )
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: const Text('Cancel',
            style: TextStyle(color: Color(0xFF87A2D6), fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
        TextButton(
          onPressed: _submitForm,
          child: const Text('OK',
            style: TextStyle(color: Color(0xFF87A2D6), fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  ScrollConfiguration _myListView(List<Activity> activity){
    activity = activity.reversed.toList();
    return ScrollConfiguration(
      behavior: const ScrollBehavior(),
      child: GlowingOverscrollIndicator(
        axisDirection: AxisDirection.down,
        color: const Color(0xFFC6D0EB),
        child: ListView.builder(
            itemCount: activity.length,
            itemBuilder: (context, index){
              return Dismissible(
                //key: UniqueKey(),
                key: Key('${activity[index].id}'),
                child: Card(
                  color: const Color(0xFFC6D0EB),
                  borderOnForeground: false,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)
                  ),
                  child: ListTile(
                    //title: Text('${activityList[index].typeOfActivity}, ${activityList[index].date}'),
                    title: Text(activity[index].date,
                      style: const TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('Distance: ${activity[index].distance} km, Burnt: ${activity[index].kcals} kcals',
                      style: const TextStyle(color: Color(0xFF616B83), fontWeight: FontWeight.bold),
                    ),
                    leading: activity[index].typeOfActivity == 'Walking'
                        ? const Image(image: AssetImage('assets/images/noun-walk-1826969.png'),
                          height: 45,
                          width: 45,)
                        : const Image(image: AssetImage('assets/images/noun-running-14752_1.png'),
                          height: 35,
                          width: 35,)
                  ),
                ),
                confirmDismiss:
                    (DismissDirection direction) async{
                  return showDialog<bool>(
                    context: context,
                    builder: (BuildContext context) => _submitDelete(context, activity[index]),
                  );
                },
              );
            }),
      ),
    );
  }

  Widget _submitDelete(BuildContext context,Activity activity){
    return AlertDialog(
      title: const Text('Confirm',
        style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
      ),
      content: const Text('Delete this training?',
        style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('No',
            style: TextStyle(color: Color(0xff87A2D6), fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
        TextButton(
          onPressed: (){
            DBProvider.db.deletActivity(activity.id);
            setState(() {
              //activity.remove(activity[index]);
              updateActivityList();
            });
            Navigator.pop(context, true);
          },
          child: const Text('Yes',
            style: TextStyle(color: Color(0xff87A2D6), fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}


class Help extends StatelessWidget {
  const Help({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xff87A2D6),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Expanded(
                flex: 1,
                child: SizedBox(
                  child: GlowingOverscrollIndicator(
                    color: Colors.deepPurpleAccent,
                    axisDirection: AxisDirection.down,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Text('When you first enter the application, you enter your data, which will be displayed in the "Profile" tab. In the same tab, you can later change these data.'
                          '\n\nThe "Home" tab contains your workouts. To create a workout, select the type of activity (running, walking), and then choose based on what to create a route (calories expended or distance traveled). Then, depending on the previous selection, enter the number of kilocalories or kilometers. Now press the "Ok" button, after which your workout will be created. In the window that appears, you will see the number of kilocalories that will be spent during the training, the distance that will be covered, the "New route" button, after pressing which a training route will be built in the maps you have selected. If you want to change the route, exit the maps, re-enter the session you created, and re-create the route. The "Complete" and "Cancel" buttons are responsible for the successful completion of the workout and for canceling the workout, respectively. Once completed, the workout will be added to your list of completed workouts.'
                          '\n\nIn the "Statistics" tab, you can see how many kilocalories you burned, what distance was covered with a certain type of activity and in total for the week, month, year and for the entire time of using the application.',
                          textAlign: TextAlign.justify,
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(onPressed: (){Navigator.pop(context);}, child: const Text('Ok',
              style: TextStyle(fontWeight: FontWeight.bold),
              ),
                style: ElevatedButton.styleFrom(
                  primary: const Color(0xff87A2D6),
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
  }
}


