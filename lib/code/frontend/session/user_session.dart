class UserSession {
  static String firstName = '';
  static String lastName = '';
  static String email = '';
  static String cnic = '';
  static String role = '';
  static String gender = '';
  static String token = '';
  static int userId = 0;
  static String? profileImage; // ✅ YEH ADD KARO

  static void clear() {
    firstName = '';
    lastName = '';
    email = '';
    cnic = '';
    role = '';
    gender = '';
    token = '';
    userId = 0;
    profileImage = null; // ✅ YEH BHI clear mein add karo
  }
}
