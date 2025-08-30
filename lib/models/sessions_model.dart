class Session {
  final int id;
  final String title;
  final String sessionCode;
  final String startAt;
  final String endAt;
  final String createdAt;
  final bool isActive;

  //constructor
  const Session({
    required this.id,
    required this.title,
    required this.sessionCode,
    required this.startAt,
    required this.endAt,
    required this.createdAt,
    required this.isActive,
  });

  //Conver json to map
  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      sessionCode: json['sessionCode'] ?? '',
      startAt: json['startAt'] ?? '',
      endAt: json['endAt'] ?? '',
      createdAt: json['createdAt'] ?? '',
      isActive: json['isActive'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'sessionCode': sessionCode,
      'startAt': startAt,
      'endAt': endAt,
      'createdAt': createdAt,
      'isActive': isActive,
    };
  }

  // Create a copy of Session with some fields changed (usefull for updates)
  Session copyWith({
    int? id,
    String? title,
    String? sessionCode,
    String? startAt,
    String? endAt,
    String? createdAt,
    bool? isActive,
  }){
    return Session(
      id: id?? this.id,
      title: title?? this.title,
      sessionCode: sessionCode?? this.sessionCode,
      startAt: startAt?? this.startAt,
      endAt: endAt?? this.endAt,
      createdAt: createdAt?? this.createdAt,
      isActive: isActive?? this.isActive,
    );
  }
}
