import 'package:hive/hive.dart';

part 'memories.g.dart';

@HiveType(typeId: 2)
class Memories extends HiveObject {
  @HiveField(0)
  List memories = [];
}
