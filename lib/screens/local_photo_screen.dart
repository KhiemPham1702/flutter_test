import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class LocalPhotosScreen extends StatefulWidget {
  const LocalPhotosScreen({super.key});

  @override
  _LocalPhotosScreenState createState() => _LocalPhotosScreenState();
}

class _LocalPhotosScreenState extends State<LocalPhotosScreen> {
  List<AssetEntity>? _imageFiles;
  List<AssetPathEntity> _albums = [];
  AssetPathEntity? _selectedAlbum;

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _loadImages() async {
    final permission = await PhotoManager.requestPermissionExtend();
    if (permission.isAuth) {
      _albums = await PhotoManager.getAssetPathList(
        type: RequestType.image,
      );
      setState(() {
        _selectedAlbum = _albums.isNotEmpty ? _albums.first : null;
        _loadAlbumImages();
      });
    } else {
      PhotoManager.openSetting();
    }
  }

  Future<void> _loadAlbumImages() async {
    if (_selectedAlbum != null) {
      final images = await _selectedAlbum!.getAssetListRange(
        start: 0,
        end: 100,
      );
      setState(() {
        _imageFiles = images;
      });
    }
  }

  Future<void> _addAlbum() async {
    String? albumName = await _showAlbumDialog('Add Album');
    if (albumName != null) {
      setState(() {
        _loadImages();
      });
    }
  }

  Future<void> _deleteAlbum() async {
    if (_selectedAlbum != null) {
      bool? confirm = await _showConfirmationDialog('Delete Album');
      if (confirm == true) {
        setState(() {
          _loadImages();
        });
      }
    }
  }

  Future<void> _editAlbum() async {
    if (_selectedAlbum != null) {
      String? newAlbumName = await _showAlbumDialog('Edit Album', initialValue: _selectedAlbum!.name);
      if (newAlbumName != null) {
        setState(() {
          _loadImages();
        });
      }
    }
  }

  Future<String?> _showAlbumDialog(String title, {String? initialValue}) async {
    final TextEditingController controller = TextEditingController(text: initialValue);
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Album Name'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, controller.text),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<bool?> _showConfirmationDialog(String title) async {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: const Text('Are you sure you want to proceed?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Local Photos'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'Add':
                  _addAlbum();
                  break;
                case 'Delete':
                  _deleteAlbum();
                  break;
                case 'Edit':
                  _editAlbum();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'Add', child: Text('Add Album')),
              const PopupMenuItem(value: 'Delete', child: Text('Delete Album')),
              const PopupMenuItem(value: 'Edit', child: Text('Edit Album')),
            ],
          ),
        ],
      ),
      body: _imageFiles != null
          ? GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemCount: _imageFiles!.length,
              itemBuilder: (context, index) {
                return FutureBuilder<Widget>(
                  future: _imageFiles![index].thumbnailDataWithSize(
                    const ThumbnailSize(200, 200),
                  ).then((data) {
                    return data != null ? Image.memory(
                      data,
                      fit: BoxFit.cover,
                    ) : Container(color: Colors.grey);
                  }),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return snapshot.data!;
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                );
              },
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
