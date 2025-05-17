import 'package:floor/floor.dart';
import 'package:flutter/material.dart';
import 'package:moneytrack/models/user.dart';
import 'package:moneytrack/models/wallet.dart';
import 'package:moneytrack/screens/bao_mat/login_screen.dart';
import 'package:moneytrack/utils/database/database_api.dart';
import 'package:moneytrack/utils/show_notification.dart';

class ProfileScreens extends StatefulWidget {
  ProfileScreens({super.key, required this.title});

  final String title;

  @override
  _ProfileScreensState createState() => _ProfileScreensState();
}

class _ProfileScreensState extends State<ProfileScreens>
    with WidgetsBindingObserver {
  User? user = null;
  Wallet? wallet = null;
  int _userId = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // gọi dữ liệu lần đầu
    _loadData();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Gọi hàm cập nhật dữ liệu
    _loadData();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tài khoản'),
        actions: [
          IconButton(icon: Icon(Icons.language), onPressed: () {}),
          IconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              child: Text(
                user?.name.substring(0, 1) ?? "",
                style: TextStyle(fontSize: 40),
              ),
            ),
            SizedBox(height: 10),
            Text(
              user?.name ?? "",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            _buildWalletCard(),
            _buildUserCard(),
            _buildDepositCard(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // sét lại trạng thái thông báo
                ShowNotification.checkMap.updateAll((key, value) => false);

                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/login',
                  (Route<dynamic> route) => false,
                );
              },
              child: Text('Đăng xuất'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserCard() {
    return Card(
      child: ListTile(
        leading: Icon(Icons.account_circle),
        title: Text('Tên người dùng'),
        subtitle: Text(user?.name ?? "Chưa có tên"),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: () {
          _showEditUserDialog();
        },
      ),
    );
  }

  Widget _buildWalletCard() {
    return Card(
      child: ListTile(
        leading: Icon(Icons.account_balance_wallet),
        title: Text('Số dư ví'),
        subtitle: Text("${formatCurrency(wallet?.balance ?? 0)} VNĐ"),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: () {
          _showEditWalletDialog();
        },
      ),
    );
  }

  Widget _buildDepositCard() {
    return Card(
      child: ListTile(
        leading: Icon(Icons.attach_money),
        title: Text('Nạp tiền vào ví'),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: () {
          _showDepositDialog();
        },
      ),
    );
  }

  void _loadData() async {
    _userId = LoginScreen.userid;
    // Gọi API để lấy dữ liệu người dùng
    var resultUser = await DatabaseApi.getUserById(_userId);
    var resultWallet = await DatabaseApi.getWalletsByUserId(_userId);

    setState(() {
      // Cập nhật lại giao diện với dữ liệu mới
      user = resultUser;
      wallet = resultWallet[0];
    });
  }

  // định dạng tiền
  String formatCurrency(double amount) {
    final parts = amount.toStringAsFixed(2).split('.');
    final wholePart = parts[0];
    final decimalPart = parts[1];

    final buffer = StringBuffer();
    int count = 0;

    for (int i = wholePart.length - 1; i >= 0; --i) {
      buffer.write(wholePart[i]);
      count++;
      if (count % 3 == 0 && i != 0) {
        buffer.write('.');
      }
    }

    final formattedWhole = buffer.toString().split('').reversed.join();
    if (decimalPart == "00") {
      return formattedWhole;
    }
    return '$formattedWhole,$decimalPart';
  }

  // Hộp thoại chỉnh sửa số dư ví
  void _showEditWalletDialog() {
    final TextEditingController balanceController = TextEditingController(
      text: wallet?.balance.toString() ?? "0",
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Chỉnh sửa số dư ví'),
          content: TextField(
            controller: balanceController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Số dư mới',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại
              },
              child: Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () async {
                final newBalance = double.tryParse(balanceController.text) ?? 0;
                setState(() {
                  wallet?.balance = newBalance; 
                });

                // Gọi API để cập nhật số dư trong cơ sở dữ liệu
                await DatabaseApi.updateWallet(wallet!, onSuccess: () {}, onError: (error) {});

                Navigator.of(context).pop(); // Đóng hộp thoại
              },
              child: Text('Lưu'),
            ),
          ],
        );
      },
    );
  }

  // Hộp thoại chỉnh sửa tên người dùng
  void _showEditUserDialog() {
    final TextEditingController nameController = TextEditingController(
      text: user?.name ?? "",
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Chỉnh sửa tên người dùng'),
          content: TextField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: 'Tên mới',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại
              },
              child: Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () async {
                final newName = nameController.text.trim();
                if (newName.isNotEmpty) {
                  setState(() {
                    user?.name = newName; 
                  });

                  // Gọi API để cập nhật tên trong cơ sở dữ liệu
                  await DatabaseApi.updateUser(user!, onSuccess: () { }, onError: (error) {});
                }

                Navigator.of(context).pop(); // Đóng hộp thoại
              },
              child: Text('Lưu'),
            ),
          ],
        );
      },
    );
  }

  void _showDepositDialog() {
    final TextEditingController depositController = TextEditingController(
      text: "10",
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Nạp tiền vào ví'),
          content: TextField(
            controller: depositController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Số tiền muốn nạp',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại
              },
              child: Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () async {
                final amount = double.tryParse(depositController.text) ?? 0;
                 setState(() {
                    wallet!.balance += amount;
                  });
                  await DatabaseApi.updateWallet(wallet!, onSuccess: () {}, onError: (error) {});
                  Navigator.of(context).pop(); // Đóng hộp thoại
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Nạp tiền thành công!')),
                  );
              },
              child: Text('Nạp'),
            ),
          ],
        );
      },
    );
  }
}
