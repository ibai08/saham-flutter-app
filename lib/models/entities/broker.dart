class Broker {
  final String id;
  final String shortName;
  final String fullName;

  Broker({this.id, this.shortName, this.fullName});
}

Map<String, Broker> brokerList = {
  "mrg" : Broker(id: "mrg", shortName: "ABC", fullName: "ABC"),
  "askap" : Broker(id: "askap", shortName: "DEFGHIJK", fullName: "DEFGHIJK"),
};