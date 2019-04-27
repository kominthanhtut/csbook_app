import 'package:csbruno_app/model/Instance.dart';
import 'package:csbruno_app/model/Song.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  void getInstances(Song song){
    Instance.get(song).then((List<Instance> instances) {
      var toastText = "";
      instances.forEach((a){
        toastText += a.choir.toString()+"\n";
      });
      print(toastText);
    }
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: FutureBuilder(
          future: Song.get(0, 0),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return new Text('loading...');
              default:
                if (snapshot.hasError)
                  return new Text('Error: ${snapshot.error}');
                else
                  return new ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (snapshot.data[index].hasAuthor()) {
                        return new ListTile(
                          title: new Text(snapshot.data[index].getTitle()),
                          subtitle: new Text(snapshot.data[index].getAuthor()),
                          onTap: () {
                            getInstances(snapshot.data[index]);
                          },
                        );
                      } else {
                        return new ListTile(
                          title: new Text(snapshot.data[index].getTitle()),
                          onTap: () {
                            getInstances(snapshot.data[index]);
                          },
                        );
                      }
                    },
                  );
                ;
            }
          },
        ));
  }
}
