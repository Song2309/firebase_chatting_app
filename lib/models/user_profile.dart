class UserProfile {
  String? uid;
  String? name;
  String? pfpURL;

  UserProfile({
    required this.uid,
    required this.name,
    required this.pfpURL,
  });

  UserProfile.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    pfpURL = json['pfpURL'];
    uid = json['uid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['pfpURL'] = pfpURL;
    data['uid'] = uid;
    return data;
  }
}
