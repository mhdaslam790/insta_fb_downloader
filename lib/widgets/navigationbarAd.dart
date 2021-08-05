import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:save_from_social_media/services/admob_service.dart';

class DisplayAd extends StatelessWidget {
  final int height;
 final int width;

   DisplayAd({Key? key, required this.height, required this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height.toDouble(),
      child: AdWidget(
        ad: AdMobService.cretebannerAd(width, height)..load(),
        key: UniqueKey(),
      ),
    );
  }
}
