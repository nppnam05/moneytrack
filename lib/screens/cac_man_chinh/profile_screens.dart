import 'package:flutter/material.dart';
class ProfileScreens extends StatefulWidget {
  ProfileScreens({super.key, required this.title});

  final String title;

  @override
  _ProfileScreensState createState() => _ProfileScreensState();
}

class _ProfileScreensState extends State<ProfileScreens> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tài khoản'),
        actions: [
          IconButton(
            icon: Icon(Icons.language),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(radius: 50, child: Text('V')),
            SizedBox(height: 10),
            Text('vophamtienanh@gmail.com'),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.account_balance_wallet),
              title: Text('Số tiền'),
              trailing: Text('0', style: TextStyle(color: Colors.black)),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.calendar_today),
              title: Text('Tháng này (01/04 - 30/04)'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.account_balance),
              title: Text('Tổng cộng'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {},
            ),
            SizedBox(height: 20),
            ListTile(
              title: Text('Lập lại ngân sách này'),
              subtitle: Text('Ngân sách được tự động lập lại ở kỳ hạn tiếp theo.'),
              leading: Checkbox(
                value: false,
                onChanged: (value) {},
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
              },
              child: Text('Đăng xuất'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Tổng quan'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: 'Số giao dịch'),
          BottomNavigationBarItem(icon: Icon(Icons.add, color: Colors.transparent), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Ngân sách'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Tài khoản'),
        ],
        currentIndex: 4,
        onTap: (index) {
          if (index == 0) Navigator.pushNamed(context, '/home', arguments: {'animation': 'slide'});
          if (index == 1) Navigator.pushNamed(context, '/transactions', arguments: {'animation': 'slide'});
          if (index == 3) Navigator.pushNamed(context, '/budget', arguments: {'animation': 'slide'});
        },
      ),
    );
  }
}
