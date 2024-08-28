import 'dart:convert';
import 'dart:io';
import 'package:googleapis_auth/auth_io.dart';
import 'package:url_launcher/url_launcher.dart';

class PhotosService {
  static const clientId = '982168382702-8pvg6viu5dlr41batvl19bnehmvdgba4.apps.googleusercontent.com';
  final List<String> _scopes = [
    'https://www.googleapis.com/auth/photoslibrary'
  ];

  Future<AuthClient> getHttpClient() async {
    AuthClient authClient =
        await clientViaUserConsent(ClientId(clientId), _scopes, _userPrompt).catchError((e) => print(e));
    return authClient;
  }

  upload(File file) async {
    AuthClient client = await getHttpClient();

    var tokenResult = await client.post(
      Uri.parse('https://photoslibrary.googleapis.com/v1/uploads'),
      headers: {
        'Content-type': 'application/octet-stream',
        'X-Goog-Upload-Content-Type': 'image/png',
        'X-Goog-Upload-Protocol': 'raw'
      },
      body: file.readAsBytesSync(),
    );
    print(tokenResult);
    var res = await client.post(
      Uri.parse(
          'https://photoslibrary.googleapis.com/v1/mediaItems:batchCreate'),
      headers: {'Content-type':'application/json' },
      body: jsonEncode({
        "newMediaItems": [
          {
            "description": "item-description",
            "simpleMediaItem": {
              "fileName": "flutter-photos-upload",
              "uploadToken": tokenResult.body,
            }
          }
        ]
      }),
    );

    print(res.body);
  }

  _userPrompt(String url) {
    print(url);
    launch(url);
  }
}
