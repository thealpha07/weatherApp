import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class weatherScreen extends StatefulWidget {
  const weatherScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => HomeState();

}

class HomeState extends State<weatherScreen> {

  var url = 'http://api.openweathermap.org/data/2.5/weather?q=Yelahanka&units=metric&appid=f49938d57e29e03394fe7442ac635bb0';
  var temperature;
  var status;
  var weather;
  var wind;
  var humidity;

  Future getWeather () async {
    http.Response response = await http.get(Uri.parse(url));
    var APIresults = jsonDecode(response.body);
    setState(() {
      this.temperature = APIresults['main']['temp'];
      this.status = APIresults['weather'][0]['description'];
      this.weather = APIresults['weather'][0]['main'];
      this.wind = APIresults['wind']['speed'];
      this.humidity = APIresults['main']['humidity'];
    });
  }

  @override
  void initState () {
    super.initState();
    this.getWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height/3,
            width: MediaQuery.of(context).size.width,
            color: Colors.lightGreen,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(padding: EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    "Currently in Yelahanka",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600
                    ),
                  ),
                ),
                Text(
                  temperature != null ? temperature.toString() + "\u00B0" : "Loading",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 40.0,
                      fontWeight: FontWeight.w600
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    status != null ? status.toString() : "Loading",
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Times New Roman',
                        fontSize: 36.0,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: ListView(
                children: <Widget>[
                  ListTile(
                    leading: FaIcon(FontAwesomeIcons.thermometerThreeQuarters),
                    title: Text('Temperature:'),
                    trailing: Text(temperature != null ? temperature.toString() + "\u00B0" : "Loading"),
                  ),
                  ListTile(
                    leading: FaIcon(FontAwesomeIcons.cloud),
                    title: Text('Weather:'),
                    trailing: Text(weather != null ? weather.toString() : "Loading"),
                  ),
                  ListTile(
                    leading: FaIcon(FontAwesomeIcons.wind),
                    title: Text('Wind:'),
                    trailing: Text(wind != null ? wind.toString() +" m/s" : "Loading"),
                  ),
                  ListTile(
                    leading: FaIcon(FontAwesomeIcons.sun),
                    title: Text('Humidity:'),
                    trailing: Text(humidity != null ? humidity.toString() +"%" : "Loading"),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

