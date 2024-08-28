class Album {
  final String id;
  final String title;
  final String coverPhotoBaseUrl;

  Album(this.id, this.title, this.coverPhotoBaseUrl);

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      json["id"],
      json["title"],
      json["coverPhotoBaseUrl"],
    );
  }
}