enum Category {
  restaurant('restaurant'),
  accomodations('accomodations'),
  peaks('peaks'),
  lakes('lakes'),
  rivers('rivers'),
  waterfalls('waterfalls'),
  picnic_site('picnic_site'),
  heritage('heritage'),
  park('park'),
  temple('temple'),
  other('other');

  final String value;
  const Category(this.value);

  /// String → Enum
  static Category fromString(String value) {
    return Category.values.firstWhere(
      (e) => e.value == value,
      orElse: () => Category.other,
    );
  }
}

enum Mood {
  food('food'),
  entertainment('entertainment'),
  cultural('cultural'),
  peaceful('peaceful'),
  adventurous('adventurous'),
  nature('nature');

  final String value;
  const Mood(this.value);

  static Mood fromString(String value) {
    return Mood.values.firstWhere(
      (e) => e.value == value,
      orElse: () => Mood.peaceful,
    );
  }
}

enum Weather {
  sunny('sunny'),
  rainy('rainy'),
  cloudy('cloudy');

  final String value;
  const Weather(this.value);

  static Weather fromString(String value) {
    return Weather.values.firstWhere(
      (e) => e.value == value,
      orElse: () => Weather.sunny,
    );
  }
}

enum Season {
  summer('summer'),
  spring('spring'),
  winter('winter'),
  autumn('autumn');

  final String value;
  const Season(this.value);

  static Season fromString(String value) {
    return Season.values.firstWhere(
      (e) => e.value == value,
      orElse: () => Season.summer,
    );
  }
}

class Destination {
  final int id;
  final String name;        // PLACE NAME
  final String description; // PLACE DESCRIPTION
  final String location;
  final Category category;
  final double avg_price;
  final double rating;
  final String open_hours;
  final String imageUrl;
  final double latitude;
  final double longitude;
  final List<Season> suitable_season;
  final List<Weather> suitable_weather;
  final List<Mood> compatable_moods;

  Destination({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
    required this.category,
    required this.avg_price,
    required this.rating,
    required this.open_hours,
    required this.latitude,
    required this.longitude,
    required this.suitable_season,
    required this.suitable_weather,
    required this.compatable_moods,
    this.imageUrl = '',
  });

  factory Destination.fromJson(Map<String, dynamic> json) {
    return Destination(
      id: json['id'] ?? 0,
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
      category: Category.fromString(
        json['category'] is List
            ? (json['category'] as List).first.toString()
            : json['category']?.toString() ?? 'other',
      ),
      avg_price: json['avg_price'] != null
          ? (json['avg_price'] as num).toDouble()
          : 0.0,
      rating: json['rating'] != null
          ? (json['rating'] as num).toDouble()
          : 0.0,
      open_hours: json['open_hours']?.toString() ?? '',
      imageUrl: (json['image_url'] ??
              json['image'] ??
              json['imageUrl'])
          ?.toString() ??
          '',
      latitude: json['latitude'] != null
          ? (json['latitude'] as num).toDouble()
          : 0.0,
      longitude: json['longitude'] != null
          ? (json['longitude'] as num).toDouble()
          : 0.0,
      suitable_season: (json['suitable_season'] as List?)
              ?.map((e) => Season.fromString(e.toString()))
              .toList() ??
          [],
      suitable_weather: (json['suitable_weather'] as List?)
              ?.map((e) => Weather.fromString(e.toString()))
              .toList() ??
          [],
      compatable_moods: (json['compatable_moods'] as List?)
              ?.map((e) => Mood.fromString(e.toString()))
              .toList() ??
          [],
    );
  }
}

const Map<Mood, List<Category>> MOOD_TO_CATEGORY = {
  Mood.food: [
    Category.restaurant,
  ],

  Mood.entertainment: [
    Category.other,
    Category.park,
  ],

  Mood.cultural: [
    Category.heritage,
    Category.temple,
  ],

  Mood.peaceful: [
    Category.park,
    Category.lakes,
    Category.temple,
    Category.rivers,
    Category.peaks,
  ],

  Mood.adventurous: [
    Category.peaks,
    Category.waterfalls,
    Category.rivers,
  ],

  Mood.nature: [
    Category.park,
    Category.lakes,
    Category.rivers,
    Category.waterfalls,
    Category.picnic_site,
  ],
};


const Map<Mood, List<Mood>> MOOD_COMPLEMENTARY = {
  Mood.food: [
    Mood.entertainment,
    Mood.cultural,
    Mood.peaceful,
  ],

  Mood.entertainment: [
    Mood.adventurous,
  ],

  Mood.cultural: [
    Mood.peaceful,
    Mood.nature,
  ],

  Mood.peaceful: [
    Mood.nature,
    Mood.cultural,
  ],

  Mood.adventurous: [
    Mood.entertainment,
    Mood.nature,
  ],

  Mood.nature: [
    Mood.peaceful,
    Mood.adventurous,
    Mood.cultural,
  ],
};
