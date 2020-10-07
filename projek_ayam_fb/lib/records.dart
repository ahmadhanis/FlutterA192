import 'package:firebase_database/firebase_database.dart';

class Record {
  String recordid,
      description,
      day,
      month,
      year,
      dead,
      alive,
      supervisor,
      date,
      imageName,
      imageUrl;

  Record(
      {this.recordid,
      this.description,
      this.date,
      this.dead,
      this.alive,
      this.day,
      this.month,
      this.year,
      this.supervisor,
      this.imageName,
      this.imageUrl});

  String getIndex(int index) {
    switch (index) {
      case 0:
        return recordid;
      case 1:
        return description;
      case 2:
        return date;
      case 3:
        return dead;
      case 4:
        return alive;
      case 5:
        return supervisor;
    }
    return '';
  }

  Record.fromSnapshot(DataSnapshot snapshot)
      : recordid = snapshot.value["recordid"].toString(),
        description = snapshot.value["description"],
        date = snapshot.value["date"],
        dead = snapshot.value["dead"].toString(),
        alive = snapshot.value["alive"],
        supervisor = snapshot.value["supervisor"],
        day = snapshot.value["day"],
        month = snapshot.value["month"],
        year = snapshot.value["year"];

  toJson() {
    return {
      "recordid": recordid,
      "description": description,
      "date": date,
      "dead": dead,
      "alive": alive,
      "supervisor": supervisor,
      "day": day,
      "month": month,
      "year": year
    };
  }
}
