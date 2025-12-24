import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:webtoon_app/models/webtoon_episode_model.dart';

class Episode extends StatelessWidget {
  final String webtoonId;
  final WebtoonEpisodeModel episode;

  const Episode({super.key, required this.episode, required this.webtoonId});

  Future onButtonTap() async {
    // 방법 1 (예시)
    // final url = Uri.parse("https://google.com");
    // // launchUrl, launchUrlString은 Future을 반환하는 함수다.
    // // 그러므로 이 함수를 비동기 함수로 만들고, launchUrl 앞에 await을 붙여준다.
    // await launchUrl(url);

    // 방법 2 (추천?)
    // launchUrlString(url) <- 웹 뷰를 통해 url 페이지로 이동함.
    await launchUrlString(
      "https://comic.naver.com/webtoon/detail?titleId=$webtoonId&no=${episode.id}",
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onButtonTap,
      child: Container(
        // Container 내부에서 margin 주기
        margin: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          // shade400 <- 명도 조절
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            width: 3,
            style: BorderStyle.solid,
            color: Colors.green.shade400,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.55), // 그림자 색
              spreadRadius: 1, // 그림자가 얼마나 퍼질지 (크기)
              blurRadius: 5, // 그림자를 얼마나 흐리게 할지 (번짐 정도)
              offset: Offset(3, 3.5), // 그림자 위치 (x: 가로, y: 세로)
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                episode.title,
                style: TextStyle(
                  color: Colors.green.shade400,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: Colors.green.shade400),
            ],
          ),
        ),
      ),
    );
  }
}
