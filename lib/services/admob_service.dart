import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMobService {
  static String get bannerAdunitId =>
      Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/6300978111'
          : 'ca-app-pub-3940256099942544/6300978111';

  static String get interstitialAdId =>
      Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/1033173712'
          : 'ca-app-pub-3940256099942544/1033173712';

   InterstitialAd? _interstitialAd;
  int _numberOfAtemptLoad =0;

  static intialize() {
      MobileAds.instance.initialize();
  }

  static BannerAd cretebannerAd(int width, int height) {
    BannerAd ad = new BannerAd(size: AdSize(width: width, height: height),
        adUnitId: bannerAdunitId,
        request: AdRequest(),
        listener: BannerAdListener(
            onAdLoaded: (Ad ad) => print('add loaded'),
            onAdFailedToLoad: (Ad ad, LoadAdError error) {
              print(error);
              ad.dispose();
            },
            onAdOpened: (Ad ad) => print('Ad opened'),
            onAdClosed: (Ad ad) => print('on ad closed')
        )
    );

    return ad;
  }

  void createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: interstitialAdId,
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
            onAdLoaded: (InterstitialAd ad){
              _interstitialAd = ad;
              _numberOfAtemptLoad =0;
            },
            onAdFailedToLoad: (LoadAdError error){
              print('failed to load');
              // ignore: unnecessary_statements
              _numberOfAtemptLoad+1;
              _interstitialAd = null;
              if(_numberOfAtemptLoad<=2)
                {
                  createInterstitialAd();
                }
            }
             ));
  }
  void showIntAd() {
    if(_interstitialAd ==null)
      {
        return;
      }

      _interstitialAd!.fullScreenContentCallback =FullScreenContentCallback(
        onAdShowedFullScreenContent: (InterstitialAd ad){
          print("ad showed full screen");
        },
        onAdDismissedFullScreenContent: (InterstitialAd ad){
          print('ad dismissed');
          ad.dispose();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad ,AdError error){
          print("$ad failed $error");
          ad.dispose();
          createInterstitialAd();
      }
      );
      _interstitialAd!.show();
      _interstitialAd=null;
  }
}
