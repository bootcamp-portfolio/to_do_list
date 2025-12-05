import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_list/model/todo.dart';
import 'package:to_do_list/model/user.dart';

class DatabaseHandler {
  /*user
  int? id; //auto increment,pk
  String name;
  String email;
  Uint8List image;
  String pw;
  String? createddate;
  */

  /*todo
  int? todo_id; //auto increment primary key
  int user_id; //fk to User table
  String title;
  String description;
  String duedate;
  bool iscompleted;
  Uint8List image;
  //int priority;
  String? createdate;
  String? updatedate;
  */

  //Connection 및 Table Create
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'user.db'),
      onCreate: (db, version) async {
        await db.execute("""
          create table user(
            id integer primary key autoincrement,
            name text,
            email text,
            pw text,
            createddate date
          )
          """);
        await db.execute("""
          create table todo(
            todo_id integer primary key autoincrement,
            user_id integer,
            title text,
            description text,
            duedate text,
            iscompleted integer,
            image blob,
            createdate date,
            updatedate date
          )
          """);
      },
      version: 1,
    );
  } //initialDB

  //USER
  // 입력 : 날짜는 SQLite이 날짜 계산값으로 입력
  Future<int> insertUser(User user) async {
    int result = 0;
    final Database db = await initializeDB();
    result = await db.rawInsert(
      """
      insert into user
      (name, email, pw, createddate)
      values
      (?,?,?,date('now'))
      """,
      [user.name, user.email, user.pw],
    ); //auto increment 생략
    return result;
  } // insertUser

  //검색
  Future<List<User>> queryUser() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db
        .rawQuery('select * from user');
    return queryResult.map((e) => User.fromMap(e)).toList();
  } // queryUser

  // 수정
  Future<int> updateUser(User user) async {
    int result = 0;
    final Database db = await initializeDB();
    result = await db.rawUpdate(
      """
      update user
      set name = ?,
      email = ?,
      pw = ?
      where id = ?
      """,
      [user.name, user.email, user.pw, user.id],
    ); //auto increment 생략
    return result;
  } // updateUser

  //삭제
  Future deleteUser(int id) async {
    final Database db = await initializeDB();
    await db.rawDelete('delete from user where id = ?', [
      id,
    ]);
  } // deleteUser

  //TODO
  // 입력 : 날짜는 SQLite이 날짜 계산값으로 입력
  Future<int> insertTodo(Todo todo) async {
    int result = 0;
    final Database db = await initializeDB();
    result = await db.rawInsert(
      """
      insert into todo
      (user_id, title, description, duedate, iscompleted, image, createdate, updatedate)
      values
      (?,?,?,?,?,?,date('now'), date('now')) 
      """,

      [
        todo.user_id,
        todo.title,
        todo.description,
        todo.duedate,
        todo.iscompleted,
        todo.image,
      ], //? 1:0
    );
    return result;
  } // insertTodo

  //검색
  Future<List<Todo>> queryTodo() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db
        .rawQuery('select * from todo');
    return queryResult.map((e) => Todo.fromMap(e)).toList();
  } // queryTodo

  //오늘 할일
  Future<List<Todo>> queryTodoByToday() async {
    final Database db = await initializeDB();

    DateTime now = DateTime.now();
    String today =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    print('$today');
    final List<Map<String, Object?>> queryResult = await db
        .rawQuery(
          """
      select * from todo
      where duedate = ?
      """,
          [today],
        );

    return queryResult.map((e) => Todo.fromMap(e)).toList();
  } // queryTodoByToday

  //내일 할 일
  Future<List<Todo>> queryTodoByTomorrow() async {
    final Database db = await initializeDB();

    DateTime tomorrowDateTime = DateTime.now().add(
      Duration(days: 1),
    );
    String tomorrow =
        '${tomorrowDateTime.year}-${tomorrowDateTime.month.toString().padLeft(2, '0')}-${tomorrowDateTime.day.toString().padLeft(2, '0')}';

    final List<Map<String, Object?>> queryResult = await db
        .rawQuery(
          """
      select * from todo
      where duedate = ?
      """,
          [tomorrow],
        );

    return queryResult.map((e) => Todo.fromMap(e)).toList();
  } // queryTodoByTomorrow

  //이번 주 할 일
  Future<List<Todo>> queryTodoByWeek() async {
    final Database db = await initializeDB();

    DateTime now = DateTime.now();

    int currentDayOfWeek = now.weekday; // 1(월) ~ 7(일)
    DateTime startOfWeekDateTime = now.subtract(
      Duration(days: currentDayOfWeek - 1),
    );

    DateTime endOfWeekDateTime = now.add(
      Duration(days: 7 - currentDayOfWeek),
    );

    String startOfWeek =
        '${startOfWeekDateTime.year}-${startOfWeekDateTime.month.toString().padLeft(2, '0')}-${startOfWeekDateTime.day.toString().padLeft(2, '0')}';
    String endOfWeek =
        '${endOfWeekDateTime.year}-${endOfWeekDateTime.month.toString().padLeft(2, '0')}-${endOfWeekDateTime.day.toString().padLeft(2, '0')}';

    final List<Map<String, Object?>> queryResult = await db
        .rawQuery(
          """
      SELECT * FROM todo 
      WHERE duedate BETWEEN ? AND ?
      ORDER BY duedate ASC
      """,
          [startOfWeek, endOfWeek],
        );

    return queryResult.map((e) => Todo.fromMap(e)).toList();
  } // queryTodoByWeek

  //이번달 할일
  Future<List<Todo>> queryTodoByMonth() async {
    final Database db = await initializeDB();
    DateTime now = DateTime.now();
    DateTime firstDayOfMonth = DateTime(
      now.year,
      now.month,
      1,
    );
    DateTime firstDayOfNextMonth = DateTime(
      now.year,
      now.month + 1,
      1,
    );
    DateTime lastDayOfMonth = firstDayOfNextMonth.subtract(
      Duration(milliseconds: 1),
    );
    String startOfMonth =
        '${firstDayOfMonth.year}-${firstDayOfMonth.month.toString().padLeft(2, '0')}-01';
    String endOfMonth =
        '${lastDayOfMonth.year}-${lastDayOfMonth.month.toString().padLeft(2, '0')}-${lastDayOfMonth.day.toString().padLeft(2, '0')}';

    final List<Map<String, Object?>> queryResult = await db
        .rawQuery(
          """
    select * from todo 
    where duedate between ? and ?
    order by duedate asc
    """,
          [startOfMonth, endOfMonth],
        );

    return queryResult.map((e) => Todo.fromMap(e)).toList();
  } // queryTodoByMonth

  // 수정//이미지없이
  Future<int> updateTodo(Todo todo) async {
    int result = 0;
    final Database db = await initializeDB();
    result = await db.rawUpdate(
      """
      update todo
    set 
        title = ?,
        description = ?,
        duedate = ?,
        iscompleted = ?
    
      where todo_id = ?
      """,
      [
        todo.title,
        todo.description,
        todo.duedate,
        todo.iscompleted,
        todo.todo_id,
      ],
    );
    return result;
  } // updateTodo

  // 수정전부
  Future<int> updateTodoAll(Todo todo) async {
    int result = 0;
    final Database db = await initializeDB();
    result = await db.rawUpdate(
      """
      update todo
    set 
        title = ?,
        description = ?,
        duedate = ?,
        iscompleted = ?,
        image = ?
      where todo_id = ?
      """,
      [
        todo.title,
        todo.description,
        todo.duedate,
        todo.iscompleted,
        todo.image,
        todo.todo_id,
      ],
    );
    return result;
  } // updateTodo

  //삭제
  Future deleteTodo(int todoId) async {
    final Database db = await initializeDB();
    await db.rawDelete(
      'delete from todo where todo_id = ?',
      [todoId],
    );
  } // deleteTodo
}
