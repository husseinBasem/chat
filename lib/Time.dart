import 'package:intl/intl.dart';

class Time {

  String messageTime(String time){
    DateTime date = DateTime.parse(time);

    DateTime date1 = DateTime.now();

    //year
    if(int.parse(date1.toString().substring(0,4)) >int.parse(date.toString().substring(0,4))){
      return DateFormat("yMd").format(date);

    }else{

      //month
      if(int.parse(date1.toString().substring(5,7)) >int.parse(date.toString().substring(5,7))){
        return DateFormat("MMM").format(date);

      }else{
        //time

        if (int.parse(date1.toString().substring(8,10)) > int.parse(date.toString().substring(8,10))+7){
          return date.toString().substring(5,10);

        }
        else if(int.parse(date1.toString().substring(8,10)) > int.parse(date.toString().substring(8,10))){
          return DateFormat("E").format(date);


        } else{
          return DateFormat.jm().format(date);
        }

      }

    }


  }
}