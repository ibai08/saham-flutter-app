class OfficeState{
  final String branch;
  final String building;
  final String address;
  final String city;
  final String postalCode;
  final String phone;
  final String phoneCode;
  final String sms;
  final String smsMessage;
  final String whatsapp;
  final String whatsappMessage;
  final String mapLocation;
  final String openDay;
  final String openHour;

  OfficeState({this.branch, this.building, this.address, this.city, this.postalCode, this.phoneCode, this.phone, this.sms, this.smsMessage, this.whatsapp, this.whatsappMessage, this.mapLocation, this.openDay, this.openHour});

  factory OfficeState.fromJson(Map json) {
    return OfficeState(
      address: json["address"],
      branch: json["branch"],
      building: json["building"],
      city: json["city"],
      mapLocation: json["location"],
      openDay: json["open_day"],
      openHour: json["open_hour"],
      phone: json["phone"],
      phoneCode: json["phone_code"],
      postalCode: json["postal"],
      sms: json["sms"],
      smsMessage: json["sms_message"],
      whatsapp: json["whatsapp"],
      whatsappMessage: json["whatsapp_message"],
    );
  }
}