import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webtoon_app/models/webtoon_detail_model.dart';
import 'package:webtoon_app/models/webtoon_episode_model.dart';
import 'package:webtoon_app/services/api_service.dart';
import 'package:webtoon_app/widgets/episode_widget.dart';

class DetailScreen extends StatefulWidget {
  final String title, thumb, id;

  const DetailScreen({
    super.key,
    required this.title,
    required this.thumb,
    required this.id,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  // 생성자에서 초기화하기 어려운 변수들은 late와 initState()를 사용해서 초기화해 줄 수 있다.
  late Future<WebtoonDetailModel> webtoon;
  late Future<List<WebtoonEpisodeModel>> episodes;
  late SharedPreferences prefs;
  bool isLiked = false;

  // Preferences를 초기화(initialize)하는 작업.
  Future initPrefs() async {
    // 사용자의 저장소와 연결함.
    // SharedPreferences의 모든 get~, set~ 함수는 비동기 함수이므로 앞에 await을 붙여준다.
    prefs = await SharedPreferences.getInstance();
    // 사용자의 저장소에서 'likedToons'를 검색해서 List<String>을 가져옴.
    final likedToons = prefs.getStringList('likedToons');
    // 유저의 저장소에 likedToons가 존재하면 다음 작업을 수행하고,
    if (likedToons != null) {
      // 웹툰 id가 likedToons에 검색되면 이 웹툰이 '좋아하는 웹툰'에 등록되어 있다는 뜻이므로,
      // 상태에 따른 아이콘 표현을 위해 isLiked를 true 상태로 바꿈
      if (likedToons.contains(widget.id)) {
        setState(() {
          // setState 없이 isLiked를 true로 변경하면 화면이 바뀌지 않음에 주의.
          isLiked = true;
        });
      }
    } else {
      // 'likedToons'라는 것이 애초에 존재하지 않으면, 즉 이 앱을 유저가 처음 켜는 경우에는
      // 유저의 저장소에 likedToons라는 List<String>을 만들어 저장해 준다.
      await prefs.setStringList('likedToons', []);
    }
  }

  @override
  void initState() {
    super.initState();
    // StatelessWidget에서는 변수를 초기화하면서 동시에 Argument로 쓸 수 없으므로,
    // build 이전에 Argument를 필요로 하는 함수를 사용해야 할 때는 이와 같이 StatefulWidget, late, initState()를 활용해야 한다.
    webtoon = ApiService.getToonById(widget.id);
    episodes = ApiService.getLatestEpisodesById(widget.id);
    initPrefs();
  }

  void onHeartTap() async {
    // likedToons를 가져옴.
    final likedToons = prefs.getStringList('likedToons');
    // 위에서 했던 likedToons != null 작업을 다시 한 번 해 줌.
    if (likedToons != null) {
      // 'likedToons'가 저장소에 존재하고, '좋아요' List에 이 웹툰 id가 등록된 상태인 경우
      if (isLiked) {
        // 좋아요 리스트에서 웹툰 id를 삭제함. ('좋아요' 취소)
        likedToons.remove(widget.id);
      } else {
        // 좋아요 리스트에 웹툰 id를 추가함. ('좋아요' 등록)
        likedToons.add(widget.id);
      }
      // 수정된 List를 다시 유저 저장소의 'likedToons'에 저장해 줌.
      await prefs.setStringList('likedToons', likedToons);
      // 화면에서 아이콘 상태를 바꿔줘야 하기 때문에, setState 내부에서 isLiked를 변경해 줌.
      setState(() {
        // 지금의 isLiked 값에 반대되는 값으로 변경시키기 (이럴 때 isLiked = false; 처럼 짜면 안 됨)
        isLiked = !isLiked;
      });
    } else {
      await prefs.setStringList('likedToons', []);
    }
  }

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
        // ??
        actions: [
          IconButton(
            onPressed: onHeartTap,
            // isLiked가 true면 꽉 채운 하트 아이콘을, 그렇지 않으면 속이 비어있는 하트 이모티콘을 반환함.
            icon: Icon(isLiked ? Icons.favorite : Icons.favorite_outline),
          ),
        ],
        // widget.title <- State가 속한 StatefulWidget의 'data'를 받아오는 방법
        title: Text(
          widget.title,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(50),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: widget.id,
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
                      child: Image.network(widget.thumb),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              // builder <- widget을 return하는 function
              FutureBuilder(
                future: webtoon,
                builder: (context, snapshot) {
                  // 데이터 불러오기가 완료되어서 snapshot이 데이터를 가지고 있는 경우
                  if (snapshot.hasData) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          snapshot.data!.about,
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          "장르 : ${snapshot.data!.genre} / ${snapshot.data!.age}",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    );
                  }
                  // 데이터를 (아직) 가져오지 못 한 경우
                  return Text("...");
                },
              ),
              const SizedBox(height: 25),
              FutureBuilder(
                future: episodes,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        // Collection for
                        // snapshot.data에 들어있는 요소의 개수가 10개가 넘으면
                        // 인덱스 0부터 10까지를(0 이상 10 미만을) 잘라서 반환하고,
                        // 그렇지 않으면 snapshot의 모든 data를 그대로 가져온다.
                        // 여기서도 삼항연산자 쓸 수 있었구나!!!
                        for (var episode
                            in snapshot.data!.length > 10
                                ? snapshot.data!.sublist(0, 10)
                                : snapshot.data!)
                          Episode(episode: episode, webtoonId: widget.id),
                      ],
                    );
                  }
                  return Container();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
