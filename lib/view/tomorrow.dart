import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:to_do_list/view/detail.dart';
import 'package:to_do_list/view/home.dart';
import 'package:to_do_list/view/update.dart';
import 'package:to_do_list/vm/database_handler.dart';

class Tomorrow extends StatefulWidget {
  const Tomorrow({super.key});

  @override
  State<Tomorrow> createState() => _TomorrowState();
}

class _TomorrowState extends State<Tomorrow> {
  DatabaseHandler handler = DatabaseHandler();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('내일 할일')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: handler.queryTodoByTomorrow(),
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
                                        snapshot
                                            .data![index]
                                            .todo_id,
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
                                                .duedate,
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'iscompleted : ',
                                            style: TextStyle(
                                              fontWeight:
                                                  FontWeight
                                                      .bold,
                                            ),
                                          ),
                                          Text(
                                            snapshot
                                                .data![index]
                                                .iscompleted
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
    );
  }

  //function
  reloadData() {
    setState(() {});
  }
}
