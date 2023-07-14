enum InboxType { wptfpost, signal, html, payment }

enum InboxTag { must, trending, updates, payment, important }

class InboxCount {
  int mustRead;
  int trending;
  int important;
  int payment;

  InboxCount(
      {this.important = 0,
      this.mustRead = 0,
      this.payment = 0,
      this.trending = 0});

  factory InboxCount.init() {
    return InboxCount(important: 0, mustRead: 0, payment: 0, trending: 0);
  }

  factory InboxCount.fromMap(Map map) {
    return InboxCount(
        important: map["important"] == null
            ? 0
            : int.parse(map["important"].toString()),
        mustRead: map["must"] == null ? 0 : int.parse(map["must"].toString()),
        payment:
            map["payment"] == null ? 0 : int.parse(map["payment"].toString()),
        trending: map["trending"] == null
            ? 0
            : int.parse(map["trending"].toString()));
  }

  Map toMap() {
    return {
      "important": important,
      "must": mustRead,
      "payment": payment,
      "trending": trending,
    };
  }

  int get total => important + mustRead + payment + trending;
}
