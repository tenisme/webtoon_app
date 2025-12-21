// api_service.dart에서 추출한 각각의 JSON 객체를 받아서 객체 내부의 데이터를 개별 저장(초기화)하는 클래스
class WebtoonModel {
  final String title, thumb, id;

  // named constructor
  // 생성자의 역할이 분명할 땐 named constructor를 쓰는 것이 확실하고 좋다.
  WebtoonModel.fromJson(Map<String, dynamic> json)
    : title = json['title'],
      thumb = json['thumb'],
      id = json['id'];
}
