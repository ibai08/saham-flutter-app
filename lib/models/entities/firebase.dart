class FirebaseState {
  String? fcmToken;

  FirebaseState({this.fcmToken});

  static FirebaseState init() {
    return FirebaseState(fcmToken: null);
  }
}
