// ignore_for_file: avoid_print

class AccountTypeMrg {
  int? id;
  String? name;
  int? mindepo;
  String? minlot;
  String? maxlot;
  String? spread;
  String? swap;
  String? commission;
  String? leverage;
  String? po;
  String? products;
  String? symbol;
  Map? additional;

  AccountTypeMrg(
      {this.id,
      this.name,
      this.mindepo,
      this.minlot,
      this.maxlot,
      this.spread,
      this.swap,
      this.commission,
      this.leverage,
      this.po,
      this.products,
      this.symbol,
      this.additional});

  static AccountTypeMrg init() {
    return AccountTypeMrg(
        id: -1,
        name: "",
        mindepo: 0,
        minlot: "",
        maxlot: "",
        spread: "",
        swap: "",
        commission: "",
        leverage: "",
        po: "",
        products: "",
        symbol: "",
        additional: {});
  }

  static AccountTypeMrg fromMap(Map typeMap) {
    try {
      return AccountTypeMrg(
          id: typeMap["id"],
          name: typeMap["name"],
          mindepo: typeMap["mindepo"],
          minlot: typeMap["minlot"],
          maxlot: typeMap["maxlot"],
          spread: typeMap["spread"],
          swap: typeMap["swap"],
          commission: typeMap["commission"],
          leverage: typeMap["leverage"],
          po: typeMap["po"],
          products: typeMap["products"],
          symbol: typeMap["symbol"],
          additional:
              typeMap["additional"].length > 0 ? typeMap["additional"] : {});
    } catch (e) {
      print(e);
    }
    return AccountTypeMrg.init();
  }

  Map toMap() {
    return {
      "id": id,
      "name": name,
      "mindepo": mindepo,
      "minlot": minlot,
      "maxlot": maxlot,
      "spread": spread,
      "swap": swap,
      "commission": commission,
      "leverage": leverage,
      "po": po,
      "products": products,
      "symbol": symbol,
      "additional": additional ?? {}
    };
  }
}

class UserMRG {
  int? mrgid;
  UserBankMrg? bankInfo;
  String? imgID;
  List<RealAccMrg>? realAccounts;
  List<DemoAccMrg>? demoAccounts;
  List<ContestAccMrg>? contestAccounts;
  bool? canWd;
  List<UserTransactionsMrg>? transactions;
  double? lastSync;
  bool? hasError;
  bool? hasDeposit;
  List<AccountTypeMrg>? accountTypes;

  UserMRG(
      {this.mrgid,
      this.bankInfo,
      this.imgID,
      this.realAccounts,
      this.demoAccounts,
      this.contestAccounts,
      this.canWd,
      this.transactions,
      this.lastSync,
      this.hasError,
      this.hasDeposit,
      this.accountTypes});

  static UserMRG init() {
    return UserMRG(
        mrgid: 0,
        bankInfo: UserBankMrg(),
        imgID: "",
        realAccounts: [],
        demoAccounts: [],
        contestAccounts: [],
        canWd: false,
        transactions: [],
        lastSync: 0,
        hasError: true,
        hasDeposit: false,
        accountTypes: []);
  }

  static UserMRG clone(UserMRG user) {
    try {
      return UserMRG(
          mrgid: user.mrgid,
          bankInfo: user.bankInfo,
          imgID: user.imgID,
          realAccounts: user.realAccounts,
          demoAccounts: user.demoAccounts,
          contestAccounts: user.contestAccounts,
          canWd: user.canWd,
          transactions: user.transactions,
          lastSync: user.lastSync,
          hasError: user.hasError,
          hasDeposit: user.hasDeposit,
          accountTypes: user.accountTypes);
    } catch (xerr) {
      return UserMRG.init();
    }
  }

  static UserMRG fromMap(Map userMap) {
    try {
      return UserMRG(
          mrgid: userMap["mrgid"],
          bankInfo: UserBankMrg.fromMap(userMap["bankInfo"]),
          imgID: userMap["imgID"],
          realAccounts: userMap["realAccounts"].length < 1
              ? []
              : userMap["realAccounts"]
                  .map<RealAccMrg>((json) => RealAccMrg.fromMap(json))
                  .toList(),
          demoAccounts: userMap["demoAccounts"].length < 1
              ? []
              : userMap["demoAccounts"]
                  .map<DemoAccMrg>((json) => DemoAccMrg.fromMap(json))
                  .toList(),
          contestAccounts: userMap["contestAccounts"].length < 1
              ? []
              : userMap["contestAccounts"]
                  .map<ContestAccMrg>((json) => ContestAccMrg.fromMap(json))
                  .toList(),
          canWd: userMap["canWd"],
          transactions: userMap["transactions"].length < 1
              ? []
              : userMap["transactions"]
                  .map<UserTransactionsMrg>(
                      (json) => UserTransactionsMrg.fromMap(json))
                  .toList(),
          lastSync: userMap["lastSync"],
          hasError: userMap["hasError"],
          hasDeposit: userMap["hasDeposit"],
          accountTypes: userMap["accountTypes"].length < 1
              ? []
              : userMap["accountTypes"]
                  .map<AccountTypeMrg>((json) => AccountTypeMrg.fromMap(json))
                  .toList());
    } catch (e) {
      print(e);
    }
    return UserMRG.init();
  }

  Map toMap() {
    return {
      "mrgid": mrgid,
      "bankInfo": bankInfo?.toMap(),
      "imgID": imgID,
      "realAccounts": realAccounts == null
          ? []
          : realAccounts?.map<Map>((json) => json.toMap()).toList(),
      "demoAccounts": demoAccounts == null
          ? []
          : demoAccounts?.map<Map>((json) => json.toMap()).toList(),
      "contestAccounts": contestAccounts == null
          ? []
          : contestAccounts?.map<Map>((json) => json.toMap()).toList(),
      "canWd": canWd,
      "transactions": transactions == null
          ? []
          : transactions?.map<Map>((json) => json.toMap()).toList(),
      "lastSync": lastSync ?? 0,
      "hasError": hasError ?? true,
      "hasDeposit": hasDeposit ?? true,
      "accountTypes": accountTypes == null
          ? []
          : accountTypes?.map<Map>((json) => json.toMap()).toList()
    };
  }
}

class MrgAccount {
  final int? id;
  final int? type;
  final String? login;
  final DateTime? date;

  MrgAccount(this.id, this.type, this.login, this.date);
}

class RealAccMrg extends MrgAccount {
  final int? contest;

  RealAccMrg({id, type, login, date, this.contest})
      : super(id, type, login, date);

  factory RealAccMrg.fromMap(Map json) {
    return RealAccMrg(
      id: json['id'],
      type: json['type'],
      login: json['login'],
      date: DateTime.parse(json['date'].replaceAll('Z', '') + 'Z'),
      contest: json['contest'],
    );
  }

  Map toMap() {
    return {
      "id": id,
      "type": type,
      "login": login,
      "date": date.toString(),
      "contest": contest,
    };
  }
}

class DemoAccMrg extends MrgAccount {
  final String? password;
  final int? status;

  DemoAccMrg({
    id,
    type,
    login,
    date,
    this.password,
    this.status,
  }) : super(
          id,
          type,
          login,
          date,
        );

  factory DemoAccMrg.fromMap(Map<dynamic, dynamic> json) {
    return DemoAccMrg(
      id: json['id'],
      type: json['type'],
      login: json['login'],
      password: json['password'],
      date: DateTime.parse(json['date'].replaceAll('Z', '') + 'Z'),
      status: json['status'],
    );
  }

  Map toMap() {
    return {
      "id": id,
      "type": type,
      "login": login,
      "date": date.toString(),
      "password": password,
      "status": status
    };
  }
}

class ContestAccMrg extends MrgAccount {
  final String? password;
  final DateTime? reqDate;
  final DateTime? depoDate;
  final int? active;

  ContestAccMrg({
    id,
    login,
    this.password,
    this.reqDate,
    this.depoDate,
    this.active,
  }) : super(id, 0, login, reqDate);

  factory ContestAccMrg.fromMap(Map<dynamic, dynamic> json) {
    return ContestAccMrg(
      id: json['id'],
      login: json['user_mt4id'].toString(),
      password: json['password'],
      reqDate: DateTime.parse(json['req_date'].replaceAll('Z', '') + 'Z'),
      depoDate: json['depo_date'] != null
          ? DateTime.parse(json['depo_date'].replaceAll('Z', '') + 'Z')
          : null,
      active: json['active'],
    );
  }

  Map toMap() {
    return {
      "id": id,
      "type": type,
      "user_mt4id": login,
      "date": date.toString(),
      "password": password,
      "active": active,
      "req_date": reqDate.toString(),
      "depo_date":
          depoDate == null ? depoDate : depoDate.toString(),
    };
  }
}

class BankBrokerMrg {
  final String? id;
  final String? bank;
  final String? name;
  final String? no;

  BankBrokerMrg({this.id, this.bank, this.name, this.no});

  factory BankBrokerMrg.fromMap(Map<dynamic, dynamic> json) {
    return BankBrokerMrg(
        id: json['id'], bank: json['bank'], name: json['name'], no: json['no']);
  }
}

class UserBankMrg {
  final String? bank;
  final String? name;
  final String? no;

  UserBankMrg({this.bank, this.name, this.no});

  factory UserBankMrg.fromMap(Map json) {
    return UserBankMrg(bank: json['bank'], name: json['name'], no: json['no']);
  }

  Map toMap() {
    return {"bank": bank, "name": name, "no": no};
  }
}

class UserTransactionsMrg {
  final String? mt4id;
  final double? nominal;
  final int? rate;
  final DateTime? date;
  final int? tipe;
  final int? status;

  UserTransactionsMrg(
      {this.mt4id, this.nominal, this.rate, this.date, this.tipe, this.status});

  factory UserTransactionsMrg.fromMap(Map map) {
    return UserTransactionsMrg(
        mt4id: map["mt4id"],
        nominal: double.parse(map["nominal"]),
        rate: map["rate"],
        date: DateTime.parse(map["date"].replaceAll('Z', '') + 'Z'),
        tipe: map["tipe"],
        status: map["status"]);
  }

  Map toMap() {
    return {
      "mt4id": mt4id,
      "nominal": nominal.toString(),
      "rate": rate,
      "date": date.toString(),
      "tipe": tipe,
      "status": status
    };
  }
}

class MarginInfo {
  final String? mt4id;
  final double? lot;
  final DateTime? createdAt;
  final DateTime? lastLogin;
  final double? balance;
  final double? credit;
  final double? equity;
  final double? margin;
  final double? freeMargin;
  final double? marginIn;
  final double? marginOut;
  final double? marginLevel;
  final double? closed;
  final double? floating;

  MarginInfo(
      {this.mt4id,
      this.lot,
      this.createdAt,
      this.lastLogin,
      this.balance,
      this.credit,
      this.equity,
      this.margin,
      this.freeMargin,
      this.marginIn,
      this.marginOut,
      this.marginLevel,
      this.closed,
      this.floating});

  factory MarginInfo.fromMap(Map map) {
    return MarginInfo(
        mt4id: map["mt4id"],
        lot: double.parse(map["lot"].toString()),
        createdAt: DateTime.parse(map["createdAt"].replaceAll('Z', '') + 'Z'),
        lastLogin: DateTime.parse(map["lastLogin"].replaceAll('Z', '') + 'Z'),
        balance: double.parse(map["balance"].toString()),
        credit: double.parse(map["credit"].toString()),
        equity: double.parse(map["equity"].toString()),
        margin: double.parse(map["margin"].toString()),
        freeMargin: double.parse(map["freeMargin"].toString()),
        marginIn: double.parse(map["marginIn"].toString()),
        marginOut: double.parse(map["marginOut"].toString()),
        marginLevel: double.parse(map["marginlevel"].toString()),
        closed: double.parse(map["closed"].toString()),
        floating: double.parse(map["floating"].toString()));
  }

  Map toMap() {
    return {
      "mt4id": mt4id,
      "lot": lot,
      "createdAt": createdAt.toString(),
      "lastLogin": lastLogin.toString(),
      "balance": balance,
      "credit": credit,
      "equity": equity,
      "margin": margin,
      "freeMargin": freeMargin,
      "marginIn": marginIn,
      "marginOut": marginOut,
      "marginlevel": marginLevel,
      "closed": closed,
      "floating": floating
    };
  }
}

class MarginInOut {
  final String? mt4id;
  final MarginInOutSummary? summary;
  final List<MarginInOutHistory>? history;

  MarginInOut({this.mt4id, this.summary, this.history});

  factory MarginInOut.fromMap(Map map) {
    return MarginInOut(
        mt4id: map["mt4id"],
        summary: MarginInOutSummary.fromMap(map["summary"]),
        history: map["history"].length < 1
            ? []
            : map["history"]
                .map<MarginInOutHistory>(
                    (json) => MarginInOutHistory.fromMap(json))
                .toList());
  }
}

class MarginInOutSummary {
  final double? deposit;
  final double? withdrawal;
  final double? commission;
  final double? adjustment;
  final double? other;

  MarginInOutSummary(
      {this.deposit,
      this.withdrawal,
      this.commission,
      this.adjustment,
      this.other});

  factory MarginInOutSummary.fromMap(Map map) {
    return MarginInOutSummary(
        deposit: double.parse(map["deposit"].toString()),
        withdrawal: double.parse(map["withdrawal"].toString()),
        commission: double.parse(map["commission"].toString()),
        adjustment: double.parse(map["adjustment"].toString()),
        other: double.parse(map["other"].toString()));
  }
}

class MarginInOutHistory {
  final int? no;
  final String? ticket;
  final DateTime? date;
  final String? note;
  final double? amount;

  MarginInOutHistory({this.no, this.ticket, this.date, this.note, this.amount});

  factory MarginInOutHistory.fromMap(Map map) {
    return MarginInOutHistory(
        no: map["no"],
        ticket: map["ticket"],
        date: DateTime.parse(map["date"].replaceAll('Z', '') + 'Z'),
        note: map["note"],
        amount: double.parse(map["amount"].toString()));
  }
}

class ContestScheduleMrg {
  final int? id;
  final String? period;
  final DateTime? eventstart;
  final DateTime? eventend;
  final DateTime? regstart;
  final DateTime? regend;
  final DateTime? infowinner;

  ContestScheduleMrg(
      {this.id,
      this.period,
      this.eventstart,
      this.eventend,
      this.regstart,
      this.regend,
      this.infowinner});

  factory ContestScheduleMrg.fromMap(Map map) {
    return ContestScheduleMrg(
      id: map["id"],
      period: map["period"],
      eventstart: DateTime.parse(map["eventstart"]),
      eventend: DateTime.parse(map["eventend"]),
      regstart: DateTime.parse(map["regstart"]),
      regend: DateTime.parse(map["regend"]),
      infowinner: DateTime.parse(map["infowinner"]),
    );
  }

  Map toMap() {
    return {
      "id": id,
      "period": period,
      "eventstart": eventstart,
      "eventend": eventend,
      "regstart": regstart,
      "regend": regend,
      "infowinner": infowinner
    };
  }
}