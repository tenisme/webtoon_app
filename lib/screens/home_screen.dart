import 'package:flutter/material.dart';
import 'package:webtoon_app/models/webtoon_model.dart';
import 'package:webtoon_app/services/api_service.dart';
import 'package:webtoon_app/widgets/webtoon_widget.dart';

class HomeScreen extends StatelessWidget {
  // Future가 들어간 class는 생성자가 const일 수 없다.
  HomeScreen({super.key});

  final Future<List<WebtoonModel>> webtoons = ApiService.getTodaysToons();

  // StatefulWidget일 때 썼던 방법(비추)
  // List<WebtoonModel> webtoons = [];
  // bool isLoading = true;

  // void waitForWebToons() async {
  //   webtoons = await ApiService.getTodaysToons();
  //   isLoading = false;
  //   // setState()는 많이 쓰지 않는 것이 좋다.
  //   setState(() {});
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   waitForWebToons();
  // }

  @override
  Widget build(BuildContext context) {
    // debugPrint("$webtoons");
    // debugPrint("$isLoading");

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
      // FutureBuilder <- Future 값을 기다리고, 데이터가 존재하는지 알려준다.
      // future: <- 'Future<>'가 붙어있는 객체를 넣을 수 있다.
      // builder: <- UI를 그린다.
      // snapshot으로 Future의 상태를 알 수 있다.
      body: FutureBuilder(
        future: webtoons,
        builder: (context, snapshot) {
          // snapshot이 data를 가지고 있으면 true
          // Listview.builder는 그냥 ListView보다 더 최적화된 기능을 갖고 있다.
          // Listview.builder는 사용자가 보고 있는 아이템만 build한다.
          if (snapshot.hasData) {
            return Column(
              children: [
                SizedBox(height: 50),
                Expanded(child: makeList(snapshot)),
              ],
            );

            // return ListView(
            // children: [
            // snapshot.data는 Future의 결과값이다.
            // 여기서 snapshot.data의 자료형은 List<WebtoonModel>이다.
            // for (var webtoon in snapshot.data!) Text(webtoon.title),
            // ],)
          }
          // snapshot이 데이터를 가지고 있지 않으면(즉 아직 로딩중이면) 아래 코드 실행
          // 로딩 인디케이터(로딩 애니메이션) 위젯
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  ListView makeList(AsyncSnapshot<List<WebtoonModel>> snapshot) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      // 아이템의 총 개수
      itemCount: snapshot.data!.length,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      // Listview.builder는 가지고 있는 모든 아이템을 한 번에 build하지 않고,
      // 만들려는 아이템에 itemBuilder 함수를 실행한다.
      // 우리는 이 함수를 통해서 build되는 아이템의 index에 접근할 수 있다.
      // 어떤 아이템이 build되는지 알 수 있는 방법은 index를 이용하는 것 뿐이다.
      itemBuilder: (context, index) {
        debugPrint("$index");
        var webtoon = snapshot.data![index];
        return Webtoon(
          title: webtoon.title,
          thumb: webtoon.thumb,
          id: webtoon.id,
        );
      },
      // List의 맨 앞과 맨 뒤에서는 구분자(separator)가 작동하지 않는다.
      separatorBuilder: (context, index) => const SizedBox(width: 40),
    );
  }
}
