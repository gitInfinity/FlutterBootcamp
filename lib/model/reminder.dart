class Reminder {
  Reminder({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.dateTime,
    required this.dateCreated,
    required this.dateModified,
    required this.isCompleted,
    this.notificationId,
  });

  final String id;
  final String title;
  final String description;
  final String category;
  final DateTime dateTime;
  final int dateCreated;
  final int dateModified;
  final bool isCompleted;
  final int? notificationId;

  Reminder copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    DateTime? dateTime,
    int? dateCreated,
    int? dateModified,
    bool? isCompleted,
    int? notificationId,
  }) {
    return Reminder(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      dateTime: dateTime ?? this.dateTime,
      dateCreated: dateCreated ?? this.dateCreated,
      dateModified: dateModified ?? this.dateModified,
      isCompleted: isCompleted ?? this.isCompleted,
      notificationId: notificationId ?? this.notificationId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'dateTime': dateTime.millisecondsSinceEpoch,
      'dateCreated': dateCreated,
      'dateModified': dateModified,
      'isCompleted': isCompleted,
      'notificationId': notificationId,
    };
  }

  factory Reminder.fromJson(Map<String, dynamic> json) {
    return Reminder(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      category: json['category'],
      dateTime: DateTime.fromMillisecondsSinceEpoch(json['dateTime']),
      dateCreated: json['dateCreated'],
      dateModified: json['dateModified'],
      isCompleted: json['isCompleted'],
      notificationId: json['notificationId'],
    );
  }
}
