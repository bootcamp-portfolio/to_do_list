import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:to_do_list/util/pcolor.dart';
import 'package:to_do_list/view/detail.dart';
import 'package:to_do_list/view/insert.dart';
import 'package:to_do_list/view/month.dart';
import 'package:to_do_list/view/today.dart';
import 'package:to_do_list/view/tomorrow.dart';
import 'package:to_do_list/view/update.dart';
import 'package:to_do_list/view/week.dart';
import 'package:to_do_list/vm/database_handler.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //property
  late DatabaseHandler handler;

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PColor.baseBackgroundColor,
      appBar: AppBar(
        title: Text('T o d o   L i s t'),
        titleTextStyle: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: PColor.appBarBackgroundColor,
        foregroundColor: PColor.appBarForegroundColor,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Get.to(Insert())!.then((value) {
                reloadData();
              });
            },
            icon: Icon(Icons.add_box_rounded),
            color: Colors.white,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: handler.queryTodo(),
          builder: (context, snapshot) {
            return snapshot.hasData &&
                    snapshot.data!.isNotEmpty
                ? ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => Get.to(
                          Detail(),
                          arguments: [
                            snapshot.data![index].title,
                            snapshot
                                .data![index]
                                .description,
                            snapshot.data![index].duedate,
                            snapshot
                                .data![index]
                                .iscompleted,
                            snapshot.data![index].image,
                            snapshot.data![index].todo_id,
                          ],
                        ),
                        child: Slidable(
                          startActionPane: ActionPane(
                            motion: BehindMotion(),
                            children: [
                              SlidableAction(
                                backgroundColor:
                                    Colors.green,
                                icon: Icons.edit,
                                label: '수정',
                                onPressed: (context) =>
                                    Get.to(
                                      Update(),
                                      arguments: [
                                        snapshot
                                            .data![index]
                                            .todo_id,
                                        snapshot
                                            .data![index]
                                            .title,
                                        snapshot
                                            .data![index]
                                            .description,
                                        snapshot
                                            .data![index]
                                            .duedate,
                                        snapshot
                                            .data![index]
                                            .iscompleted,
                                        snapshot
                                            .data![index]
                                            .image,
                                      ],
                                    )!.then(
                                      (value) =>
                                          reloadData(),
                                    ),
                              ),
                            ],
                          ),
                          endActionPane: ActionPane(
                            motion: BehindMotion(),
                            children: [
                              SlidableAction(
                                backgroundColor: Colors.red,
                                icon: Icons.delete,
                                label: '삭제',
                                onPressed: (context) async {
                                  await handler.deleteTodo(
                                    snapshot
                                        .data![index]
                                        .todo_id!,
                                  );
                                  setState(() {});
                                },
                              ),
                            ],
                          ),
                          child: Card(
                            color: index % 2 == 0
                                ? const Color.fromARGB(
                                    255,
                                    211,
                                    225,
                                    229,
                                  )
                                : const Color.fromARGB(
                                    255,
                                    190,
                                    203,
                                    204,
                                  ),
                            child: Row(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.all(
                                        8.0,
                                      ),
                                  child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.circular(
                                          20,
                                        ),
                                    child: Image.memory(
                                      snapshot
                                          .data![index]
                                          .image,
                                      width: 70,
                                      height: 70,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(
                                        20,
                                        0,
                                        0,
                                        0,
                                      ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment
                                            .start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            'title   : ',
                                            style: TextStyle(
                                              fontWeight:
                                                  FontWeight
                                                      .bold,
                                            ),
                                          ),
                                          Text(
                                            snapshot
                                                .data![index]
                                                .title,
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'description : ',
                                            style: TextStyle(
                                              fontWeight:
                                                  FontWeight
                                                      .bold,
                                            ),
                                          ),
                                          Text(
                                            snapshot
                                                .data![index]
                                                .description,
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'duedate   : ',
                                            style: TextStyle(
                                              fontWeight:
                                                  FontWeight
                                                      .bold,
                                            ),
                                          ),
                                          Text(
                                            snapshot
                                                .data![index]
                                                .duedate
                                                .toString(),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : Center(child: Text('일정을 등록해주세요.'));
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text('오늘의 운세'),
              accountEmail: Text('"예상 밖의 곳에서 방법이 생겨요."'),
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage(
                  'images/dog.png',
                ),
              ),
              // otherAccountsPictures: [
              //   CircleAvatar(
              //     backgroundImage: AssetImage(
              //       'images/cat.png',
              //     ),
              //   ),
              //   CircleAvatar(
              //     backgroundImage: AssetImage(
              //       'images/dog.png',
              //     ),
              //   ),
              // ],
              decoration: BoxDecoration(
                color: const Color.fromARGB(
                  255,
                  231,
                  190,
                  187,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.alarm,
                color: const Color.fromARGB(
                  255,
                  206,
                  147,
                  142,
                ),
              ),
              title: Text('오늘 할일'),
              onTap: () => Get.to(Today()),
            ),
            ListTile(
              leading: Icon(
                Icons.alarm,
                color: const Color.fromARGB(
                  255,
                  206,
                  147,
                  142,
                ),
              ),
              title: Text('내일 할일'),
              onTap: () => Get.to(Tomorrow()),
            ),
            ListTile(
              leading: Icon(
                Icons.alarm,
                color: const Color.fromARGB(
                  255,
                  206,
                  147,
                  142,
                ),
              ),
              title: Text('이번주 할일'),
              onTap: () => Get.to(Week()),
            ),
            ListTile(
              leading: Icon(
                Icons.alarm,
                color: const Color.fromARGB(
                  255,
                  206,
                  147,
                  142,
                ),
              ),
              title: Text('이번달 할일'),
              onTap: () => Get.to(Month()),
            ),
          ],
        ),
      ),
    );
  } //function

  reloadData() {
    handler.queryTodo();
    setState(() {});
  }
}
