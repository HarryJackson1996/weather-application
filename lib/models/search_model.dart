import 'package:hive/hive.dart';

part 'search_model.g.dart';

@HiveType(typeId: 6)
class Search {
  @HiveField(0)
  Map<String, String> locations;

  Search(this.locations);
}
