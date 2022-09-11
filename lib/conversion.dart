import 'user.dart';
import 'package:fitonyashki_projeckt/models/activity.dart';


Activity conversion(User user, String val, String _selectedMode, String typeOfActivity){
  double distance = 0;
  int kcals = 0;
  if(_selectedMode=='kcals->km'){
    kcals = int.parse(val);
  }else {
    distance = double.parse(val);
  }
  var now = DateTime.now();
  final String date =
      '${now.year}-'
      '${now.month<10? '0${now.month}' : now.month}-'
      '${now.day<10? '0${now.day}' : now.day} '


      '${now.hour<10? '0${now.hour}' : now.hour}:'
      '${now.minute<10? '0${now.minute}' : now.minute}';

  if(typeOfActivity == 'Walking') {
    distance==0
        ? distance = walkingConv(user, distance, kcals)
        : kcals = walkingConv(user, distance, kcals).toInt();
  }
  if(typeOfActivity == 'Running') {
    distance==0
        ? distance = runningConv(user, distance, kcals)
        : kcals = runningConv(user, distance, kcals).toInt();
  }
  distance = double.parse((distance).toStringAsFixed(2));
  Activity newActivity = Activity(
    id: null,
    typeOfActivity: typeOfActivity,
    kcals: kcals,
    distance: distance,
    date: date,
  );
  return newActivity;
}

double runningConv(User user, double distance, int kcals){
  double result;
  if(distance == 0){
    result = kcals * 10 / (60 * ((0.035 * user.weight + (2.78 * 2.78 * 0.029 * user.weight * 100 / user.height)))) ;
  }else{
    result = (0.035 * user.weight + (2.78 * 2.78 * 0.029 * user.weight * 100 / user.height)) * 60 * distance / 10 ;
  }
  return result;
}

double walkingConv(User user, double distance, int kcals){
  double result;
  if(distance == 0){
    result = kcals * 5 / (60 * ((0.035 * user.weight + (1.39 * 1.39 * 0.029 * user.weight * 100 / user.height))));
  }else{
    result = (0.035 * user.weight + (1.39 * 1.39 * 0.029 * user.weight * 100 / user.height)) * 60 * distance / 5 ;
  }
  return result;
}