
class Activity{
  late String typeOfActivity;
  late String date;
  late double distance ;
  late int kcals;
  late int? id;

  Activity({required this.id,
    required this.typeOfActivity,
    required this.date,
    required this.distance,
    required this.kcals
  });

  Map<String, dynamic> toMap(){
    final map = Map<String, dynamic>();
    map['id'] = id;
    map['typeOfActivity'] = typeOfActivity;
    map['date'] = date;
    map['distance'] = distance;
    map['kcals'] = kcals;
    return map;
  }

  Activity.fromMap(Map<String, dynamic> map){
    id = map['id'];
    typeOfActivity = map['typeOfActivity'];
    date = map['date'];
    distance = map['distance'];
    kcals = map['kcals'];
  }

}