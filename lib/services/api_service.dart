import 'dart:convert';
// package 주소에 http라는 별명을 붙여준다.
import 'package:http/http.dart' as http;
import 'package:webtoon_app/models/webtoon_detail_model.dart';
import 'package:webtoon_app/models/webtoon_episode_model.dart';
import 'package:webtoon_app/models/webtoon_model.dart';

// API에 요청을 보내는 클래스
class ApiService {
  // base URL
  static const String baseUrl =
      "https://webtoon-crawler.nomadcoders.workers.dev";
  // endpoint ???
  static const String today = "today";

  // 특정 코드가 완전히 다 실행될 때까지 Flutter를 기다리게 한다 -> 비동기(async) 프로그래밍
  // 이 함수 내부에서 await을 사용하기 위해서, getTodaysToons()와 {} 중간에 async 키워드를 붙여 비동기 함수로 만든다.
  // async를 사용하는 경우, void를 반환할 때는 상관이 없지만, 그 외의 자료형을 반환하는 경우에는 Future<>로 감싸줘야 오류가 나지 않는다.
  static Future<List<WebtoonModel>> getTodaysToons() async {
    // WebtoonModel을 저장하기 위한 List
    List<WebtoonModel> webtoonInstances = [];
    final url = Uri.parse("$baseUrl/$today");
    // get() -> 서버에 get 요청을 보내는 함수.
    // 패키지에 as로 별명을 붙이면 http 패키지에서 가져오는 get 함수 앞에 http라는 별명을 붙여줘야 오류가 나지 않는다.
    // http.get(url) 앞에 await을 붙여서, 이 코드가 전부 처리될 때까지 다음 코드를 실행시키지 않는다.
    final response = await http.get(url);

    // '상태 코드'가 200인지(즉 정상적으로 처리가 되었는지) 체크한다.
    if (response.statusCode == 200) {
      // 정상적으로 처리가 된 경우에 실행하는 코드 블럭
      // 정상적으로 처리된 response.body에는 서버가 보낸 데이터가 있다.
      // jsonDecode() -> JSON으로 바꿔 가져와야 하는데 response.body의 본래 포맷은 String이 아닌 Response이므로, JSON 자료형으로 바꿔준다.
      // 굳이 List<dynamic> 자료형을 명시하지 않아도 정상적으로 동작하지만, 우리가 받아오는 데이터의 형식을 알기 쉽도록 하기 위해서 명시했다.
      final List<dynamic> webtoons = jsonDecode(response.body);
      for (var webtoon in webtoons) {
        webtoonInstances.add(WebtoonModel.fromJson(webtoon));
        // debugPrint(toon.title);
      }
      return webtoonInstances;
    }
    // '상태 코드'가 200이 아니면
    throw Error;
  }

  // ID로 webtoon을 한 개 받아오는 method
  static Future<WebtoonDetailModel> getToonById(String id) async {
    // 1. URL을 만든다.
    final url = Uri.parse("$baseUrl/$id");
    // 2. 해당 URL로 request를 보낸다.
    final response = await http.get(url);
    // 3. request가 성공적이면(== 200)
    if (response.statusCode == 200) {
      // 4. String 타입인 response.body를 json으로 decode한다.
      final webtoon = jsonDecode(response.body);
      // 5. decode한 json을 미리 만들어 둔 WebtoonDetailModel.fromJson()에 전달 & 리턴한다.
      return WebtoonDetailModel.fromJson(webtoon);
    }
    throw Error();
  }

  // ID 값에 따른 최신 episodes를 가져오는 method
  static Future<List<WebtoonEpisodeModel>> getLatestEpisodesById(
    String id,
  ) async {
    // 1. 에피소드들을 담아둘 빈 리스트를 미리 만든다.
    List<WebtoonEpisodeModel> episodesInstances = [];
    // 2. URL을 만든다.
    final url = Uri.parse("$baseUrl/$id/episodes");
    // 3. 해당 URL로 request를 보낸다.
    final response = await http.get(url);
    // 4. request가 성공적이면(== 200)
    if (response.statusCode == 200) {
      // 5. String 타입인 response.body를 json으로 decode한다.
      final episodes = jsonDecode(response.body);
      // 6. for in으로 episodes에서 episode를 하나씩 꺼내서
      for (var episode in episodes) {
        // 7. WebtoonEpisodeModel에 담고 미리 만들어 둔 빈 리스트에 하나씩 담는다.
        episodesInstances.add(WebtoonEpisodeModel.fromJson(episode));
      }
      // 8. List<WebtoonEpisodeModel>을 리턴한다.
      return episodesInstances;
    }
    throw Error();
  }
}
