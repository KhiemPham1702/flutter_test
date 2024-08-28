import 'package:flutter/material.dart';
import 'package:test_flutter/models/album.dart';
import 'package:test_flutter/models/google_user.dart';
import 'package:test_flutter/models/photo.dart';

class GooglePhotosScreen extends StatefulWidget {
  final PhotoClient photoClient;

  const GooglePhotosScreen({super.key, required this.photoClient});

  @override
  _GooglePhotosScreenState createState() => _GooglePhotosScreenState();
}

class _GooglePhotosScreenState extends State<GooglePhotosScreen> {
  List<Photo> _photos = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchPhotos();
  }

  Future<void> _fetchPhotos() async {
    try {
      List<Album> albums = await widget.photoClient.getAlbums();
      if (albums.isNotEmpty) {
        List<Photo> photos = await widget.photoClient.getPhotos(albums.first.id);
        setState(() {
          _photos = photos;
          _loading = false;
        });
      } else {
        print('No albums found');
        setState(() {
          _loading = false;
        });
      }
    } catch (e) {
      print('Error fetching photos: $e');
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Photos'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _photos.isEmpty
              ? const Center(child: Text('No photos available.'))
              : GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  itemCount: _photos.length,
                  itemBuilder: (context, index) {
                    final photo = _photos[index];
                    return Image.network(
                      '${photo.baseUrl}=w200-h200-c',
                      fit: BoxFit.cover,
                    );
                  },
                ),
    );
  }
}
