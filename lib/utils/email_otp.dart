import 'package:email_otp/email_otp.dart';

class EmailService {

  void guiMaOTP(String emailNguoiNhan) async {
    try {
      // Cấu hình ứng dụng và OTP
      EmailOTP.config(
        appName: 'Money Track',
        otpType: OTPType.numeric,
        expiry: 30000,
        emailTheme: EmailTheme.v6,
        appEmail: '23211tt1909@mail.tdc.edu.vn',
        otpLength: 6,
      );

      // Cấu hình SMTP cho Gmail
      EmailOTP.setSMTP(
        host: 'smtp.gmail.com',
        emailPort: EmailPort.port587,
        username: '23211tt1909@mail.tdc.edu.vn',
        password:'ixal ctqg kvht zgur', // mk ứng dụng
        secureType: SecureType.tls,
      );

      // Gửi OTP đến email người dùng
      bool result = await EmailOTP.sendOTP(email: emailNguoiNhan);
    } catch (e) {
      print('Lỗi khi gửi OTP: $e');
    }
  }

  // Hàm kiểm tra OTP
  Future<bool> verifyOTP(String otpText) async {
    return await EmailOTP.verifyOTP(otp: otpText);
  }
}
