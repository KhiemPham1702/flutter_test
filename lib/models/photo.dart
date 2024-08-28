class Photo {
  final String baseUrl;

  Photo(this.baseUrl);

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(json["baseUrl"]);
  }
}