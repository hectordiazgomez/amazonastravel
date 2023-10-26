import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Config {
  final String appName = 'AMAZONAS Travel Mark';
  final String mapAPIKey = 'AIzaSyCKWPm32_wkS8ukDTlrFaThKwsh8I27Z8Y';
  final String countryName = 'Amazonas';
  final String splashIcon = 'assets/images/splash.png';
  final String supportEmail = 'YOUR_EMAIL';
  final String privacyPolicyUrl =
      'https://www.mrb-lab.com/privacy-policy-of-travel-hour';
  final String iOSAppId = '000000';

  final String yourWebsiteUrl = 'https://as-40764.web.app';
  final String facebookPageUrl = 'https://www.facebook.com/mrblab24';
  final String youtubeChannelUrl =
      'https://www.youtube.com/channel/UCnNr2eppWVVo-NpRIy1ra7A';

  // app theme color - primary color
  static final Color appThemeColor = Colors.blueAccent;

  //special two states name that has been already upload from the admin panel
  final String specialState1 = 'Luya';
  final String specialState2 = 'Bongará';

  //relplace by your country lattitude & longitude
  final CameraPosition initialCameraPosition = CameraPosition(
    target: LatLng(6.231178994633883, 77.86290620477831), //here
    zoom: 10,
  );

  //google maps marker icons
  final String hotelIcon = 'assets/images/hotel.png';
  final String restaurantIcon = 'assets/images/restaurant.png';
  final String hotelPinIcon = 'assets/images/hotel_pin.png';
  final String restaurantPinIcon = 'assets/images/restaurant_pin.png';
  final String drivingMarkerIcon = 'assets/images/driving_pin.png';
  final String destinationMarkerIcon =
      'assets/images/destination_map_marker.png';

  //Intro images
  final String introImage1 = 'assets/images/travel6.png';
  final String introImage2 = 'assets/images/travel1.png';
  final String introImage3 = 'assets/images/travel5.png';

  //Language Setup
  final List<String> languages = ['English', 'Spanish', 'Arabic'];

  static const String emptyImage =
      'https://innov8tiv.com/wp-content/uploads/2017/10/blank-screen-google-play-store-1280x720.png';
}
