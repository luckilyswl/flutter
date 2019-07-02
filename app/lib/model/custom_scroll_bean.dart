/*
 * 自定义滚动List的Model类 Bean 
 **/
class CustomScrollBean {
  String title;
  String subTitle;
  bool hasBg;

  CustomScrollBean({this.title, this.subTitle, this.hasBg});

  CustomScrollBean.fromJson(Map<String, dynamic> json) {
    this.title = json['title'];
    this.subTitle = json['subTitle'];
    this.hasBg = json['hasBg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['subTitle'] = this.subTitle;
    data['hasBg'] = this.hasBg;
    return data;
  }
}
