class Location {
  final String id;
  final String city;
  final num lat;
  final num lng;
  final String adminName;

  Location({
    required this.id,
    required this.city,
    required this.lat,
    required this.lng,
    required this.adminName,
  });

  static List<Location> getLocations(List<Map<String, dynamic>> locations) {
    return List<Location>.from(locations.map((x) => Location.fromJson(x)));
  }

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'],
      city: json['city'],
      lat: json['lat'],
      lng: json['lng'],
      adminName: json['admin_name'],
    );
  }
}
