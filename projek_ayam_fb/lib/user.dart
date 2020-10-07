import 'package:firebase_database/firebase_database.dart';

class User {
  String name,
      icno,
      phone,
      location,
      latitude,
      longitude,
      address,
      datejoin,
      status,
      imageUrl,
      docid;

  User(
      {this.name,
      this.icno,
      this.phone,
      this.location,
      this.latitude,
      this.longitude,
      this.address,
      this.datejoin,
      this.status,
      this.imageUrl,
      this.docid});

  User.fromSnapshot(DataSnapshot snapshot)
      : icno = snapshot.value["icno"].toString(),
        name = snapshot.value["name"],
        address = snapshot.value["address"],
        phone = snapshot.value["phone"].toString(),
        location = snapshot.value["location"],
        latitude = snapshot.value["latitude"].toString(),
        longitude = snapshot.value["longitude"].toString(),
        datejoin = snapshot.value["datejoin"],
        status = snapshot.value["status"],
        imageUrl = snapshot.value["imageUrl"],
        docid = snapshot.value["docid"];

  toJson() {
    return {
      "icno": icno.toString(),
      "name": name,
      "address": address,
      "phone": phone.toString(),
      "location": location,
      "latitude": latitude.toString(),
      "longitude": longitude.toString(),
      "datejoin": datejoin,
      "status": status,
      "imageUrl": imageUrl
    };
  }
}
