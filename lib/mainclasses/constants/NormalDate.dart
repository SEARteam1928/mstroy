class NormalDate {
  ///input type ISO8601
  String reDate(String isoDatetime) {
    var datetimeSplitStr = "$isoDatetime".split("T")[0];
    var dateSplit = datetimeSplitStr.split("-");
    var yearStr = dateSplit[0];
    var mounthStr = dateSplit[1];
    var dayStr = dateSplit[2];
    return "$dayStr.$mounthStr.$yearStr";
  }

  ///input type 2020-06-24 10:24:40.370553
  String formatDateInISO(DateTime dateTime){
    var timeZoneOffset = dateTime.timeZoneOffset;
    var datetimeSplitStr = "$dateTime".split(" ");
    var dateSplit = datetimeSplitStr[0].split("-");
    var timeSplit = datetimeSplitStr[1].split(".")[0].split(":");
    var timezoneOffsetHour = "$timeZoneOffset".split(".")[0].split(":")[0];
    var timezoneOffsetMin = "$timeZoneOffset".split(".")[0].split(":")[1];
    if(int.parse("$timezoneOffsetHour") < 10){
      return "${dateSplit[0]}-${dateSplit[1]}-${dateSplit[2]}T${int.parse(timeSplit[0])-5}:${timeSplit[1]}:${timeSplit[2]}+0$timezoneOffsetHour:$timezoneOffsetMin";
    } else {
      return "${dateSplit[0]}-${dateSplit[1]}-${dateSplit[2]}T${int.parse(timeSplit[0])-5}:${timeSplit[1]}:${timeSplit[2]}+$timezoneOffsetHour:$timezoneOffsetMin";
    }
  }

  String formatDateInCreateView(DateTime dateTime){
    var datetimeSplitStr = "$dateTime".split(" ");
    var dateSplit = datetimeSplitStr[0].split("-");
    return "${dateSplit[2]}.${dateSplit[1]}.${dateSplit[0]}";
  }
}