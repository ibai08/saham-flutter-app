class AccountTypeAskap {
  int id;
  String name;
  String mindepo;
  String minlot;
  String maxlot;
  String maxopenlot;
  String spread;
  String swap;
  String commission;
  String leverage;
  String po;
  String insurance;
  String style;
  String rules;
  List<String> additional;

  AccountTypeAskap(
      {this.id,
      this.name,
      this.mindepo,
      this.minlot,
      this.maxlot,
      this.maxopenlot,
      this.spread,
      this.swap,
      this.commission,
      this.leverage,
      this.po,
      this.insurance,
      this.style,
      this.rules,
      this.additional});

  static AccountTypeAskap init() {
    return AccountTypeAskap(
        id: -1,
        name: "",
        mindepo: "",
        minlot: "",
        maxlot: "",
        maxopenlot: "",
        spread: "",
        swap: "",
        commission: "",
        leverage: "",
        po: "",
        insurance: "",
        style: "",
        rules: "",
        additional: []);
  }

  static AccountTypeAskap fromMap(Map typeMap) {
    return AccountTypeAskap(
        id: typeMap["id"],
        name: typeMap["name"],
        mindepo: typeMap["mindepo"] ?? "",
        minlot: typeMap["minlot"] ?? "",
        maxlot: typeMap["maxlot"] ?? "",
        maxopenlot: typeMap["maxopenlot"] ?? "",
        spread: typeMap["spread"] ?? "",
        swap: typeMap["swap"] ?? "",
        commission: typeMap["commission"] ?? "",
        leverage: typeMap["leverage"] ?? "",
        po: typeMap["po"] ?? "",
        insurance: typeMap["insurance"] ?? "",
        style: typeMap["style"] ?? "",
        rules: typeMap["rules"] ?? "",
        additional:
            typeMap["additional"] == null || typeMap["additional"].length < 1
                ? []
                : typeMap["additional"]);
  }

  Map toMap() {
    return {
      "id": id,
      "name": name,
      "mindepo": mindepo,
      "minlot": minlot,
      "maxlot": maxlot,
      "maxopenlot": maxopenlot,
      "spread": spread,
      "swap": swap,
      "commission": commission,
      "leverage": leverage,
      "po": po,
      "insurance": insurance,
      "style": style,
      "rules": rules,
      "additional": additional ?? []
    };
  }
}

class UserAskap {
  int askapid;
  List<RealAccAskap> realAccounts;
  List<DemoAccAskap> demoAccounts;
  List<UserTransactionsAskap> transactions;
  double lastSync;
  bool hasError;
  bool hasDeposit;
  List<AccountTypeAskap> accountTypes;

  UserAskap(
      {this.askapid,
      this.realAccounts,
      this.demoAccounts,
      this.transactions,
      this.lastSync,
      this.hasError,
      this.hasDeposit,
      this.accountTypes});

  factory UserAskap.init() {
    return UserAskap(
        askapid: 0,
        realAccounts: [],
        demoAccounts: [],
        transactions: [],
        lastSync: 0,
        hasError: true,
        hasDeposit: false,
        accountTypes: []);
  }

  static UserAskap clone(UserAskap user) {
    try {
      return UserAskap(
          askapid: user.askapid,
          realAccounts: user.realAccounts,
          demoAccounts: user.demoAccounts,
          transactions: user.transactions,
          lastSync: user.lastSync,
          hasError: user.hasError,
          hasDeposit: user.hasDeposit,
          accountTypes: user.accountTypes);
    } catch (x) {
      return UserAskap.init();
    }
  }

  factory UserAskap.fromMap(Map map) {
    return UserAskap(
        askapid: map["askapid"],
        realAccounts: map["realAccounts"].length < 1
            ? []
            : map["realAccounts"]
                .map<RealAccAskap>((json) => RealAccAskap.fromMap(json))
                .toList(),
        demoAccounts: map["demoAccounts"].length < 1
            ? []
            : map["demoAccounts"]
                .map<DemoAccAskap>((json) => DemoAccAskap.fromMap(json))
                .toList(),
        transactions: map["transactions"].length < 1
            ? []
            : map["transactions"]
                .map<UserTransactionsAskap>(
                    (json) => UserTransactionsAskap.fromMap(json))
                .toList(),
        lastSync: map["lastSync"],
        hasError: map["hasError"],
        hasDeposit: map["hasDeposit"],
        accountTypes: map["accountTypes"].length < 1
            ? []
            : map["accountTypes"]
                .map<AccountTypeAskap>((json) => AccountTypeAskap.fromMap(json))
                .toList());
  }

  Map toMap() {
    return {
      "askapid": askapid,
      "realAccounts": realAccounts == null
          ? []
          : realAccounts.map<Map>((json) => json.toMap()).toList(),
      "demoAccounts": demoAccounts == null
          ? []
          : demoAccounts.map<Map>((json) => json.toMap()).toList(),
      "transactions": transactions == null
          ? []
          : transactions.map<Map>((json) => json.toMap()).toList(),
      "lastSync": lastSync ?? 0,
      "hasError": hasError ?? true,
      "hasDeposit": hasDeposit ?? true,
      "accountTypes": accountTypes == null
          ? []
          : accountTypes.map<Map>((json) => json.toMap()).toList(),
    };
  }
}

class AskapAcc {
  final int type;
  final String login;
  final DateTime date;

  AskapAcc(this.type, this.login, this.date);
}

class RealAccAskap extends AskapAcc {
  final String orderNo;
  final String bank;
  final String bankno;
  final String bankname;

  RealAccAskap(
      {type, login, date, this.orderNo, this.bank, this.bankno, this.bankname})
      : super(type, login, date);

  factory RealAccAskap.fromMap(Map map) {
    return RealAccAskap(
        type: map["type"],
        login: map["login"],
        date: DateTime.parse(map["date"].replaceAll('Z', '') + 'Z'),
        orderNo: map["orderNo"],
        bank: map["bank"],
        bankno: map["bankno"],
        bankname: map["bankname"]);
  }

  Map toMap() {
    return {
      "type": type,
      "login": login,
      "date": date.toString(),
      "orderNo": orderNo,
      "bank": bank,
      "bankno": bankno,
      "bankname": bankname
    };
  }
}

class DemoAccAskap extends AskapAcc {
  final String password;
  final DateTime reqDate;
  final int status;

  DemoAccAskap({type, login, date, this.reqDate, this.password, this.status})
      : super(type, login, date);

  factory DemoAccAskap.fromMap(Map json) {
    return DemoAccAskap(
      type: json['type'],
      login: json['login'],
      password: json['password'],
      date: DateTime.parse(json["date"].replaceAll('Z', '') + 'Z'),
      reqDate: DateTime.parse(json['reqDate'].replaceAll('Z', '') + 'Z'),
      status: json['status'],
    );
  }

  Map toMap() {
    return {
      "type": type,
      "login": login,
      "password": password,
      "date": date.toString(),
      "reqDate": reqDate.toString(),
      "status": status
    };
  }
}

class UserTransactionsAskap {
  final String mt4id;
  final double nominal;
  final int rate;
  final DateTime date;
  final int tipe;
  final int status;
  final int idr;

  UserTransactionsAskap(
      {this.mt4id,
      this.nominal,
      this.rate,
      this.date,
      this.tipe,
      this.status,
      this.idr});

  factory UserTransactionsAskap.fromMap(Map map) {
    return UserTransactionsAskap(
        mt4id: map["mt4id"],
        nominal: double.parse(map["nominal"]),
        rate: map["rate"],
        date: DateTime.parse(map["date"].replaceAll('Z', '') + 'Z'),
        tipe: map["tipe"],
        status: map["status"],
        idr: map["idr"]);
  }

  Map toMap() {
    return {
      "mt4id": mt4id,
      "nominal": nominal.toString(),
      "rate": rate,
      "date": date.toString(),
      "tipe": tipe,
      "status": status,
      "idr": idr
    };
  }
}

class BankBrokerAskap {
  final int id;
  final String bank;
  final String name;
  final String no;
  final String symbol;

  BankBrokerAskap({this.id, this.bank, this.name, this.no, this.symbol});

  factory BankBrokerAskap.fromMap(Map json) {
    return BankBrokerAskap(
        id: json['id'],
        bank: json['bank'],
        name: json['name'],
        no: json['no'],
        symbol: json['symbol']);
  }

  Map toMap() {
    return {
      "id": id,
      "bank": bank,
      "no": no,
      "symbol": symbol
    };
  }
}