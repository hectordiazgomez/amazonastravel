import 'package:cloud_firestore/cloud_firestore.dart';

class Place {
  String? state;
  String? name;
  String? location;
  double? latitude;
  double? longitude;
  String? description;
  String? imageUrl1;
  String? imageUrl2;
  String? imageUrl3;
  String? imageUrl4;
  String? imageUrl5;
  String? videoUrl;
  int? loves;
  int? commentsCount;
  String? date;
  String? timestamp;

  Place({
    this.state,
    this.name,
    this.location,
    this.latitude,
    this.longitude,
    this.description,
    this.imageUrl1,
    this.imageUrl2,
    this.imageUrl3,
    this.imageUrl4,
    this.imageUrl5,
    this.videoUrl,
    this.loves,
    this.commentsCount,
    this.date,
    this.timestamp,
  });

  factory Place.fromFirestore(DocumentSnapshot snapshot) {
    Map d = snapshot.data() as Map<dynamic, dynamic>;
    return Place(
      state: d['state'],
      name: d['place name'],
      location: d['location'],
      latitude: d['latitude'],
      longitude: d['longitude'],
      description: d['description'],
      imageUrl1: d['image-1'],
      imageUrl2: d['image-2'],
      imageUrl3: d['image-3'],
      imageUrl4: d['image-4'],
      imageUrl5: d['image-5'],
      videoUrl: d['video'],
      loves: d['loves'],
      commentsCount: d['comments count'],
      date: d['date'],
      timestamp: d['timestamp'],
    );
  }
}
