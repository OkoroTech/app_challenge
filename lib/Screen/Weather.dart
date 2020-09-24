import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

class WeatherScreen extends StatefulWidget{
  @override
  WeatherScreenState createState() => WeatherScreenState();

}

class WeatherScreenState extends State<WeatherScreen>{
  double long;
  double lat;
  Position position;
  var iconCode;
  Response weatherResponse;
  Map weathermap;
  var header;

   Future getWeather() async{
    position = await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    long = position.longitude;
    lat = position.latitude;
    weatherResponse = await get('https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$long&appid=3d25929c271460f8bf193203ccd13b33');
    header = weatherResponse.body;
    return weathermap = jsonDecode(header);
    
  }
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
        color: Color.fromRGBO(77,172,204, 1),
        padding: EdgeInsets.all(30),
        child: FutureBuilder(
          future: getWeather(),
          builder: (context, snapshot){
            if(weatherResponse == null){
              return Container(
                child: Center
                  (child: CircularProgressIndicator()),
              );
            }
            else if(weatherResponse != null){
              weathermap = jsonDecode(header);
              print(weathermap['name']);
              String city = weathermap['name'];
              String descr = weathermap['weather'][0]['description'];
              String main =  weathermap['weather'][0]['main'];
              int humidity = weathermap['main']['humidity'];
              double kelvin = double.parse(weathermap['main']['temp'].toString());
              double temp = (kelvin - 273.15) * 9/5 + 32 ;
              var timestamp = weathermap['dt'];
              var date = new DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
              var formattedDate = DateFormat.yMMMd().format(date);
              print(MediaQuery.of(context).size.width);
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        child: Image.network('http://openweathermap.org/img/wn/10d@2x.png'),
                      ),
                      Container(
                          alignment: Alignment.center,
                          child: Text('$city', style: TextStyle(fontSize: 35),
                            textAlign: TextAlign.center,)
                      ),
                      Container(
                          alignment: Alignment.center,
                          child: Text('$formattedDate', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w300, color: Colors.white),
                            textAlign: TextAlign.center,)
                      ),
                      Container(
                        alignment: Alignment.center,
                          child: Text('${temp.floor()}°', style: TextStyle(fontSize: 100, color: Colors.white),
                            textAlign: TextAlign.center,)
                      )
                    ],
                  ),
                  MediaQuery.of(context).size.width > 700 ?
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 50),
                          alignment: Alignment.center,
                          child: Text('$main', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500, color: Colors.white),
                            textAlign: TextAlign.center,)
                      ),
                      Container(
                          margin: EdgeInsets.only(left: 50),
                          alignment: Alignment.center,
                          child: Text('$descr', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500, color: Colors.white),
                            textAlign: TextAlign.center,)
                      ),
                      Container(
                          margin: EdgeInsets.only(left: 50),
                          alignment: Alignment.center,
                          child: Text('Humidity-$humidity', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500, color: Colors.white),
                            textAlign: TextAlign.center,)
                      ),
                    ],
                  ): Container(),

                ],
              );
            }
            return Container();
          },
        ),
      ),
    );
  }

}