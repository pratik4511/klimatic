import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../utility/utils.dart' as util;
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/src/services/text_input.dart';

class Klimatic extends StatefulWidget {
  @override
  _KlimaticState createState() => _KlimaticState();
}

class _KlimaticState extends State<Klimatic> {
  String _cityentered;
  // code to go next screen //
  Future _goTONextScreen(BuildContext context) async {
    Map result = await Navigator.of(context)
        .push(new MaterialPageRoute(builder: (BuildContext context) {
      return new ChangeCity();
    }));

    if (result != null && result.containsKey('enter')) {
      _cityentered = result['enter'];
    }
  }

  void showStuff() async {
    Map data = await getWeather(util.apiID, util.defaultCity);
    print(data.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Klimatic"),
        backgroundColor: Colors.redAccent,
        actions: <Widget>[
          new IconButton(
              icon: new Icon(Icons.add_location),
              onPressed: () {
                _goTONextScreen(context);
              }),
        ],
      ),
      body: new Stack(
        children: <Widget>[
          new Center(
            child: new Image.asset(
              "images/umbrella.png",
              height: 1500,
              width: 500,
              fit: BoxFit.cover,
            ),
          ),
          new Container(
            alignment: Alignment.topRight,
            margin: const EdgeInsets.fromLTRB(0.0, 10.5, 15.5, 0.0),
            child: new Text(
              '${_cityentered == null ? util.defaultCity : _cityentered}',
              style: TextStyle(
                fontSize: 40.0,
                fontWeight: FontWeight.w400,
                color: Colors.white,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),

          new Container(
            alignment: Alignment.center,
            child: Image.asset('images/light_rain.png'),
          ),

          // new container for weather information //
          new Container(
            margin: const EdgeInsets.fromLTRB(40.0, 500.0, 0, 0),
            child: updateTempWidget(_cityentered),
//             child: new Text('23.7C',
//               style: tempText(),
//             ),
          )
        ],
      ),
    );
  }
}

Future<Map> getWeather(String apiID, String city) async {
  String apiurl =
      'http://api.openweathermap.org/data/2.5/weather?q=$city&APPID='
      '${util.apiID}&units=imperial';
  http.Response response = await http.get(apiurl);
  return json.decode(response.body);
}

Widget updateTempWidget(String city) {
  return new FutureBuilder(
      future: getWeather(util.apiID, city == null ? util.defaultCity : city),
      builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
        // we get all JSON data and set etc.....//
        if (snapshot.hasData) {
          Map content = snapshot.data;
          return new Container(
            child: new Column(
              children: <Widget>[
                new ListTile(
                  title: new Text(
                    "Temp : ${content['main']['temp'].toString() + ' F'}",
                    style: new TextStyle(
                      fontStyle: FontStyle.normal,
                      fontSize: 40.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: new ListTile(
                    title: new Text(
                      "Humidity : ${content['main']['humidity'].toString()}\n"
                      "Min : ${content['main']['temp_min'].toString()} F\n"
                      "Max : ${content['main']['temp_max'].toString()} F\n",
                      style: new TextStyle(
                        fontStyle: FontStyle.normal,
                        fontSize: 23.0,
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        } else {
          return new Container();
        }
      });
}

// to go next screen //
class ChangeCity extends StatelessWidget {
  var _cityFieldController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Change City'),
        backgroundColor: Colors.blue[300],
        centerTitle: true,
      ),
      body: new Stack(
        children: <Widget>[
          new Center(
            child: new Image.asset(
              'images/white_snow.png',
              width: 500,
              height: 1000,
              fit: BoxFit.cover,
            ),
          ),
          new ListView(
            children: <Widget>[
              new ListTile(
                title: new TextField(
                  decoration: new InputDecoration(
                    hintText: 'Vadodara,IN',
                  ),
                  controller: _cityFieldController,
                  keyboardType: TextInputType.text,
                ),
              ),
              new ListTile(
                title: new FlatButton(
                  onPressed: () {
                    Navigator.pop(
                        context, {'enter': _cityFieldController.text});
                  },
                  textColor: Colors.white70,
                  color: Colors.redAccent,
                  child: new Text('Get Weather'),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

TextStyle tempText() {
  return new TextStyle(
    color: Colors.white,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w900,
    fontSize: 35.0,
  );
}
