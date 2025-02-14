import 'package:dio/dio.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hava_durumu/models/weather_model.dart';

class WeitherService {
  Future<String> getLocation() async {
    //Kullanıcının konumu açık mı kontrol ettik
    final bool serviceEnable = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnable) {
      Future.error("Konum servisiniz kapalı");
    }

    //Kullanıcı konum izni vermiş mi kontrol ettik
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      //Konum izni vermemişse tekrar izin istedik
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        //Yine vermemişse hata döndürdük
        Future.error("Konum izni vermelisiniz.");
      }
    }

    //Kullanıcının pozisyonunu aldık
    final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    //Kullanıcının pozisyonundan yerleşim yerini bulduk
    final List<Placemark> placeMark =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    //Şehirimizi yerleşim noktasından kaydettik
    print(placeMark);
    final String? city = placeMark[0].administrativeArea;
    if (city == null) Future.error("Bir sorun oluştu");
    return city!;
  }

  Future<List<WeatherModel>> getWeatherData() async {
    final String city = await getLocation();
    final String url =
        'https://api.collectapi.com/weather/getWeather?data.lang=tr&data.city=$city';
    const Map<String, dynamic> headers = {
      'authorization': 'apikey 2uY5MX7ZkIHJYJibmPvQW5:1VAYIRMR2H7Nx4lenndiOW',
      'content-type': 'application/json',
    };

    final dio = Dio();
    final response = await dio.get(url, options: Options(headers: headers));
    if (response.statusCode != 200) {
      return Future.error("Bir sorun oluştu");
    }

    final List list = response.data['result'];
    final List<WeatherModel> weatherList = list
        .map((e) => WeatherModel.fromJson(e))
        .toList(); //modellerle dolu bir listem oldu

    return weatherList;
  }
}
