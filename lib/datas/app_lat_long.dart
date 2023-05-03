class AppLatLong {
  final double lat;
  final double long;

  const AppLatLong({
    this.lat,
    this.long,
  });
}

class MoscowLocation extends AppLatLong {
  const MoscowLocation({
    lat = 55.7522200,
    long = 37.6155600,
  });
}