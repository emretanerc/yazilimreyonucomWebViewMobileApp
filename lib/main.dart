import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:simple_connection_checker/simple_connection_checker.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_model/job_view_model.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: MyHomePage(title: 'Yazılım Reyonu'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void initState() {
    super.initState();
    initialization();
  }

  void initialization() async {
    bool hasConnection = await internetControl();

    if (hasConnection) {
      print('ready in 3...');
      await Future.delayed(const Duration(seconds: 1));
      print('ready in 2...');
      await Future.delayed(const Duration(seconds: 1));
      print('go!');
      FlutterNativeSplash.remove();
      getSetting();
    } else {
      Fluttertoast.showToast(
          msg: "Lütfen internetinizi açıp tekrar deneyiniz.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          textColor: Colors.white,
          fontSize: 25.0);
      SystemNavigator.pop();
    }
  }

  int _selectedIndex = 0;
  String url = "https://www.yazilimreyonu.com";
  String telephoneNumber = "";
  String logoUrl = "";

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  late WebViewController _webViewController;

  void getSetting() {
    late var job = context.read<JobViewModel>().jobList[0];
    telephoneNumber = job.whatsapp;
    logoUrl = job.logo;
  }

  void _onItemTapped(int index) {
    setState(() {
      switch (index) {
        case 0:
          url = "https://www.yazilimreyonu.com";
          _webViewController.loadUrl(url);
          _selectedIndex = index;
          break;
        case 1:
          url = "https://yazilimreyonu.com/hizmetlerimiz";
          _webViewController.loadUrl(url);
          _selectedIndex = index;
          break;
        case 2:
          url = "https://yazilimreyonu.com/referanslarimiz";
          _webViewController.loadUrl(url);
          _selectedIndex = index;
          break;
        case 3:
          url = "https://api.whatsapp.com/send/?phone=905416776960";
          _webViewController.loadUrl(url);
          _selectedIndex = index;
          break;
        default:
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.deepPurple,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: telephoneNumber,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.design_services),
            label: 'Hizmetlerimiz',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.web),
            label: 'Referanslarımız',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.whatsapp),
            label: 'İletişim',
          ),
        ],
        currentIndex: _selectedIndex,
        unselectedItemColor: Colors.white70,
        selectedItemColor: Colors.white,
        onTap: _onItemTapped,
      ),
      drawer: Drawer(
        backgroundColor: Colors.deepPurple,
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.all(25.0),
          children: [
            ListTile(
              title: const Text('Item 1'),
              subtitle: const Text('Test'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              title: const Text('Item 2'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Builder(
        builder: (BuildContext context) {
          return WebView(
            zoomEnabled: false,
            initialUrl: url,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _webViewController = webViewController;
              _controller.complete(webViewController);
            },
            onProgress: (int progress) {
              print("WebView is loading (progress : $progress%)");
            },
            javascriptChannels: <JavascriptChannel>{
              _toasterJavascriptChannel(context),
            },
            navigationDelegate: (NavigationRequest request) {
              if (request.url.startsWith('https://www.youtube.com/')) {
                print('blocking navigation to $request}');
                return NavigationDecision.prevent;
              }
              print('allowing navigation to $request');
              return NavigationDecision.navigate;
            },
            onPageStarted: (String url) {
              print('Page started loading: $url');
            },
            onPageFinished: (String url) {
              print('Page finished loading: $url');

              _webViewController.runJavascript(
                  "document.getElementsByTagName('header')[0].style.display='none'");
              _webViewController.runJavascript(
                  "document.getElementsByTagName('footer')[0].style.display='none'");
            },
            gestureNavigationEnabled: true,
          );
        },
      ),
    );
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          // ignore: deprecated_member_use
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }
}

internetControl() async {
  bool status = await SimpleConnectionChecker.isConnectedToInternet();

  if (status) {
    print("internet var");
    return true;
  } else {
    print("internet yok");
    return false;
  }
}

class JobView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: null);
  }
}
