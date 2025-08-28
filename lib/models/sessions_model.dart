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
}
