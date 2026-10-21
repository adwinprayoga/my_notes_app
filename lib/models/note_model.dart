class Note {
  final int? id;
  final String title;
  final String content;
  final String category;
  final String date;
  final bool isImportant;

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.date,
    this.isImportant = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'category': category,
      'date': date,
      'isImportant': isImportant ? 1 : 0,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      category: map['category'] ?? 'Pribadi',
      date: map['date'] ?? '',
      isImportant: (map['isImportant'] ?? 0) == 1,
    );
  }
}