import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as prefix0;
import 'package:gexxx_flutter/models/Crop.dart';

import 'package:gexxx_flutter/models/user.dart';

class DatabaseService {
  final String uid;

  DatabaseService({this.uid});

  final CollectionReference UsersCollection =
      Firestore.instance.collection('Users');
  final CollectionReference CropsCollection =
      Firestore.instance.collection('Crops');


  

  Future<bool> UpdateUserDetails(String name ,String phonenumber,String gender,String age,String state,int statenumber,String district,String village,String image,String language,String languagecode) async
  {
    try{
      await UsersCollection.document(uid).setData({
        'uid':uid,
        'name':name,
        'gender':gender,
        'age':age,
        'state':state,
        'district':district,
        'village':village,
        'image':image,
        'phonenumber':phonenumber , 
        'statenumber':statenumber,
        'language':language,
        'languagecode':languagecode,     

      });
      return true;
    }catch(e)
    {
      print(e.toString());
      return false;
    }
  }

  Future<bool> UpdateCropsCollection(
      String uid,
      String season,
      String crop,
      String area,
      String areaunit,
      String productivity,
      String productivityunit,
      DateTime transplantingdate,
      String image,String landtype,String landtopography,String landsize,String landsizeunit,String soil) async {
    try {
      await UsersCollection.document(uid)
          .collection('crops')
          .document(crop)
          .setData({
        'uid': uid,
        'season': season,
        'crop': crop,
        'area': area,
        'areaunit': areaunit,
        'productivity': productivity,
        'productivityunit': productivityunit,
        'transplantingdate': transplantingdate,
        'image': image,
        'landtype':landtype,
        'landtopography':landtopography,
        'landsize':landsize,
        'landsizeunit':landsizeunit,
        'soil':soil,
      });
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  UserData _userDataFromSnapShot(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      name: snapshot.data["name"],
      phonenumber: snapshot.data["phonenumber"],
      state: snapshot.data["state"],
      village: snapshot.data["village"],
      district: snapshot.data["district"],
      gender: snapshot.data["gender"],
      image: snapshot.data["image"],
      age: snapshot.data["age"],
      statenumber: snapshot.data["statenumber"],
      language: snapshot.data["language"],
      languagecode: snapshot.data["languagecode"]
    );
  }


  //collection stream
  Stream<UserData> get userData {
    return UsersCollection.document(uid).snapshots().map(_userDataFromSnapShot);
  }

  

  Future<UserData> checkphonenumber(String phonenumber) async {
    QuerySnapshot querysnapshot = await UsersCollection.where("phonenumber", isEqualTo: phonenumber).getDocuments();
   
    if (querysnapshot.documents.isNotEmpty) {
     
     return UserData(
       uid: querysnapshot.documents[0]["uid"],
       name: querysnapshot.documents[0]["name"],
       phonenumber: querysnapshot.documents[0]["phonenumber"],
       state: querysnapshot.documents[0]["state"],
       district: querysnapshot.documents[0]["district"],
       village: querysnapshot.documents[0]["village"],
       age: querysnapshot.documents[0]["age"],
       gender: querysnapshot.documents[0]["gender"],
       statenumber: querysnapshot.documents[0]["statenumber"],
       image: querysnapshot.documents[0]["image"],
       language: querysnapshot.documents[0]["language"],
       languagecode: querysnapshot.documents[0]["languagecode"],
     );
    }
     else
     {
       return null;
     }
      

    
   
  }

  Future<bool> checklocation() async
  {
    DocumentSnapshot snapshot = await UsersCollection.document(uid).get();
    if(snapshot.data["state"]=='')
    {
      return false;
    }
    else
    {
      return true;
    }
  }

  Future<UserData> getuserdocument() async{
    DocumentSnapshot snapshot1 = await UsersCollection.document(uid).get();
   
    if(snapshot1.data.isNotEmpty)
    {
      return UserData(
      uid: uid,
      name: snapshot1.data["name"],
      phonenumber: snapshot1.data["phonenumber"],
      state: snapshot1.data["state"],
      village: snapshot1.data["village"],
      district: snapshot1.data["district"],
      gender: snapshot1.data["gender"],
      image: snapshot1.data["image"],
      statenumber: snapshot1.data["statenumber"],
      age:snapshot1.data["age"],
      language: snapshot1.data["language"],
      languagecode: snapshot1.data["languagecode"],
     

      

    );
    }
    else
    {
      return null;
    }
    
  }



  Future getmycrops(String uid) async {
    QuerySnapshot snapshot =
        await UsersCollection.document(uid).collection('crops').getDocuments();
    return snapshot.documents;
  }

  Future deletecrop(String name) async {
    await UsersCollection.document(uid).collection('crops').document(name).delete();
  }
}