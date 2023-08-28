import 'package:baemin/common/const/colors.dart';
import 'package:flutter/material.dart';

class RatingCard extends StatelessWidget {
  //NetworkImage or AssetImage
  //CircleAvatar
  final ImageProvider avatarImage;

  //리스트로 위젝 이미지를 보여줄때
  final List<Image> images;

  //별점
  final int rating;

  //이메일
  final String email;

  //리뷰내용
  final String content;

  const RatingCard({
    required this.avatarImage,
    required this.images,
    required this.rating,
    required this.email,
    required this.content,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Header(
          avatarImage: avatarImage,
          rating: rating,
          email: email,
        ),
        const SizedBox(height: 8.0,),
        _Body(
          content: content,
        ),
        const SizedBox(height: 8.0,),
        _Images(),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  final ImageProvider avatarImage;
  final String email;
  final int rating;

  const _Header({
    required this.avatarImage,
    required this.rating,
    required this.email,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 12.0,
          backgroundImage: avatarImage,
        ),
        const SizedBox(
          width: 8.0,
        ),
        Expanded(
          child: Text(
            email,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(
          width: 8.0,
        ),
        ...List.generate(
          5,
          (index) => Icon(
            index < rating ? Icons.star : Icons.star_border_outlined,
            color: PRIMARY_COLOR,
          ),
        ),
      ],
    );
  }
}

class _Body extends StatelessWidget {
  final String content;

  const _Body({
    required this.content,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        //Flexible에 있는 텍스트는 영역을을 넘으면 다음줄로 넘어간다.
        Flexible(
          child: Text(
            content,
            style: TextStyle(
              color: BODY_TEXT_COLOR,
              fontSize: 14.0,
            ),
          ),
        ),
      ],
    );
  }
}

class _Images extends StatelessWidget {
  const _Images({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}