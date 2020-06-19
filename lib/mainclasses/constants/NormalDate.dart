class NormalDate {
  String reDate(String isoDate) {
    var datetimeSplitStr = "$isoDate".split("T")[0];
    var dateSplit = datetimeSplitStr.split("-");
    var yearStr = dateSplit[0];
    var mounthStr = dateSplit[1];
    var dayStr = dateSplit[2];
    return "$dayStr.$mounthStr.$yearStr";
  }
}
