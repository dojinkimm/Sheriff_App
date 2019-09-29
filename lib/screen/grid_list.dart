import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../blocs/information_bloc.dart';
import '../models/data.dart';


class GridList extends StatelessWidget {
  final infoBloc;
  GridList({Key key, this.infoBloc}) : super (key : key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: infoBloc.$outInformation,
      builder: (_, AsyncSnapshot snapshot){
        if (!snapshot.hasData) {
          return Container();
        }else{
          List<Data> data = snapshot.data;
          return _gridList(data, context);
        }
      },
      
    );
  }

  Widget _gridList(List<Data> data, BuildContext context){
    return GridView.builder(
      gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, mainAxisSpacing: 0.0, crossAxisSpacing: 0.0),
      padding: const EdgeInsets.all(15.0),
      itemCount: data.length,
      itemBuilder: (_, int index) {
        Data d = data[index];
        Color cardColor = index%2==0? Color.fromRGBO(132, 108, 77, 1) : Color.fromRGBO(153, 134, 104, 1);

        return _buildCard(context, d, cardColor);
      });
  }

  Widget _buildCard(BuildContext context, Data d, Color cardColor){
    return Container(
          child: InkWell(
            onTap: (){
              if (d.status==BlockStatus.ADMIN){
                infoBloc.eventSink.add(AdminClick());
              }else if(d.status==BlockStatus.CORRECTIONS){
                infoBloc.eventSink.add(CorrectionsClick());
              }else if(d.status==BlockStatus.SERVICES){
                infoBloc.eventSink.add(ServicesClick());
              }else if(d.status==BlockStatus.SNS){
                infoBloc.eventSink.add(SocialMediaClick());
              }else if(d.status==BlockStatus.BACK){
                infoBloc.eventSink.add(StartEvent());
              }else if (d.status==BlockStatus.URL_LAUNCHER){
                _launchURL(d.url);
              }
            },
            child: Card(
            color: cardColor,
            child: Container(
              alignment: Alignment.center,
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(d.icon, color: Colors.white, size:MediaQuery.of(context).size.width*0.13),
                SizedBox(height: 10.0,),
                Center(child: AutoSizeText(d.title, style: TextStyle(color: Colors.white), maxLines: 2),)
              ],
            ),
            )
          ),
          )
        );
  }

  _launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

}