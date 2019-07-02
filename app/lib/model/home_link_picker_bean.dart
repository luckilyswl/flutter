class HomeLinkPickerBean {
  int id;
  String name;
  String aliasName;

  List<HomeLinkPickerBean> subItems;

  HomeLinkPickerBean({this.id, this.name, this.aliasName, this.subItems});

  HomeLinkPickerBean.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    aliasName = json['aliasName'];
    if (json['sub_items'] != null) {
      subItems = new List<HomeLinkPickerBean>();
      json['sub_items'].forEach((v) {
        subItems.add(new HomeLinkPickerBean.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['aliasName'] = this.aliasName;
    if (this.subItems != null) {
      data['sub_items'] = this.subItems.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
