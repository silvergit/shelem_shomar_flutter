import 'package:flutter/material.dart';

class ScaleAnimWidget extends StatefulWidget {
  final Widget widget;
  final Function onTapWidget;

  const ScaleAnimWidget(this.widget, {this.onTapWidget});

  @override
  _ScaleAnimWidgetState createState() => _ScaleAnimWidgetState();
}

class _ScaleAnimWidgetState extends State<ScaleAnimWidget>
    with SingleTickerProviderStateMixin {
  double _scale;
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 100,
      ),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1.0 - _controller.value;
    return Center(
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        child: Transform.scale(
          scale: _scale,
          child: widget.widget,
        ),
      ),
    );
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
    if (widget.onTapWidget != null) widget.onTapWidget();
  }

  void _onTapCancel() {
    _controller.reverse();
  }
}
