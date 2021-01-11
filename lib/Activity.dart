class Activity {
  int id;
  String title;
  String description;

  Activity({this.id, this.title, this.description});
  Map<String, dynamic> toMap() {
    return {'title': title, 'description': description};
  }
}
