import 'package:flutter/material.dart';
import 'package:webtoon_app/screens/detail_screen.dart';

class Webtoon extends StatelessWidget {
  final String title, thumb, id;

  const Webtoon({
    super.key,
    required this.title,
    required this.thumb,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    // GestureDetector <- 동작 감지 위젯
    return GestureDetector(
      // 버튼을 눌렀을 때
      onTap: () {
        // Navigator로 새 route를 push한다.
        // Navigator.push를 사용하면 애니메이션 효과를 이용해서 유저가 다른 페이지로 왔다고 느끼게 해줄 수 있다.
        Navigator.push(
          context,

          // route 사용 예시 1 - 강의 내용
          // MaterialPageRoute(
          //   builder: (context) =>
          //       // 여기서 새로운 위젯을 띄워준다.
          //       DetailScreen(title: title, thumb: thumb, id: id),
          //   // 바닥에서 올라오는 애니메이션 효과 주기 (애니메이션은 작동 안 됨, AppBar x표시는 작동 잘 됨)
          //   fullscreenDialog: true,
          // ),

          // route 사용 예시 2 - 강의 댓글 펌 (작동 잘 됨)
          PageRouteBuilder(
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  var begin = const Offset(0.0, 1.0);
                  var end = Offset.zero;
                  var curve = Curves.ease;
                  var tween = Tween(
                    begin: begin,
                    end: end,
                  ).chain(CurveTween(curve: curve));
                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
            pageBuilder: (context, animation, secondaryAnimation) =>
                DetailScreen(title: title, thumb: thumb, id: id),
            // 바닥에서 올라오는 애니메이션 효과 주기
            fullscreenDialog: true,
          ),
        );
        debugPrint("Go to detail screen.");
      },
      child: Column(
        children: [
          // Hero <- 다른 두 화면에 있는 같은 요소가 하나인 것처럼 움직이는 효과를 주기 위한 위젯.
          Hero(
            tag: id,
            // image의 사이즈를 조절하기 위해서 Container 혹은 SizedBox 안에 집어 넣는다.
            child: Container(
              width: 210,
              // 자식이 부모 요소를 넘어서 튀어나올 때 처리하는 방법
              // Clip.hardEdge <- 부모 영역 바깥을 날카롭게 잘라냄
              // 보통 부모 요소에서 borderRadius를 썼을 때 같이 사용함.
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
          SizedBox(height: 10),
          Text(title, style: TextStyle(fontSize: 15)),
        ],
      ),
    );
  }
}
