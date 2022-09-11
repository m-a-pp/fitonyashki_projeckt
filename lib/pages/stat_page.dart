import 'package:flutter/material.dart';
import 'package:fitonyashki_projeckt/pages/home_page.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fitonyashki_projeckt/models/activity.dart';


class stat extends StatefulWidget {
  const stat({Key? key}) : super(key: key);

  @override
  State<stat> createState() => _statState();
}

class _statState extends State<stat> {
  List<String> periods = ['Week','Month','Year','In total'];
  String selectedPeriod = 'Week';
  late double walkingTotal;
  late double runningTotal;
  int touchedIndex = -1;
  bool statMode = false;
  List<Activity>? activities;
  @override

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            //SizedBox(height: 30,),
            const Text('Training statistics',
              style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),),
            DropdownButton<String>(
              value: selectedPeriod,
              icon: const Icon(Icons.calendar_today_outlined,color: Color(0xFF616B83),),
              elevation: 1,
              style: const TextStyle(color: Color(0xFF616B83), fontSize: 20, fontWeight: FontWeight.bold),
              underline: Container(
                height: 2,
                color: Color(0xFF616B83),
              ),
              onChanged: (String? newValue) {
                setState(() {
                  selectedPeriod = newValue!;
                });
              },
              items: periods.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            //SizedBox(height: 30,),
            FutureBuilder(
              future: activityList,
              builder: (context, snapshot){
                if(snapshot.hasData){
                  return  _activityStat((snapshot.data as List<Activity>));
                }
                return const Text('No data',
                  style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
                );
              },
            ),
          ],
        ),
      ),
    );

  }
  Widget _activityStat(List<Activity> activity){
    activities = activity;
    walkingTotal = statMode ? _walkingKcalsCalc() : _walkingDistCalc();
    runningTotal = statMode ? _runningKcalsCalc() : _runningDistCalc();
    return Stack(
      children: [
        Container(height: 350,
          width: 350,

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            //color: Color(0xFFDEEDF5),
          ),
        ),
        Positioned(
          bottom: 20,
         child: Container(
              //color: Color(0xFFDEEDF5),
              width: 350,
              height: 350,
              child: _pieChart(),
            ),
        ),
        Positioned(
          bottom: 20,
          left: 5,
          child: Container(
            width: 340,
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 15,
                          height: 15,
                          color: Color(0xFF88A9FE),
                        ),
                        SizedBox(width: 8,),
                        Text('Running, total: ${runningTotal.toStringAsFixed(1)} ${statMode ? 'kcals' : 'km'}',
                          style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),

                    Row(
                      children: [
                        Container(
                          width: 15,
                          height: 15,
                          color: Color(0xFF6B74C2),
                        ),
                        SizedBox(width: 8,),
                        Text('Walking, total: ${walkingTotal.toStringAsFixed(1)} ${statMode ? 'kcals' : 'km'}',
                          style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Positioned(
          child: IconButton(
            icon: const Icon(Icons.chevron_left, color: Colors.blueGrey, size: 40,),
            onPressed: (){
              setState(() {
                statMode = !statMode;
              });

            },
          ),
          top: 130,
          left: 0,
        ),
        Positioned(
          child: IconButton(
            icon: const Icon(Icons.chevron_right, color: Colors.blueGrey, size: 40,),
            onPressed: (){
              setState(() {
                statMode = !statMode;
              });
            },
          ),
          top: 130,
          right: 0,
        ),
      ] ,
    );
  }
  Widget _pieChart(){

   return Column(
     crossAxisAlignment: CrossAxisAlignment.center,
     children: [
       Expanded(
        flex: 1,
        child: PieChart(
          PieChartData(
            // pieTouchData: PieTouchData(touchCallback:
            //    (FlTouchEvent event, pieTouchResponse) {
            //    setState(() {
            //      if (!event.isInterestedForInteractions ||
            //        pieTouchResponse == null ||
            //        pieTouchResponse.touchedSection == null) {
            //        touchedIndex = -1;
            //        return;
            //      }
            //      touchedIndex = pieTouchResponse
            //          .touchedSection!.touchedSectionIndex;
            //    });
            //  } ),
             borderData: FlBorderData(
               show: false,
             ),
             sectionsSpace: 15,
             centerSpaceRadius: 100,
             sections: _totalStatShowingSections()),
         ),
       ),
     ],
    );
  }
  List<PieChartSectionData> _totalStatShowingSections() {
    walkingTotal = statMode ? _walkingKcalsCalc() : _walkingDistCalc();
    runningTotal = statMode ? _runningKcalsCalc() : _runningDistCalc();
    return List.generate(2, (i) {
      //final isTouched = i == touchedIndex;
      const fontSize =  16.0;
      const radius = 15.0;
      switch (i) {
        case 0:
          return PieChartSectionData(
            showTitle: false,
            color: Color(0xFF6B74C2),
            value: walkingTotal,
            //title: '${(walkingTotal*100/(walkingTotal+ runningTotal)).toStringAsFixed(1) }%',
            radius: radius,
            titleStyle: const TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          );
        case 1:
          return PieChartSectionData(
            showTitle: false,
            color: Color(0xFF88A9FE),
            value: runningTotal,
            //title: '${runningTotal.toStringAsFixed(1)} ${statMode ? 'kcals' : 'km'}',
            radius: radius,
            titleStyle: const TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Color(0xffffffff)),
          );
        default:
          throw Error();
      }
    });
  }

  double _walkingKcalsCalc(){
    double totalkcals = 0;
    activities!.forEach((element) {
      if(element.typeOfActivity == 'Walking' && _inPeriod(element.date)){
        totalkcals += element.kcals;
      }
    });
    return totalkcals;
  }

  double _runningKcalsCalc(){
    double totalkcals = 0;
    activities!.forEach((element) {
      if(element.typeOfActivity == 'Running' && _inPeriod(element.date)){
        totalkcals += element.kcals;
      }
    });
    return totalkcals;
  }

  double _walkingDistCalc(){
    double totalkcals = 0;
    activities!.forEach((element) {
      if(element.typeOfActivity == 'Walking' && _inPeriod(element.date)){
        totalkcals += element.distance;
      }
    });
    return totalkcals;
  }

  double _runningDistCalc(){
    double totalkcals = 0;
    activities!.forEach((element) {
      if(element.typeOfActivity == 'Running' && _inPeriod(element.date)){
          totalkcals += element.distance;
      }
    });
    return totalkcals;
  }

  bool _inPeriod(String stringDate){
    int? dur;
    if(selectedPeriod == 'Week'){

      dur = 7;
    }
    if(selectedPeriod == 'Month'){

      dur = 30;
    }
    if(selectedPeriod == 'Year'){

      dur = 365;
    }
    if(selectedPeriod == 'In total'){

      return true;
    }
    DateTime eventDate = DateTime.parse(stringDate);
    DateTime compDate = (DateTime.now()).subtract(Duration(days: dur!));
    if(eventDate.compareTo(compDate)<0){
      return false;
    }
    return true;
  }
}
