import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intership/Admin/Report/ReportModel.dart';
import 'package:intership/Admin/model/session.dart';
import 'package:intership/constant/color.dart';
import 'package:intl/intl.dart';

import '../../constant/ApI.dart';

class mnagerReport extends StatefulWidget {
  String managerID;
  String report;
  mnagerReport({Key? key, required this.managerID, required this.report}) : super(key: key);

  @override
  _mnagerReportState createState() => _mnagerReportState();
}

class _mnagerReportState extends State<mnagerReport> {
  List<ReportModel> managerreportlist = [];
  Future<dynamic> managerReportFunc(String managerId, Report, startdate, endate) async {
    try {
      Session _session = Session();
      final data = jsonEncode(<String, String>{
        'startDate': startdate,
        'endDate': endate,
      });
      final response = await _session.post(
          'http://$ip/admin/reports/$Report/$managerId', data);
      print("Dhiraj ${response.toString()}");
      for (dynamic i in response['result']) {
        print("iii $i");
        managerreportlist.add(ReportModel.fromJson(i));
      }
      print("managerreportlist  ${managerreportlist}");
      setState(() {

      });
      return response;
    } catch (e) {
      print(e.toString());
    }
  }

  TextEditingController opendate = TextEditingController();
  TextEditingController closedate = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    // managerReportFunc(
    //     "82027796-7695-42eb-b314-5ba0e647c81e", "2021-12-02", "2023-02-02");
    // opendate.text = ""; //set the initial value of text field
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Manager Report"),
        ),
        body: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                // Row(
                //   children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    style: TextStyle(color: Colors.black),
                    controller: opendate,
                    decoration: const InputDecoration(
                      icon: Icon(
                        Icons.calendar_today,
                        color: Colors.black,
                      ),
                      hintText: 'Start Date',
                      hintStyle: TextStyle(color: Colors.black),
                      labelText: 'OpenDate',
                      labelStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                    ),
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(
                              2000), //DateTime.now() - not to allow to choose before today.
                          lastDate: DateTime(2101));

                      if (pickedDate != null) {
                        print(
                            pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                        String formattedDate =
                            DateFormat('yyyy-MM-dd').format(pickedDate);
                        print(
                            formattedDate); //formatted date output using intl package =>  2021-03-16
                        //you can implement different kind of Date Format here according to your requirement

                        setState(() {
                          opendate.text =
                              formattedDate; //set output date to TextField value.
                        });
                      } else {
                        print("Date is not selected");
                      }
                    },
                    validator: (value) {
                      if (value != null && value.length < 1) {
                        return 'This field cant be null';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    style: TextStyle(color: Colors.black),
                    controller: closedate,
                    decoration: const InputDecoration(
                      icon: Icon(
                        Icons.calendar_today,
                        color: Colors.black,
                      ),
                      hintText: 'End Date',
                      hintStyle: TextStyle(color: Colors.black),
                      labelText: 'CloseDate',
                      labelStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                    ),
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(
                              2000), //DateTime.now() - not to allow to choose before today.
                          lastDate: DateTime(2101));

                      if (pickedDate != null) {
                        print(
                            pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                        String formattedDate =
                            DateFormat('yyyy-MM-dd').format(pickedDate);
                        print(
                            formattedDate); //formatted date output using intl package =>  2021-03-16
                        //you can implement different kind of Date Format here according to your requirement

                        setState(() {
                          closedate.text =
                              formattedDate; //set output date to TextField value.
                        });
                      } else {
                        print("Date is not selected");
                      }
                    },
                    validator: (value) {
                      if (value != null && value.length < 1) {
                        return 'This field cant be null';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                    height: 50,
                    child: ElevatedButton(
                        onPressed: () async {
                          final isValidForm = _formKey.currentState!.validate();
                          if (isValidForm) {
                            await managerReportFunc(
                                    widget.managerID,
                                    widget.report,
                                    opendate.text.toString(),
                                    closedate.text.toString())
                                .catchError((err) {});
                            if (true) {
                              // closedate.clear();
                              // opendate.clear();
                              // setState(() {
                                opendate.text = "";
                                closedate.text = "";
                              // });
                              final snackBar = SnackBar(
                                content: Text("response['data']"),
                                backgroundColor: (Colors.black12),
                                action: SnackBarAction(
                                  label: 'dismiss',
                                  onPressed: () {},
                                ),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                              return;
                            } else {
                              return;
                            }
                          }
                        },
                        child: Text('Get Report'))),
                SizedBox(
                  height: 40,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                    ),
                    Flexible(
                      child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Table(
                            // border:TableBorder.symmetric(inside: BorderSide(width: 1,color: Colors.black),outside: BorderSide(width: 1,color: Colors.black),),
                            border: TableBorder.all(),
                            defaultColumnWidth: FixedColumnWidth(190),
                            children: [
                              TableRow(children: [
                                Column(children: [
                                  Text('TaskName',
                                      style: TextStyle(fontSize: 17.0)),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemCount: managerreportlist.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Column(
                                        children: [
                                          Text("${managerreportlist[index].taskName}")
                                        ],
                                      );
                                        },
                                  ),
                                ]),
                                Column(children: [
                                  Text('OpenDate',
                                      style: TextStyle(fontSize: 17.0)),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemCount: managerreportlist.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Column(
                                        children: [
                                          Text("${managerreportlist[index].openDate?.substring(0,10)}")
                                        ],
                                      );
                                    },
                                  ),
                                ]),
                                Column(children: [
                                  Text('AssignationDate',
                                      style: TextStyle(fontSize: 17.0)),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemCount: managerreportlist.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Column(
                                        children: [
                                          Text("${managerreportlist[index].assignationDate?.substring(0,10)}")
                                        ],
                                      );
                                    },
                                  ),
                                ]),
                                Column(children: [
                                  Text('OperatorAcceptDate',
                                      style: TextStyle(fontSize: 16.0)),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemCount: managerreportlist.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Column(
                                        children: [
                                          Text("${managerreportlist[index].operatorAcceptDate?.substring(0,10)}")
                                        ],
                                      );
                                    },
                                  ),
                                ]),
                                Column(children: [
                                  Text('ActualCloseDate',
                                      style: TextStyle(fontSize: 17.0)),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemCount: managerreportlist.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Column(
                                        children: [
                                          Text("${managerreportlist[index].actualCloseDate?.substring(0,10)}")
                                        ],
                                      );
                                    },
                                  ),
                                ]),
                                Column(children: [
                                  Text('CloseDate',
                                      style: TextStyle(fontSize: 17.0)),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemCount: managerreportlist.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Column(
                                        children: [
                                          Text("${managerreportlist[index].closeDate?.substring(0,10)}")
                                        ],
                                      );
                                    },
                                  ),
                                ]),
                                Column(children: [
                                  Text('AssignationStatus',
                                      style: TextStyle(fontSize: 17.0)),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemCount: managerreportlist.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Column(
                                        children: [
                                          Text("${managerreportlist[index].AssignationStatus}")
                                        ],
                                      );
                                    },
                                  ),
                                ]),
                                Column(children: [
                                  Text('TaskStatus',
                                      style: TextStyle(fontSize: 17.0)),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemCount: managerreportlist.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Column(
                                        children: [
                                          Text("${managerreportlist[index].taskStatus}")
                                        ],
                                      );
                                    },
                                  ),
                                ]),
                              ]),
                            ],
                          )),
                    )
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
