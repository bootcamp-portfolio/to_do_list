import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:to_do_list/model/todo.dart';
import 'package:to_do_list/util/message.dart';
import 'package:to_do_list/util/pcolor.dart';
import 'package:to_do_list/vm/database_handler.dart';

class Detail extends StatefulWidget {
  const Detail({super.key});

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  //property
  late DateTime date;
  late String selectDateText;
  late DatabaseHandler handler;

  late Message msg;
  late TextEditingController titleController;
  late TextEditingController desController;
  late TextEditingController dateController;
  late bool isCompleted;
  XFile? imageFile;
  final ImagePicker picker = ImagePicker();
  Message message = Message();

  //late TextEditingController timeController;
  // late TextEditingController priorityController;
  // late TextEditingController statusController;
  // late TextEditingController categoryController;

  @override
  void initState() {
    super.initState();
    date = DateTime.now();
    selectDateText = '선택날짜 : ';
    handler = DatabaseHandler();
    msg = Message();
    titleController = TextEditingController();
    desController = TextEditingController();
    dateController = TextEditingController();
    isCompleted = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PColor.baseBackgroundColor,
      appBar: AppBar(
        title: Text('D E T A I L   P a g e'),
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: PColor.appBarBackgroundColor,
        foregroundColor: PColor.appBarForegroundColor,
        centerTitle: true,
        actions: [
          // IconButton(
          //   onPressed: () => Get.to((())),
          //   icon: Icon(Icons.add_box_rounded),
          //   color: Colors.white,
          // ),
          //   IconButton(
          //   onPressed: () => insertAction(),
          //   icon: Icon(Icons.add_box_rounded),
          //   color: Colors.white,
          // ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Text(
                //   '오늘 : ${date.year}년 ${date.month.toString().padLeft(2, '0')}월 ${date.day.toString().padLeft(2, '0')}일',
                // ),
                // Text(selectDateText),
                // ElevatedButton(
                //   onPressed: _dispDatePicker,
                //   child: Text('달력'),
                // ),
                TextField(
                  decoration: InputDecoration(
                    labelText: '',
                  ),
                  readOnly: true,
                ),
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: '',
                  ),
                  readOnly: true,
                ),
                TextField(
                  controller: desController,
                  decoration: InputDecoration(
                    labelText: '',
                  ),
                  readOnly: true,
                ),
                TextField(
                  controller: dateController,
                  decoration: InputDecoration(
                    labelText: '',
                  ),
                  readOnly: true,
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    Text('수행여부'),
                    Switch(
                      value: isCompleted,
                      onChanged: (bool value) {
                        isCompleted = value;
                        setState(() {});
                      },
                    ),
                  ],
                ),

                // ElevatedButton(
                //   onPressed: () => getImageFromGallery(
                //     ImageSource.gallery,
                //   ),
                //   child: Text(
                //     '이미지 가져오기',
                //     style: TextStyle(fontSize: 10),
                //   ),
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: Colors.pinkAccent,
                //     foregroundColor: Colors.white,
                //     minimumSize: Size(100, 50),
                //   ),
                // ),
                SizedBox(height: 50),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  color: Colors.grey,
                  child: Center(
                    child: imageFile == null
                        ? const Text(
                            'Image is not selected!',
                          )
                        : Image.file(File(imageFile!.path)),
                  ),
                ),
                SizedBox(height: 50),
                // ElevatedButton(
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: Colors.pinkAccent,
                //     foregroundColor: Colors.white,
                //     minimumSize: Size(100, 50),
                //   ),
                //   onPressed: () => insertAction(),
                // child: Text(
                //   '입력',
                //   style: TextStyle(fontSize: 10),
                // ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  } //build

  //function
  _dispDatePicker() async {
    int firstYear = date.year - 1;
    int lastYear = date.year + 5;

    final selectedDateText = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(firstYear),
      lastDate: DateTime(lastYear),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      locale: Locale('ko', 'KR'),
    );
    if (selectedDateText != null) {
      dateController.text = selectedDateText
          .toString()
          .substring(0, 10);
      selectDateText = '선택날짜 ${dateController.text}';
      setState(() {});
    }
  }

  Future getImageFromGallery(
    ImageSource imageSource,
  ) async {
    final XFile? pickedFile = await picker.pickImage(
      source: imageSource,
    );
    if (pickedFile == null) {
      return;
    } else {
      imageFile = XFile(pickedFile.path);
      setState(() {});
    }
  } // getImageFromGallery

  insertAction() async {
    int result = checkData();
    if (result == 0) {
      File imageFile1 = File(imageFile!.path);
      Uint8List getImage = await imageFile1.readAsBytes();

      var todo = Todo(
        user_id: 1,
        title: titleController.text,
        description: desController.text,
        duedate: dateController.text,
        iscompleted: 0,
        image: getImage,
        //category: '',
        //priority: 1,
      );
      result = await handler.insertTodo(todo);
      result == 0
          ? msg.snackBar('실패', '문제가 발생했습니다')
          : msg.showDialog('성공', '입력이 완료 되었습니다.');
    }
  } // insertAction

  // 입력 체크 : Error 조건 구성
  int checkData() {
    final List<Map<String, dynamic>> checks = [
      {
        'condition': titleController.text.trim().isEmpty,
        'title': '일정',
        'message': '일정을 입력 하세요',
      },
      {
        'condition': desController.text.trim().isEmpty,
        'title': '세부내용',
        'message': '세부내용을 입력 하세요',
      },
      {
        'condition': dateController.text.trim().isEmpty,
        'title': '날짜',
        'message': '날짜를 입력 하세요',
      },
      {
        'condition': imageFile == null,
        'title': '이미지',
        'message': '이미지를 선택 하세요',
      },
    ];

    int result = 0;

    for (var check in checks) {
      if (check['condition']) {
        msg.snackBar(check['title'], check['message']);
        result++;
      }
    }
    return result;
  } // checkData
}
