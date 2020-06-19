class NormalDate {
  String reDate(String isoDatetime) {
    var datetimeSplitStr = "$isoDatetime".split("T")[0];
    var dateSplit = datetimeSplitStr.split("-");
    var yearStr = dateSplit[0];
    var mounthStr = dateSplit[1];
    var dayStr = dateSplit[2];
    return "$dayStr.$mounthStr.$yearStr";
  }

/*  String reTime(String isoDatetime){
    var datetimeSplitStr = "$isoDatetime".split("T")[1];
    var dateSplit = datetimeSplitStr.split("+");
    var yearStr = dateSplit[0];
    var mounthStr = dateSplit[1];
    var dayStr = dateSplit[2];
    return "$dayStr.$mounthStr.$yearStr";
  }*/
}
