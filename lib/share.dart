import 'dart:io';
import 'dart:typed_data';

import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/foundation.dart';

class ShareUtil {
  static Future<void> shareFromURL(String url, String name) async {
    var request = await HttpClient().getUrl(Uri.parse(url));
    var response = await request.close();
    Uint8List bytes = await consolidateHttpClientResponseBytes(response);

    await Share.file(name, name + '.gif', bytes, 'image/gif');
  }
}
