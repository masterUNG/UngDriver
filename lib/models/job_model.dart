class JobModel {
  String id;
  String idUser;
  String nameJob;
  String detailJob;
  String lat;
  String lng;
  String status;

  JobModel(
      {this.id,
      this.idUser,
      this.nameJob,
      this.detailJob,
      this.lat,
      this.lng,
      this.status});

  JobModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idUser = json['idUser'];
    nameJob = json['NameJob'];
    detailJob = json['DetailJob'];
    lat = json['Lat'];
    lng = json['Lng'];
    status = json['Status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['idUser'] = this.idUser;
    data['NameJob'] = this.nameJob;
    data['DetailJob'] = this.detailJob;
    data['Lat'] = this.lat;
    data['Lng'] = this.lng;
    data['Status'] = this.status;
    return data;
  }
}

