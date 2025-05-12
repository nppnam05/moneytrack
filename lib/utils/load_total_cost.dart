import 'package:moneytrack/models/transaction.dart';
import 'package:moneytrack/models/user.dart';
import 'package:moneytrack/services/database_api.dart';

class UserUtils {
  static Future<void> syncUserRevenueAndExpenditure(int userId) async {
    double revenue = 0;
    double expenditure = 0;

    final transactions = await DatabaseApi.getTransactionsByUserId(userId);
    for (final t in transactions) {
      if (t.type == "Thu") {
        revenue += t.amount;
      } else if (t.type == "Chi") {
        expenditure += t.amount;
      }
    }

    final user = await DatabaseApi.getUserById(userId);
    if (user != null) {
      user.totalRevenue = revenue;
      user.totalExpenditure = expenditure;

      await DatabaseApi.updateUser(
        user,
        onSuccess: () => print("Đồng bộ tổng thu/chi thành công."),
        onError: (e) => print("Lỗi khi cập nhật user: $e"),
      );
    }
  }
}
