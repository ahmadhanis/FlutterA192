class TDS {
  const TDS(this.tdsid, this.tdsval, this.temp, this.date);

  final String tdsid;
  final String tdsval;
  final String temp;
  final String date;

  String getIndex(int index) {
    switch (index) {
      case 0:
        return tdsid;
      case 1:
        return tdsval;
      case 2:
        return temp;
      case 3:
        return date;
    }
    return '';
  }
}
