class MostActiveData {
  String imageText;
  String name;
  String companyName;
  String rank;
  String percentage;

  MostActiveData({this.imageText, this.name, this.companyName, this.rank, this.percentage});

  MostActiveData.fromJson(Map<String, dynamic> json) {
    imageText = json['imageText'];
    name = json['name'];
    companyName = json['companyName'];
    rank = json['rank'];
    percentage = json['percentage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['imageText'] = imageText;
    data['name'] = name;
    data['companyName'] = companyName;
    data['rank'] = rank;
    data['percentage'] = percentage;
    return data; 
  }
}

class TopGamerData {
  String imageText;
  String name;
  String companyName;
  String rank;
  String percentage;

  TopGamerData({this.imageText, this.name, this.companyName, this.rank, this.percentage});

  TopGamerData.fromJson(Map<String, dynamic> json) {
    imageText = json['imageText'];
    name = json['name'];
    companyName = json['companyName'];
    rank = json['rank'];
    percentage = json['percentage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['imageText'] = imageText;
    data['name'] = name;
    data['companyName'] = companyName;
    data['rank'] = rank;
    data['percentage'] = percentage;
    return data; 
  }
}

class TopLoserData {
  String imageText;
  String name;
  String companyName;
  String rank;
  String percentage;

  TopLoserData({this.imageText, this.name, this.companyName, this.rank, this.percentage});

  TopLoserData.fromJson(Map<String, dynamic> json) {
    imageText = json['imageText'];
    name = json['name'];
    companyName = json['companyName'];
    rank = json['rank'];
    percentage = json['percentage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['imageText'] = imageText;
    data['name'] = name;
    data['companyName'] = companyName;
    data['rank'] = rank;
    data['percentage'] = percentage;
    return data; 
  }
}

class TopVolumeData {
  String imageText;
  String name;
  String companyName;
  String rank;
  String percentage;

  TopVolumeData({this.imageText, this.name, this.companyName, this.rank, this.percentage});

  TopVolumeData.fromJson(Map<String, dynamic> json) {
    imageText = json['imageText'];
    name = json['name'];
    companyName = json['companyName'];
    rank = json['rank'];
    percentage = json['percentage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['imageText'] = imageText;
    data['name'] = name;
    data['companyName'] = companyName;
    data['rank'] = rank;
    data['percentage'] = percentage;
    return data; 
  }
}

class EmitenData {
  String imageText;
  String name;
  String companyName;
  String rank;
  String percentage;

  EmitenData({this.imageText, this.name, this.companyName, this.rank, this.percentage});

  EmitenData.fromJson(Map<String, dynamic> json) {
    imageText = json['imageText'];
    name = json['name'];
    companyName = json['companyName'];
    rank = json['rank'];
    percentage = json['percentage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['imageText'] = imageText;
    data['name'] = name;
    data['companyName'] = companyName;
    data['rank'] = rank;
    data['percentage'] = percentage;
    return data; 
  }
}