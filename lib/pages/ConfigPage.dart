import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_info/device_info.dart';
import 'package:http/http.dart' as http;
import 'package:geoworkerv4/pages/GeoworkerPage.dart';

class ConfigPage extends StatefulWidget {
  ConfigPage({Key key}) : super(key: key);

  _ConfigPageState createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {

  final serverNameController = TextEditingController();
  final deviceNameController = TextEditingController();
  final threadsController = TextEditingController();

  bool isLoading = false;
  bool isError = true;
  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    _loadPreferences();

    isLoading = false;
    isError = true;
    errorMessage = "";
  }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      body: new SingleChildScrollView(
        child: new Padding(
          padding: EdgeInsets.fromLTRB(24.0, 160.0, 24.0, 24.0),
          child: new Column(
            children: <Widget>[
              TextField(
                controller: serverNameController,
                keyboardType: TextInputType.url,
                decoration: InputDecoration(
                    labelText: 'Server',
                    labelStyle: new TextStyle(color: Colors.white),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                ),
                style: TextStyle(color: Colors.white),
              ),

              SizedBox(height: 12.0),

              TextField(
                controller: deviceNameController,
                decoration: InputDecoration(
                    labelText: 'Device name',
                    labelStyle: new TextStyle(color: Colors.white),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                ),
                style: TextStyle(color: Colors.white),
              ),

              SizedBox(height: 12.0),

              TextField(
                controller: threadsController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: 'Sub procesos',
                    labelStyle: new TextStyle(color: Colors.white),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                ),
                style: TextStyle(color: Colors.white),
              ),

              SizedBox(height: 12.0),

              Text(
                isError ? errorMessage : "",
                style: TextStyle(
                    color: Colors.red[900]
                ),
              ),

              SizedBox(height: 24.0),

              RaisedButton(
                // child: Text(isLoading ? 'CARGANDO ...' : 'GO'),
                child: Text(isLoading ? 'CARGANDO ...' : 'GO'),
                textColor: Colors.blue,
                onPressed: () {
                  _testServer(context);
                  print("READY TO GO");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  _loadPreferences() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    // print('Running on ${androidInfo.model}'); 

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _server = prefs.getString('SERVER');
    String _device = prefs.getString('DEVICE');
    String _threads = prefs.getString('THREADS');
    setState(() {
      serverNameController.text = (_server == null || _server.length == 0) ? 'http://192.168.0.170:2193' : _server;
      deviceNameController.text = (_device == null || _device.length == 0) ? androidInfo.model : _server ;
      threadsController.text = (_threads == null || _threads.length == 0) ? '5' : _threads ;
    });
  }
  _savePreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('SERVER', serverNameController.text);
    await prefs.setString('DEVICE', deviceNameController.text);
    await prefs.setString('THREADS', threadsController.text);
  }
  _testServer(BuildContext context) async {
    if (this.isLoading == false) {
      setState(() {
        this.isLoading = true;
      });
      bool _isError = false;
      String _errorMessage = "";
      await http.get('${serverNameController.text}/ping').then((response) {
        _savePreferences();
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            maintainState: false,
            builder: (context) => new GeoworkerPage(
              title: 'Geoworker',
              threads: int.parse(threadsController.text),
              server: serverNameController.text,
            )
          ), (Route<dynamic> route) => false
        );
      }).catchError((error) {
        _isError = true;
        _errorMessage = 'No se puede acceder al servidor (${serverNameController.text}/ping). ${error.toString()}';
      });
      setState(() {
        isLoading = false;
        isError = _isError;
        errorMessage = _errorMessage;
      });
    }
  }
}
