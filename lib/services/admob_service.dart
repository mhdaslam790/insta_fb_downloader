import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMobService {
  static String get bannerAdunitId =>
      Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/6300978111'
          : 'ca-app-pub-3940256099942544/6300978111';

  static intialize() {
    if (MobileAds.instance == null) {
      MobileAds.instance.initialize();
    }
  }

  static BannerAd cretebannerAd(int width, int height) {
    BannerAd ad = new BannerAd(size: AdSize(width: width, height: height),
        adUnitId: bannerAdunitId,
        request: AdRequest(),
        listener: BannerAdListener(
          onAdLoaded: (Ad ad) => print('add loaded'),
          onAdFailedToLoad:  (Ad ad, LoadAdError error){
            print(error);
            ad.dispose();
          },
          onAdOpened: (Ad ad ) => print('Ad opened'),
          onAdClosed: (Ad ad) => print('on ad closed')
        )
    );

    return ad;
  }
}
