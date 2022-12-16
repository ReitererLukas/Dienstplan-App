enum CarType {
  rtw("RTW"),
  nef("NEF"),
  bktw("BKTW"),
  other("OTHER");

  const CarType(this.value);
  final String value;

  factory CarType.get(String value) {
    if(value.toLowerCase() == "rtw") {
      return CarType.rtw;
    } else if(value.toLowerCase() == "nef") {
      return CarType.nef;
    } else if(value.toLowerCase() == "bktw") {
      return CarType.bktw;
    }

    return CarType.other;
  }
}