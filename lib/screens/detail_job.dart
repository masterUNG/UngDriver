import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ungdriver/models/job_model.dart';

class DetailJob extends StatefulWidget {
  final JobModel jobModel;
  DetailJob({Key key, this.jobModel}) : super(key: key);
  @override
  _DetailJobState createState() => _DetailJobState();
}

class _DetailJobState extends State<DetailJob> {
  JobModel model;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    model = widget.jobModel;
  }

  Set<Marker> mySet() {
    return <Marker>[
      Marker(
        infoWindow:
            InfoWindow(title: 'สถานที่ทำงาน', snippet: model.nameJob),
        markerId: MarkerId('myID'),
        position: LatLng(
          double.parse(model.lat.trim()),
          double.parse(
            model.lng.trim(),
          ),
        ),
      ),
    ].toSet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(model == null ? '' : model.nameJob),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(model.detailJob),
          ),
          Expanded(
            child: Container(
              color: Colors.grey,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    double.parse(model.lat.trim()),
                    double.parse(
                      model.lng.trim(),
                    ),
                  ),
                  zoom: 16,
                ),
                onMapCreated: (controller) {},
                markers: mySet(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
