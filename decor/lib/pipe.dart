class Pipe {
  const Pipe(this.pipeid, this.location, this.pressure, this.date, this.status,
      this.description, this.latitude, this.longitude);

  final String pipeid;
  final String pressure;
  final String location;
  final String description;
  final String date;
  final String status;
  final String latitude, longitude;

  String getIndex(int index) {
    switch (index) {
      case 0:
        return pipeid;
      case 1:
        return location;
      case 2:
        return pressure;
      case 3:
        return date;
      case 4:
        return status;
      case 5:
        return description;
      case 6:
        return latitude;
      case 7:
        return longitude;
    }
    return '';
  }
}
