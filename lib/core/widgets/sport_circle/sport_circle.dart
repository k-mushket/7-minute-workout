import 'package:flutter/material.dart';
import 'package:seven_minute_workout/core/widgets/seven_minute_workout/seven_minute_workout.dart';
import 'package:seven_minute_workout/core/widgets/sport_circle/circle_gradient.dart';

class SportCircle extends StatefulWidget {
  final int totalPulsations;

  const SportCircle({super.key, this.totalPulsations = 3});

  @override
  _SportCircleState createState() => _SportCircleState();
}

class _SportCircleState extends State<SportCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int _pulsationCount = 0;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _animation = Tween<double>(begin: 1, end: 1.3).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _pulsationCount++;
          if (_pulsationCount >= widget.totalPulsations) {
            _controller.stop();
          } else {
            _controller.forward();
          }
        }
      });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        buildAnimatedCircle(const CircleGradient(
            radius: 180, gradient: true, color: Color(0xFF87BEFA))),
        buildAnimatedCircle(const CircleGradient(
            radius: 130, gradient: true, color: Color(0xFF87BEFA))),
        buildAnimatedCircle(const CircleGradient(
            radius: 80, gradient: false, color: Color(0xFF87BEFA))),
        const SevenMinuteWorkout(size: 35),
      ],
    );
  }

  Widget buildAnimatedCircle(Widget child) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: _animation.value,
          child: child,
        );
      },
      child: child,
    );
  }
}
