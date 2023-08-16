class Events {
  String? name;
  String? id;
  List<Images>? images;
  Dates? dates;
  List<Classifications>? classifications;

  Events({this.name, this.id, this.images, this.dates, this.classifications});

  factory Events.fromJson(Map<String, dynamic> json) {
    return Events(
        name: json['name'],
        id: json['id'],
        images:
            (json['images'] as List).map((e) => Images.fromJson(e)).toList(),
        dates: Dates.fromJson(json['dates']),
        classifications: (json['classifications'] as List)
            .map((e) => Classifications.fromJson(e))
            .toList());
  }
}

class Images {
  String? url;

  Images({this.url});

  factory Images.fromJson(Map<String, dynamic> json) {
    return Images(url: json['url']);
  }
}

class Dates {
  Start? start;

  Dates({this.start});

  factory Dates.fromJson(Map<String, dynamic> json) {
    return Dates(start: Start.fromJson(json['start']));
  }
}

class Start {
  String? localDate;

  Start({this.localDate});

  factory Start.fromJson(Map<String, dynamic> json) {
    return Start(localDate: json['localDate']);
  }
}

class Classifications {
  Genre genre;

  Classifications({required this.genre});

  factory Classifications.fromJson(Map<String, dynamic> json) {
    return Classifications(genre: Genre.fromJson(json['genre']));
  }
}

class Genre {
  String name;

  Genre({required this.name});

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(name: json['name']);
  }
}
