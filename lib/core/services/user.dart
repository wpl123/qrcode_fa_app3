
// Singleton that holds the logged in users data

class LoggedInUserData {

static final LoggedInUserData _loggedInUserData = new LoggedInUserData._internal();

  int id;
  String email;
  String password;
  int serverConnect;
  String serverURL;
  int keepLocalHistory;
  int inAppBrowsing;
  String field1Label;
  String field2Label;
  String field3Label;
  int daysLocalHistory;
  int daysServerHistory;
  

  factory LoggedInUserData() {
    return _loggedInUserData;
  }  
  LoggedInUserData._internal();

}

final loggedInUserData = LoggedInUserData();