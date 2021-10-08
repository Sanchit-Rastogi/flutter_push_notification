import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:push_notification/services/notifyService.dart';
import 'package:push_notification/screens/second.dart';

class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  @override
  void initState() {
    super.initState();
    NotifyService.init();
    listenNotification();
  }

  void listenNotification() =>
      NotifyService.onNotification.stream.listen(onClickedNotification);

  void onClickedNotification(String? payload) => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SecondPage(
            titleText: payload,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Push Notification"),
      ),
      body: Container(
        width: size.width,
        height: size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(
              CupertinoIcons.bell_circle_fill,
              size: 200,
              color: Colors.blue,
            ),
            Column(
              children: [
                Text(
                  'Local Notification',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 30),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 40),
                  child: ElevatedButton(
                    onPressed: () => NotifyService.showNotification(
                      title: 'Test Title',
                      body: 'This is a test of simple notification.',
                      payload: 'Test payload',
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(15),
                      child: Row(
                        children: [
                          Icon(CupertinoIcons.bell, size: 30),
                          SizedBox(width: 30),
                          Text(
                            'Simple Notification',
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 40),
                  child: ElevatedButton(
                    onPressed: () {
                      NotifyService.showSecheduledNotification(
                        title: 'Scheduled Notification',
                        body: 'This is a test of scheduled notification.',
                        payload: 'Scheduled payload',
                        scheduledTime:
                            DateTime.now().add(Duration(seconds: 10)),
                      );
                      final snackBar = SnackBar(
                        content: Text('Notification Scheduled in 10s'),
                      );
                      ScaffoldMessenger.of(context)
                        ..removeCurrentSnackBar()
                        ..showSnackBar(snackBar);
                    },
                    child: Padding(
                      padding: EdgeInsets.all(15),
                      child: Row(
                        children: [
                          Icon(CupertinoIcons.time, size: 30),
                          SizedBox(width: 30),
                          Text(
                            'Scheduled Notification',
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
