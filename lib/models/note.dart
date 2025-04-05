
class Note {

  int? _id;
  String _title;
  String _description;
  String _date;
  int _priority;

  Note(this._title, this._date, this._priority, [this._description = '']);

  Note.withId(this._id, this._title, this._date, this._priority, [this._description = '']);

  int? get id => _id;

  String get title => _title;

  String get description => _description;

  String get date => _date;

  int get priority => _priority;

  set title(String newTitle) {
    if (newTitle.length <= 255){
      _title = newTitle;
    }
  }

  set description(String newDescription) {
    if (newDescription.length <= 255){
      _description = newDescription;
    }
  }

  set priority(int newPriority) {
    if (newPriority >= 1 && newPriority <= 2) {
      _priority = newPriority;
    }
  }

  set date(String newDate) {
    _date = newDate;
  }

  //mapa

  Map<String, dynamic> toMap() {

    var map = Map<String, dynamic>();
    if (_id != null) {
      map['id'] = _id;
    }
    map['title'] = _title;
    map['description'] = _description;
    map['date'] = _date;
    map['priority'] = _priority;

    return map;
  }

  //extrair uma nota de um mapa
  factory Note.fromMapObject(Map<String, dynamic> map) {
    return Note.withId(
      map['id'],
      map['title'],
      map['date'],
      map['priority'],
      map['description'] ?? '', // Caso description seja null, usa string vazia
    );
  }
}