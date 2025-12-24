import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  final String title, thumb, id;

  const DetailScreen({
    super.key,
    required this.title,
    required this.thumb,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // HomeScreen을 벗어나기 때문에 새로운 AppBar를 만들어 준다.
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
        title: Text(title, style: TextStyle(fontSize: 20)),
      ),
      body: Column(
        children: [
          SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Hero(
                tag: id,
                child: Container(
                  width: 210,
                  // What is this??
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    // boxShadow: <- List<BoxShadow>?
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 5,
                        offset: Offset(4, 3.5),
                        color: Colors.black54.withValues(alpha: 0.7),
                      ),
                    ],
                  ),
                  child: Image.network(thumb),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
