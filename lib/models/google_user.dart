import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:test_flutter/models/album.dart';
import 'package:test_flutter/models/photo.dart';

class PhotoClient {
  final Future<Map<String, String>> authHeaders;

  PhotoClient(this.authHeaders);

  Future<List<Album>> getAlbums() async {
    var response = await http.get(
      Uri.parse("https://photoslibrary.googleapis.com/v1/albums?pageSize=50"),
      headers: await authHeaders,
    );

    if (response.statusCode != 200) {
      print(response.body);
      return [];
    }

    var json = jsonDecode(response.body);
    var albums = json["albums"] as Iterable;

    return albums.map((data) => Album.fromJson(data)).toList();
  }

  Future<List<Photo>> getPhotos(String albumId) async {
    var response = await http.post(
      Uri.parse("https://photoslibrary.googleapis.com/v1/mediaItems:search"),
      headers: await authHeaders,
      body: jsonEncode({
        "pageSize": "100",
        "albumId": albumId,
      })
    );
    if (response.statusCode != 200) {
      print(response.body);
      return [];
    }

    var json = jsonDecode(response.body);
    var mediaItems = (json["mediaItems"] as Iterable);

    return mediaItems.map((json) => Photo.fromJson(json)).toList();
  }
}