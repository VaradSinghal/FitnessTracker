import 'package:flutter/material.dart';

class StepCounter extends StatefulWidget {
  final int steps;
  final int goal;

  StepCounter({required this.steps, required this.goal});

  @override
  _StepCounterState createState() => _StepCounterState();
}

class _StepCounterState extends State<StepCounter> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 1000));
    _animation = Tween<double>(begin: 0, end: widget.steps / widget.goal).animate(_controller)
      ..addListener(() => setState(() {}));
    _controller.forward();
  }

  @override
  void didUpdateWidget(StepCounter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.steps != widget.steps) {
      _animation = Tween<double>(begin: _animation.value, end: widget.steps / widget.goal).animate(_controller);
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 150,
              height: 150,
              child: CircularProgressIndicator(
                value: _animation.value > 1 ? 1 : _animation.value,
                strokeWidth: 12,
                color: Colors.green,
                backgroundColor: Colors.grey[300],
              ),
            ),
            Text('${widget.steps} / ${widget.goal}', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
        SizedBox(height: 10),
        Text('Steps', style: TextStyle(fontSize: 18, color: Colors.grey[700])),
      ],
    );
  }
}