import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as message;
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:to_do_list/model/todo.dart';
import 'package:to_do_list/util/message.dart';
import 'package:to_do_list/util/pcolor.dart';
import 'package:to_do_list/vm/database_handler.dart';

class Update extends StatefulWidget {
  const Update({super.key});
  // var arguments?;
  @override
  State<Update> createState() => _UpdateState();
}

class _UpdateState extends State<Update> {
  // Property
  late DatabaseHandler handler;
  late DateTime date;
  late String selectDateText;
  late Message msg;
  late TextEditingController titleController;
  late TextEditingController desController;
  late TextEditingController dateController;
  late bool isCompleted;
  XFile? imageFile;
  final ImagePicker picker = ImagePicker();
  late int firstDisp;
  var value = Get.arguments ?? "__";

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    titleController = TextEditingController();
    desController = TextEditingController();
    dateController = TextEditingController();
    isCompleted = false;
    firstDisp = 1;
    date = DateTime.now();
    selectDateText = '';
    msg = Message();

    if (value != "__") {
      print(
        "Data Received: $value[0] $value[1] $value[2] $value[3] $value[4]",
      );
      titleController.text = value[1];
      desController.text = value[2];

      dateController.text = value[3].toString();
      // selectDateText = value[3].toString();
      returnDate(value[3].toString());
      isCompleted = value[4] == 1 ? true : false;
      firstDisp = 0;
    } else {
      print("No Data Received");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: PColor.baseBackgroundColor,
        appBar: AppBar(
          title: Text('Update Page'),
          centerTitle: true,
          foregroundColor: PColor.appBarForegroundColor,
          backgroundColor: PColor.appBarBackgroundColor,
        ),
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [
                      // Text(
                      //   '오늘 : ${date.year}년 ${date.month.toString().padLeft(2, '0')}월 ${date.day.toString().padLeft(2, '0')}일',
                      // ),
                      // Text(selectDateText),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(
                                255,
                                228,
                                180,
                                196,
                              ),
                          foregroundColor: Colors.white,
                          minimumSize: Size(100, 50),
                        ),
                        onPressed: _dispDatePicker,
                        child: Text(
                          '달력',
                          style: TextStyle(fontSize: 10),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        '오늘날짜 : ${date.year}년 ${date.month.toString().padLeft(2, '0')}월 ${date.day.toString().padLeft(2, '0')}일',
                      ),
                      //Text(selectDateText),
                      Text('선택날짜 : ${selectDateText}'),
                      SizedBox(height: 20),
                      TextField(
                        controller: titleController,
                        decoration: InputDecoration(
                          labelText: 'Title',
                        ),
                      ),

                      TextField(
                        controller: desController,
                        decoration: InputDecoration(
                          labelText: 'Description',
                        ),
                      ),

                      TextField(
                        controller: dateController,
                        decoration: InputDecoration(
                          labelText: 'Due Date',
                        ),
                      ),
                      SizedBox(height: 20),
                      // Row(
                      //   mainAxisAlignment:
                      //       MainAxisAlignment.center,
                      //   children: [
                      //     Text('수행여부'),
                      //     Switch(
                      //       value: isCompleted,
                      //       onChanged: (bool value) {
                      //         isCompleted = value;
                      //         setState(() {});
                      //       },
                      //     ),
                      //   ],
                      // ),
                      SizedBox(height: 40),
                      ElevatedButton(
                        onPressed: () =>
                            getImageFromGallery(
                              ImageSource.gallery,
                            ),
                        child: Text(
                          '이미지 가져오기',
                          style: TextStyle(fontSize: 10),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(
                                255,
                                228,
                                180,
                                196,
                              ),
                          foregroundColor: Colors.white,
                          minimumSize: Size(100, 50),
                        ),
                      ),
                      SizedBox(height: 50),
                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: ElevatedButton(
                      //     onPressed: () =>
                      //         getImageFromGallery(
                      //           ImageSource.gallery,
                      //         ),
                      //     child: Text('이미지 가져오기'),
                      //   ),
                      // ),
                      firstDisp == 0
                          ? Container(
                              width: MediaQuery.of(
                                context,
                              ).size.width,
                              height: 200,
                              color: const Color.fromARGB(
                                255,
                                97,
                                97,
                                97,
                              ),
                              child: Center(
                                child: Image.memory(
                                  value[5],
                                ),
                              ),
                            )
                          : Container(
                              width: MediaQuery.of(
                                context,
                              ).size.width,
                              height: 200,
                              color: Colors.grey,
                              child: Center(
                                child: imageFile == null
                                    ? const Text(
                                        'Image is not selected!',
                                      )
                                    : Image.file(
                                        File(
                                          imageFile!.path,
                                        ),
                                      ),
                              ),
                            ),
                      SizedBox(height: 50),
                      // Container(
                      //   width: MediaQuery.of(
                      //     context,
                      //   ).size.width,
                      //   height: 200,
                      //   color: Colors.grey,
                      //   child: Center(
                      //     child: imageFile == null
                      //         ? const Text(
                      //             'Image is not selected!',
                      //           )
                      //         : Image.file(
                      //             File(imageFile!.path),
                      //           ),
                      //   ),
                      // ),
                      SizedBox(height: 50),
                      // ElevatedButton(
                      //   style: ElevatedButton.styleFrom(
                      //     backgroundColor:
                      //         Colors.pinkAccent,
                      //     foregroundColor: Colors.white,
                      //     minimumSize: Size(100, 50),
                      //   ),
                      //   onPressed: () => insertAction(),
                      //   child: Text(
                      //     '입력',
                      //     style: TextStyle(fontSize: 10),
                      //   ),
                      // ),
                      SizedBox(height: 50),
                      // Visibility(
                      //   visible: imageFile != null,
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(
                                255,
                                228,
                                180,
                                196,
                              ),
                          foregroundColor: Colors.white,
                          minimumSize: Size(100, 50),
                        ),
                        onPressed: () {
                          firstDisp == 0
                              ? updateAction()
                              : updateActionAll();
                        },
                        child: Text(
                          '수정',
                          style: TextStyle(fontSize: 10),
                        ),
                      ),
                      // ),
                    ],
                  ),

                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: TextField(
                  //     controller: desController,
                  //     decoration: InputDecoration(
                  //       labelText: 'description',
                  //       border: OutlineInputBorder(),
                  //     ),
                  //   ),
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: ElevatedButton(
                  //     style: ElevatedButton.styleFrom(
                  //       backgroundColor: Colors.pinkAccent,
                  //       foregroundColor: Colors.white,
                  //       minimumSize: Size(100, 50),
                  //     ),
                  //     onPressed: () {
                  //       firstDisp == 0
                  //           ? updateAction()
                  //           : updateActionAll();
                  //     },
                  //     child: Text('수정'),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  } // build

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
      String formattedDate = selectedDateText
          .toString()
          .substring(0, 10);
      dateController.text = formattedDate;
      // String year = dateController.text.substring(0, 4);
      // String month = dateController.text.substring(5, 7);
      // String day = dateController.text.substring(8, 10);
      // selectDateText = '$year년 $month월 $day일';
      // print(selectDateText);
      returnDate(dateController.text);
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
      firstDisp += 1;
      setState(() {});
    }
  } // getImageFromGallery

  // Image 포함 수정
  updateActionAll() async {
    int result = checkData();
    if (result == 0) {
      // File Type을 Byte Type으로 변환하기
      File imageFile1 = File(imageFile!.path);
      Uint8List getImage = await imageFile1.readAsBytes();

      var todo = Todo(
        todo_id: value[0],
        title: titleController.text.trim(),
        description: desController.text.trim(),
        duedate: dateController.text.trim(),
        iscompleted: isCompleted ? 1 : 0,
        image: getImage,
      );

      result = await handler.updateTodoAll(todo);
      result == 0
          ? msg.snackBar('DB 오류', '수정시 문제가 발생했습니다')
          : msg.showDialog('수정 결과', '수정 완료 되었습니다.');
    }
  } // updateActionAll

  // Image 제외 수정
  updateAction() async {
    int result = checkData();
    print("Value[0] ${value[0]}");
    if (result == 0) {
      var todo = Todo(
        todo_id: value[0],
        title: titleController.text.trim(),
        description: desController.text.trim(),
        duedate: dateController.text.trim(),
        iscompleted: isCompleted ? 1 : 0,
        image: value[5],
      );

      result = await handler.updateTodo(todo);
      result == 0
          ? msg.snackBar('DB 오류', '수정시 문제가 발생했습니다')
          : msg.showDialog('수정 결과', '수정 완료 되었습니다.');
    }
  } // updateActionAll

  // 수정 항목 Check
  int checkData() {
    final List<Map<String, dynamic>> checks = [
      {
        'condition': titleController.text.trim().isEmpty,
        'title': '제목',
        'message': '제목을 입력 하세요',
      },
      {
        'condition': desController.text.trim().isEmpty,
        'title': '설명',
        'message': '설명을 입력 하세요',
      },
      {
        'condition': dateController.text.trim().isEmpty,
        'title': '날짜',
        'message': '날짜를 입력 하세요',
      },
      {
        'condition': !isCompleted && isCompleted,
        'title': '완료여부',
        'message': '완료여부를 선택 하세요',
      },
      {
        'condition': imageFile == null && firstDisp > 0,
        'title': '이미지',
        'message': '이미지를 선택 하세요',
      },

      {
        'condition': firstDisp < 0,
        'title': '알수없는 오류',
        'message': '알수없는 오류가 발생했습니다',
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

  void returnDate(String date) {
    String year = date.substring(0, 4);
    String month = date.substring(5, 7);
    String day = date.substring(8, 10);
    selectDateText = '$year년 $month월 $day일';
  }
} // class
