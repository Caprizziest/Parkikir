class ReportModel {
  final String id;
  final String title;
  final String userName;
  final DateTime timestamp;
  final String? description;
  final bool isSolved;

  ReportModel({
    required this.id,
    required this.title,
    required this.userName,
    required this.timestamp,
    this.description,
    this.isSolved = false,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      id: json['id'] as String,
      title: json['title'] as String,
      userName: json['userName'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      description: json['description'] as String?,
      isSolved: json['isSolved'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'userName': userName,
      'timestamp': timestamp.toIso8601String(),
      'description': description,
      'isSolved': isSolved,
    };
  }
}
