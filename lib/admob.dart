import 'package:firebase_admob/firebase_admob.dart';
const String testDevice = 'YOUR_DEVICE_ID';

const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
  testDevices: testDevice != null ? <String>[testDevice] : null,
  keywords: <String>['foo', 'bar'],
  contentUrl: 'http://foo.com/bar.html',
  childDirected: true,
  nonPersonalizedAds: true,
);

BannerAd _bannerAd;
NativeAd _nativeAd;
InterstitialAd _interstitialAd;
int _coins = 0;

BannerAd createBannerAd() {
  return BannerAd(
    adUnitId: BannerAd.testAdUnitId,
    size: AdSize.banner,
    targetingInfo: targetingInfo,
    listener: (MobileAdEvent event) {
      print("BannerAd event $event");
    },
  );
}

InterstitialAd createInterstitialAd() {
  return InterstitialAd(
    adUnitId: InterstitialAd.testAdUnitId,
    targetingInfo: targetingInfo,
    listener: (MobileAdEvent event) {
      print("InterstitialAd event $event");
    },
  );
}

NativeAd createNativeAd() {
  return NativeAd(
    adUnitId: NativeAd.testAdUnitId,
    factoryId: 'adFactoryExample',
    targetingInfo: targetingInfo,
    listener: (MobileAdEvent event) {
      print("$NativeAd event $event");
    },
  );
}

