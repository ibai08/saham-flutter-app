import 'entities/emiten.dart';

class EmitenModels {
  List<MostActiveData>? mostActiveData;
  List<TopGamerData>? topGamerData;
  List<TopLoserData>? topLoserData;
  List<TopVolumeData>? topVolumeData;
  List<EmitenData>? emitenData;

  EmitenModels({this.mostActiveData, this.topGamerData, this.topLoserData, this.topVolumeData, this.emitenData});

  EmitenModels.fromJson(Map<String, dynamic> json) {
    if (json['mostActiveData'] != null) {
      mostActiveData = <MostActiveData>[];
      json['mostActiveData'].forEach((v) {
        mostActiveData!.add(MostActiveData.fromJson(v));
      });
    }
    if (json['topGamerData'] != null) {
      topGamerData = <TopGamerData>[];
      json['topGamerData'].forEach((v) {
        topGamerData!.add(TopGamerData.fromJson(v));
      });
    }
    if (json['topLoserData'] != null) {
      topLoserData = <TopLoserData>[];
      json['topLoserData'].forEach((v) {
        topLoserData!.add(TopLoserData.fromJson(v));
      });
    }
    if (json['topVolumeData'] != null) {
      topVolumeData = <TopVolumeData>[];
      json['topVolumeData'].forEach((v) {
        topVolumeData!.add(TopVolumeData.fromJson(v));
      });
    }
    if (json['emitenData'] != null) {
      emitenData = <EmitenData>[];
      json['emitenData'].forEach((v) {
        emitenData!.add(EmitenData.fromJson(v));
      });
    }
  }
}