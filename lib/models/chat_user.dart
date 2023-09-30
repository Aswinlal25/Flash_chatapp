class ChatUser {
  ChatUser({
    required this.about,
    required this.name,
    required this.createdAt,
    required this.isOnline,
    required this.lastActive,
    required this.id,
    required this.email,
    required this.pushToken,
    required this.image ,
  });
  late  String about;
  late  String name;
  late final String createdAt;
  late final bool isOnline;
  late final String lastActive;
  late final String id;
  late final String email;
  late final String pushToken;
  late  String image ;
  
  ChatUser.fromJson(Map<String, dynamic> json){
    about = json['about'] ?? '';
    name = json['name'] ?? '';
    createdAt = json['created_at'] ?? '';
    isOnline = json['is_online'] ?? '';
    lastActive = json['last_active'] ?? '';
    id = json['id'] ?? '';
    email = json['email'] ?? '';
    pushToken = json['push_token'] ?? '';
    image  = json['image'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['about'] = about;
    data['name'] = name;
    data['created_at'] = createdAt;
    data['is_online'] = isOnline;
    data['last_active'] = lastActive;
    data['id'] = id;
    data['email'] = email;
    data['push_token'] = pushToken;
    data['image'] = image ;
    return data;
  }
}