import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutter_svg/svg.dart';

import '../../../services/controllers/question_controller.dart';
import '../../constants.dart';

class ScoreScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    QuestionController _qnController = Get.put(QuestionController());
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          SvgPicture.asset("assets/icons/bg.svg", fit: BoxFit.fill),
          Column(
            children: [
              Spacer(flex: 3),
              Text(
                "Score",
                style: Theme.of(context)
                    .textTheme
                    .headline3!
                    .copyWith(color: kSecondaryColor),
              ),
              Spacer(),
              Text(
                "${(_qnController.correctAns * 1) * 100 / 4}%",
                // "${_qnController.correctAns * 1}/${_qnController.questions.length * 1}",
                style: Theme.of(context)
                    .textTheme
                    .headline4!
                    .copyWith(color: kSecondaryColor),
              ),
              Spacer(flex: 3),
            ],
          )
        ],
      ),
    );
  }
}