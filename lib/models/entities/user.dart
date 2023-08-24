class UserInfo {
  int id = 0;
  String? email;
  String? fullname;
  String? phone;
  String? country;
  String? username;
  String? address1;
  String? address2;
  String? city;
  String? province;
  String? avatar;
  String? cabang;
  String? zipcode;
  String? villageid;
  String? village;
  bool? protection;
  bool? tfcStudent;
  bool? subscribe;
  bool? verify;
  String? bankName;
  String? bankNumber;
  String? bankUsername;
  int? mrgid;
  int? askapid;

  UserInfo(
      {required this.id,
      this.email,
      this.fullname,
      this.phone,
      this.country,
      this.username,
      this.address1,
      this.address2,
      this.city,
      this.province,
      this.avatar,
      this.cabang,
      this.zipcode,
      this.villageid,
      this.village,
      this.protection,
      this.tfcStudent,
      this.subscribe,
      this.verify,
      this.bankName,
      this.bankNumber,
      this.bankUsername,
      this.mrgid,
      this.askapid});

  static UserInfo init() {
    return UserInfo(
        id: 0,
        protection: false,
        tfcStudent: false,
        subscribe: false,
        verify: false,
        mrgid: 0,
        askapid: 0);
  }

  static UserInfo clone(UserInfo user) {
    try {
      return UserInfo(
          id: user.id,
          email: user.email,
          fullname: user.fullname,
          phone: user.phone,
          country: user.country,
          username: user.username,
          address1: user.address1,
          address2: user.address2,
          city: user.city,
          province: user.province,
          avatar: user.avatar,
          cabang: user.cabang,
          zipcode: user.zipcode,
          villageid: user.villageid,
          village: user.village,
          protection: user.protection,
          tfcStudent: user.tfcStudent,
          subscribe: user.subscribe,
          verify: user.verify,
          bankName: user.bankName,
          bankNumber: user.bankNumber,
          bankUsername: user.bankUsername,
          mrgid: user.mrgid,
          askapid: user.askapid);
    } catch (xerr) {
      return UserInfo.init();
    }
  }

  static UserInfo fromMap(Map userMap) {
    try {
      return UserInfo(
          id: userMap["id"],
          email: '${userMap["email"]}',
          fullname: '${userMap["fullname"]}',
          phone: '${userMap["phone"]}',
          country: '${userMap["country"]}',
          username: userMap["username"],
          address1: userMap["address1"],
          address2: '${userMap["address2"]}',
          city: '${userMap["city"]}',
          province: '${userMap["province"]}',
          avatar: '${userMap["avatar"]}',
          cabang: '${userMap["cabang"]}',
          zipcode: '${userMap["zipcode"]}',
          villageid: userMap["villageid"],
          village: '${userMap["village"]}',
          protection: userMap["protection"] == 1 ? true : false,
          tfcStudent: userMap["tfcStudent"] == 1 ? true : false,
          subscribe: userMap["subscribe"] == 1 ? true : false,
          verify: userMap["verify"] == 1 ? true : false,
          bankName: '${userMap["bankName"]}',
          bankNumber: '${userMap["bankNumber"]}',
          bankUsername: '${userMap["bankUsername"]}',
          mrgid: userMap["mrgid"],
          askapid: userMap["askapid"]);
    } catch (e) {}
    return UserInfo.init();
  }

  Map toMap() {
    return {
      "id": id,
      "email": email,
      "fullname": fullname,
      "phone": phone,
      "country": country,
      "username": username,
      "address1": address1,
      "address2": address2,
      "city": city,
      "province": province,
      "avatar": avatar,
      "cabang": cabang,
      "zipcode": zipcode,
      "villageid": villageid,
      "village": village,
      "protection": protection,
      "tfcStudent": tfcStudent,
      "subscribe": subscribe,
      "verify": verify,
      "bankName": bankName,
      "bankNumber": bankNumber,
      "bankUsername": bankUsername,
      "mrgid": mrgid,
      "askapid": askapid
    };
  }

  bool isProfileComplete() {
    if (username == null || address1 == null || villageid == null) {
      return false;
    }
    return true;
  }
}

class UserCanSeeSignal {
  final bool? hasDepo;
  final int? daysLeft;
  final DateTime? endDate;
  final bool? canSee;

  UserCanSeeSignal({this.hasDepo, this.daysLeft, this.endDate, this.canSee});

  factory UserCanSeeSignal.fromMap(Map map) => UserCanSeeSignal(
      canSee: map["canSee"],
      endDate: DateTime.parse(map["endDate"]),
      daysLeft: map["daysLeft"],
      hasDepo: map["hasDepo"]);
}
