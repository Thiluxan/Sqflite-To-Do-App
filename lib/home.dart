import 'package:flutter/material.dart';
import 'dbManager.dart';
import 'Activity.dart';
import 'display.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DbActivityManager dbActivityManager = new DbActivityManager();

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  final formKey = new GlobalKey<FormState>();

  Activity activity;
  List<Activity> activityList;
  int updateIndex;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("To-Do App"),
      ),
      body: ListView(children: [
        Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: "Title"),
                  controller: titleController,
                  validator: (value) =>
                      value.isNotEmpty ? null : "Title Should not be empty",
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: "Description"),
                  controller: descriptionController,
                  validator: (value) => value.isNotEmpty
                      ? null
                      : "Description Should not be empty",
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: RaisedButton(
                    textColor: Colors.white,
                    color: Colors.blueAccent,
                    child: Container(
                        width: width * 0.9,
                        child: Text(
                          "Submit",
                          textAlign: TextAlign.center,
                        )),
                    onPressed: () {
                      submitStudent(context);
                    },
                  ),
                ),
                FutureBuilder(
                  future: dbActivityManager.getActivityList(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      activityList = snapshot.data;
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: activityList.length,
                        itemBuilder: (BuildContext context, int index) {
                          Activity st = activityList[index];
                          return Card(
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (context) => Display(
                                            title: st.title,
                                            description: st.description)));
                              },
                              child: Row(
                                children: [
                                  Container(
                                    width: width * 0.6,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("${st.title}"),
                                          Text("${st.description}")
                                        ],
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                      icon: Icon(Icons.edit),
                                      color: Colors.blue,
                                      onPressed: () {
                                        titleController.text = st.title;
                                        descriptionController.text =
                                            st.description;
                                        activity = st;
                                        updateIndex = index;
                                      }),
                                  IconButton(
                                      icon: Icon(Icons.delete),
                                      color: Colors.red,
                                      onPressed: () {
                                        dbActivityManager.deleteActivity(st.id);
                                        setState(() {
                                          activityList.removeAt(index);
                                        });
                                      }),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                    return new CircularProgressIndicator();
                  },
                )
              ],
            ),
          ),
        )
      ]),
    );
  }

  void submitStudent(BuildContext context) {
    if (formKey.currentState.validate()) {
      if (activity == null) {
        Activity st = Activity(
            title: titleController.text.toString(),
            description: descriptionController.text.toString());
        dbActivityManager.insertActivity(st).then((value) => {
              titleController.clear(),
              descriptionController.clear(),
              print("Activity added")
            });
      } else {
        activity.title = titleController.text;
        activity.description = descriptionController.text;
        dbActivityManager.updateActivity(activity).then((value) => {
              setState(() {
                activityList[updateIndex].title = titleController.text;
                activityList[updateIndex].description =
                    descriptionController.text;
              }),
              titleController.clear(),
              descriptionController.clear(),
              activity = null
            });
      }
    }
  }
}
