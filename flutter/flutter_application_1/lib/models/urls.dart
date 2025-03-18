class Urls {
  final int URLId;
  final String Origin_url;
  final String Short_url;
  final int user_id;
  final DateTime Create_date;
  final DateTime Expired_date;

  Urls({
    required this.URLId,
    required this.Origin_url,
    required this.Short_url,
    required this.user_id,
    required this.Create_date,
    required this.Expired_date,
  });

  Map<String, dynamic> toJson() {
    return {
      'URLId': URLId,
      'Origin_url': Origin_url,
      'Short_url': Short_url,
      'user_id': user_id,
      'Create_date': Create_date,
      'Expired_date': Expired_date,
    };
    }
  }
