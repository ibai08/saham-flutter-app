class PostState {
  final int id;
  final int image;
  final String title;
  final String desc;
  final String url;

  PostState({
    this.id,
    this.image,
    this.title,
    this.desc,
    this.url,
  });

  factory PostState.fromJson(Map<String, dynamic> json) {
    return PostState(
      id: json['id'],
      image: json['featured_media'],
      title: json['title']['rendered'],
      desc: json['excerpt']['rendered'],
      url: json['link']
    );
  }
}

class PostDetails {
  final int id;
  final String title;
  final String desc;
  final String date;
  final String author;

  PostDetails({this.id, this.title, this.desc, this.date, this.author});
}

class SlidePromo {
  final String title;
  final String desc;
  final String image;
  final String url;

  SlidePromo({this.desc, this.image, this.title, this.url});

  factory SlidePromo.fromJson(Map<dynamic, dynamic> json) {
    return SlidePromo(
      desc: json['description'],
      image: json['url_img'],
      title: json['title'],
      url: json['url_link']
    );
  }
}

class SlidePromoJSON {
  final String title;
  final String desc;
  final String image;
  final String url;

  SlidePromoJSON({this.desc, this.image, this.title, this.url});

  factory SlidePromoJSON.fromJson(Map<dynamic, dynamic> json) {
    return SlidePromoJSON(
      desc: json['desc'],
      image: json['image'],
      title: json['title'],
      url: json['url']
    );
  }
}