import 'package:firebase_dynamic_link_example/view/register.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';

class DynamicLinksApi {
  final dynamicLink = FirebaseDynamicLinks.instance;

  Future<void> initDynamicLinks(BuildContext context) async {
    FirebaseDynamicLinks.instance.onLink(
      onSuccess: (PendingDynamicLinkData? dynamicLink) async {
        handleSuccessLinking(data: dynamicLink, context: context);
      },
      onError: (OnLinkErrorException e) async {
        debugPrint('onLinkError');
        debugPrint(e.message);
      },
    );
  }

  void handleSuccessLinking(
      {PendingDynamicLinkData? data, BuildContext? context}) {
    final Uri? deepLink = data?.link;

    if (deepLink != null) {
      var isRefer = deepLink.pathSegments.contains('referans');
      if (isRefer) {
        var code = deepLink.queryParameters['code'];
        debugPrint(code.toString());
        if (code != null) {
          Navigator.push(
            context!,
            MaterialPageRoute(
              builder: (context) => RegisterView(
                refCode: code.toString(),
              ),
            ),
          );
        }
      }
    }
  }

  //dinamik link oluşturma
  Future<String> createReferralLink(String referralCode) async {
    final DynamicLinkParameters dynamicLinkParameters = DynamicLinkParameters(
      uriPrefix: 'https://dinamiklinkproje.page.link/referans',
      link: Uri.parse('https://www.berkut.tech/referans?code=$referralCode'),
      androidParameters: AndroidParameters(
        packageName: 'com.example.firebase_dynamic_link_example',
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: 'Davet et',
        description: 'Davet oluştur',
        imageUrl: Uri.parse(
            'https://freeiconshop.com/wp-content/uploads/edd/share-flat.png'),
      ),
    );

    final ShortDynamicLink shortLink =
        await dynamicLinkParameters.buildShortLink();

    final Uri dynamicUrl = shortLink.shortUrl;
    debugPrint(dynamicUrl.toString());
    return dynamicUrl.toString();
  }
}
