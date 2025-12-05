import 'dart:typed_data';

class Todo {
  int? todo_id; //auto increment primary key
  int? user_id; //fk to User table
  String title;
  String description;
  String duedate;
  int iscompleted;
  Uint8List image;
  //String category;
  //int priority;
  String? createdate;
  String? updatedate;

  Todo({
    this.todo_id,
    this.user_id,
    required this.title,
    required this.description,
    required this.duedate,
    required this.iscompleted,
    required this.image,
    //required this.category,
    //required this.priority,
    this.createdate,
    this.updatedate,
  });

  Todo.fromMap(Map<String, dynamic> res)
    : todo_id = res['todo_id'],
      user_id = res['user_id'],
      title = res['title'],
      description = res['description'],
      duedate = res['duedate'],
      iscompleted = res['iscompleted'],
      image = res['image'],
      //category = res['category'],
      //priority = res['priority'],
      createdate = res['createdate'],
      updatedate = res['updatedate'];
}
