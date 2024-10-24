class Authentication {
  // String number;
  int otp;
  bool isRegistered;

  Authentication._sharedConstractor(this.otp, this.isRegistered);
  static final Authentication _shared = Authentication._sharedConstractor(
    0,
    false,
  );
  factory Authentication() => _shared;
}
