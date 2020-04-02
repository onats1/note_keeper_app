class Note {

  int _id;
  String _title;
  String _description;
  String _date;
  int _priority;

  Note(this._title, this._date, this._priority, [this._description]);

  Note.withId(this._id, this._title, this._date, this._priority,
      [this._description]);

  int get id => _id;

  String get title => _title;

  set title(String value) {
    if (title.length < 255){
      _title = value;
    }
  }

  String get description => _description;

  set description(String value) {
    if (value.length < 255){
      _description = value;
    }
  }

  String get date => _date;

  set date(String value) {
    _date = value;
  }

  int get priority => _priority;

  set priority(int value) {
    if (value >= 1 && value<=2){
      _priority = value;
    }
  }

  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();

    if (_id != null){
      map["id"] = _id;
    }

    map["title"] = _title;
    map["description"] = _description;
    map["date"] = _date;
    map["priority"] = _priority;

    return map;
  }

  Note.fromMapObject(Map<String, dynamic> map) {
    this._id =  map["id"];
    this._priority = map["priority"];
    this._date = map["date"];
    this._description = map["description"];
    this._title = map["title"];
  }
}
