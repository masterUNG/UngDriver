import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ungdriver/models/job_model.dart';
import 'package:ungdriver/screens/detail_job.dart';
import 'package:ungdriver/utility/my_constant.dart';

class ShowListJob extends StatefulWidget {
  @override
  _ShowListJobState createState() => _ShowListJobState();
}

class _ShowListJobState extends State<ShowListJob> {
  List<JobModel> jobModels = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readJob();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: jobModels.length == 0
          ? Center(child: CircularProgressIndicator())
          : buildListView(),
    );
  }

  ListView buildListView() {
    return ListView.builder(
      itemCount: jobModels.length,
      itemBuilder: (context, index) => GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailJob(jobModel: jobModels[index],),
          ),
        ),
        child: Card(
          color: index % 2 == 0 ? Colors.grey[300] : Colors.grey[50],
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                buildTextHeader(index),
                buildTextDetail(index),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Text buildTextDetail(int index) {
    String string = jobModels[index].detailJob;

    if (string.length >= 30) {
      string = string.substring(1, 100);
      string = '$string ...';
    }

    return Text(string);
  }

  Row buildTextHeader(int index) => Row(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 8),
            child: Text(
              jobModels[index].nameJob,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      );

  Future<Null> readJob() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String idUser = preferences.getString('id');

    String urlAPI =
        '${MyConstant().domain}/pooh/getJobWhereIdUser.php?isAdd=true&idUser=$idUser';
    Response response = await Dio().get(urlAPI);
    print('res = $response');
    var result = json.decode(response.data);

    for (var map in result) {
      JobModel model = JobModel.fromJson(map);
      setState(() {
        jobModels.add(model);
      });
    }
  }
}
