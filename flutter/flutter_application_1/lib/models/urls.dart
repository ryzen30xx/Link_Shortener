class Urls {
  // final int URLId;
  final String Origin_url;
  final String Short_url;
  final int userName;
  final DateTime Create_date;
  final DateTime Expired_date;

  Urls({
    // required this.URLId,
    required this.Origin_url,
    required this.Short_url,
    required this.userName,
    required this.Create_date,
    required this.Expired_date,
  });

  Map<String, dynamic> toJson() {
    return {
      'Origin_url': Origin_url,
      'Short_url': Short_url,
      'userName': userName,
      'Create_date': Create_date,
      'Expired_date': Expired_date,
    };
    }
  }
