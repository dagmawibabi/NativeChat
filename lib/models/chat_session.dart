import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'chat_session.g.dart';

@HiveType(typeId: 1)
class ChatSessionModel extends HiveObject {
  @HiveField(0)
  String id; 

  @HiveField(1)
  String title; 

  @HiveField(2)
  List<Map<String,dynamic>> messages;

  @HiveField(3)
  DateTime? createdAt;

  ChatSessionModel({
    String? id,
    required this.title,
    required this.messages,
    DateTime? createdAt,
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now(); 
}
