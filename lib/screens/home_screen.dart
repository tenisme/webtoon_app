import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Scaffold() : screen을 위한 기본적인 레이아웃과 설정을 제공해 준다.
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // title 가운데 정렬
        centerTitle: true,
        // 그림자 두께 정도를 조절함
        elevation: 2,
        shadowColor: Colors.black,
        backgroundColor: Colors.white,
        // appBar의 폰트 컬러를 변경한다.
        foregroundColor: Colors.green,
        // ???
        surfaceTintColor: Colors.white,
        title: Text("Today's Webtoons", style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
