import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gexxx_flutter/models/user.dart';
import 'package:gexxx_flutter/screens/CropProfile.dart';
import 'package:gexxx_flutter/screens/MainDrawer.dart';
import 'package:gexxx_flutter/screens/addcrop.dart';
import 'package:gexxx_flutter/screens/authenticate/AuthenticationHome.dart';
import 'package:gexxx_flutter/services/auth.dart';
import 'package:gexxx_flutter/utilities/MyhorizantalDivider.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:gexxx_flutter/database/database.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatefulWidget {
  final User user;

  const Home({Key key, this.user}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<Home> {
  Map data;
  List CropData;

  Future getData() async {
    http.Response response = await http.get(
        "https://api.data.gov.in/resource/9ef84268-d588-465a-a308-a864a43d0070?api-key=579b464db66ec23bdd000001cdd3946e44ce4aad7209ff7b23ac571b&format=json&offset=0&limit=30");
    data = json.decode(response.body);
    //debugPrint(response.body);
    setState(() {
      CropData = data["records"];
    });

    //debugPrint(CropData.toString());
    //print(CropData.length);
  }

  Container MyFeed(String crop_name, String state) {
    return Container(
      margin: EdgeInsets.all(15),
      width: MediaQuery.of(context).size.width,
      height: 300,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: <Widget>[
          AutoSizeText(
            crop_name,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
            minFontSize: 15,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 10),
          AutoSizeText(
            state,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
            minFontSize: 10,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  GestureDetector MyCrop(String imageval, String crop_name, String price) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    CropProfile(cropname: crop_name, price: price)),
          );
        },
        child: Row(
          children: <Widget>[
            Container(
                width: MediaQuery.of(context).size.width * 0.3,
                decoration: BoxDecoration(color: Colors.black),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 10),
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: NetworkImage(imageval),
                                fit: BoxFit.fill)),
                      ),
                      SizedBox(height: 10),
                      Text(
                        crop_name,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700),
                      )
                    ],
                  ),
                )),
            //MyVerticalDivider2(),
          ],
        ));
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final user = Provider.of<User>(context);
    return StreamBuilder<UserData>(
      stream: DatabaseService(uid:user.uid).userData,
      builder: (context,snapshot)
      {
      
          UserData userData = snapshot.data;
          return Scaffold(
          appBar: AppBar(
            actions: <Widget>[
              FlatButton.icon(
                  onPressed: () async {
                    await _auth.signOut();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AuthenticationHome()));
                  },
                  icon: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                  label: Text(
                    'Logout',
                    style: TextStyle(color: Colors.white),
                  ))
            ],
            title: Center(
              child: Text('GEXXX'),
            ),
            backgroundColor: Colors.black,
          ),
          backgroundColor: Colors.black,
          drawer: MainDrawer(),
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(height: 20),
                Text('Welcome ${userData.name}',
                    style: TextStyle(color: Colors.white)),
                    
                Stack(
                      children: <Widget>[
                        Container(
                      margin: EdgeInsets.only(top: 20,left:20,right:20),
                    height: MediaQuery.of(context).size.height * 0.18,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(color: Colors.grey[900],borderRadius: BorderRadius.circular(10)),
                    child:Center(child: Text('Empty',style: TextStyle(color: Colors.white),)),
                        ),
                        Center(
                          child: Container(
                            margin: EdgeInsets.only(top:160),
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(color: Colors.blue[700],shape: BoxShape.circle),
                            child: IconButton(icon: Icon(Icons.add,color: Colors.white,),
                            onPressed: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>addcrop()));
                            },)),
                        ),
                      ]),

              
                /*Container(
                    decoration: BoxDecoration(color: Colors.black),
                    margin: EdgeInsets.only(top: 20),
                    height: MediaQuery.of(context).size.height * 0.15,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: CropData == null ? 0 : CropData.length,
                        itemBuilder: (BuildContext context, int index) {
                          return //Text('as');
                              MyCrop(
                                  "https://images.unsplash.com/photo-1503023345310-bd7c1de61c7d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=701&q=80",
                                  "${CropData[index]["variety"]}",
                                  "${CropData[index]["modal_price"]}");
                        })),*/
                SizedBox(
                  height: 20,
                ),
                MyhorizontalDivider(),
                SizedBox(height: 20),
                Text(
                  'CARDS',
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      fontFamily: "OpenSans"),
                ),
                SizedBox(height: 40),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        margin: EdgeInsets.only(left: 20, right: 20),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.08,
                        decoration: BoxDecoration(
                            color: Colors.blue[800],
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                            child: Text(
                          'News',
                          style: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                              fontFamily: "OpenSans"),
                        )),
                      ),
                    ),
                    SizedBox(height: 15),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        margin: EdgeInsets.only(left: 20, right: 20),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.08,
                        decoration: BoxDecoration(
                            color: Colors.blue[800],
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                            child: Text(
                          'Crops',
                          style: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                              fontFamily: "OpenSans"),
                        )),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ));
        
      }

      
    );
  }
}
