import 'dart:io';

import 'package:flutter/material.dart';
import 'package:great_places/helpers/db_helper.dart';
import 'package:great_places/helpers/location_helper.dart';
import 'package:great_places/models/place.dart';

class GreatPlaces with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    return [..._items];
  }

  Place findById(String id) {
    return _items.firstWhere((p) => p.id == id);
  }

  Future<void> addPlace(String title, File image, Location location) async {
    final address = await LocationHelper.getPlaceAddress(
      location.latitude,
      location.longitude,
    );
    final updatedLocation = Location(
      latitude: location.latitude,
      longitude: location.longitude,
      address: address,
    );
    final newPlace = Place(
      id: DateTime.now().toString(),
      title: title,
      image: image,
      location: updatedLocation,
    );
    _items.add(newPlace);
    notifyListeners();
    DBHelper.insert('Places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
      'loc_lat': newPlace.location!.latitude,
      'loc_lng': newPlace.location!.longitude,
      'address': newPlace.location!.address!
    });
  }

  Future<void> fetchAndSetPlaces() async {
    final datalist = await DBHelper.getData('Places');
    _items = datalist
        .map(
          (p) => Place(
            id: p['id'] as String,
            title: p['title'] as String,
            image: File(p['image'] as String),
            location: Location(
              latitude: p['loc_lat'] as double,
              longitude: p['loc_lng'] as double,
              address: p['address'] as String,
            ),
          ),
        )
        .toList();
    notifyListeners();
  }
}
