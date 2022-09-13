import 'package:flutter/material.dart';

///drag
class DraggleWidget extends StatefulWidget {
  @override
  _DraggleWidgetState createState() => _DraggleWidgetState();
}

class _DraggleWidgetState extends State<DraggleWidget> {
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(60),
        child: const ResizableWidget(
          child: Text(
            'Drag it',
          ),
        ),
      );
}

///resizable widget
class ResizableWidget extends StatefulWidget {
  /// initialized
  const ResizableWidget({required this.child});

  ///child
  final Widget child;

  @override
  _ResizableWidgetState createState() => _ResizableWidgetState();
}

///ball diameter
const double ballDiameter = 30;

class _ResizableWidgetState extends State<ResizableWidget> {
  double height = 400;
  double width = 200;

  double top = 0;
  double left = 0;

  void onDrag(double dx, double dy) {
    final double newHeight = height + dy;
    final double newWidth = width + dx;

    setState(() {
      height = newHeight > 0 ? newHeight : 0;
      width = newWidth > 0 ? newWidth : 0;
    });
  }

  @override
  Widget build(BuildContext context) => Stack(
        children: <Widget>[
          Positioned(
            top: top,
            left: left,
            child: Container(
              height: height,
              width: width,
              color: Colors.red[100],
              child: widget.child,
            ),
          ),
          // top left
          Positioned(
            top: top - ballDiameter / 2,
            left: left - ballDiameter / 2,
            child: ManipulatingBall(
              onDrag: (double dx, double dy) {
                final double mid = (dx + dy) / 2;
                final double newHeight = height - 2 * mid;
                final double newWidth = width - 2 * mid;

                setState(() {
                  height = newHeight > 0 ? newHeight : 0;
                  width = newWidth > 0 ? newWidth : 0;
                  top = top + mid;
                  left = left + mid;
                });
              },
            ),
          ),
          // top middle
          Positioned(
            top: top - ballDiameter / 2,
            left: left + width / 2 - ballDiameter / 2,
            child: ManipulatingBall(
              onDrag: (double dx, double dy) {
                final double newHeight = height - dy;

                setState(() {
                  height = newHeight > 0 ? newHeight : 0;
                  top = top + dy;
                });
              },
            ),
          ),
          // top right
          Positioned(
            top: top - ballDiameter / 2,
            left: left + width - ballDiameter / 2,
            child: ManipulatingBall(
              onDrag: (double dx, double dy) {
                final double mid = (dx + (dy * -1)) / 2;

                final double newHeight = height + 2 * mid;
                final double newWidth = width + 2 * mid;

                setState(() {
                  height = newHeight > 0 ? newHeight : 0;
                  width = newWidth > 0 ? newWidth : 0;
                  top = top - mid;
                  left = left - mid;
                });
              },
            ),
          ),
          // center right
          Positioned(
            top: top + height / 2 - ballDiameter / 2,
            left: left + width - ballDiameter / 2,
            child: ManipulatingBall(
              onDrag: (double dx, double dy) {
                final double newWidth = width + dx;

                setState(() {
                  width = newWidth > 0 ? newWidth : 0;
                });
              },
            ),
          ),
          // bottom right
          Positioned(
            top: top + height - ballDiameter / 2,
            left: left + width - ballDiameter / 2,
            child: ManipulatingBall(
              onDrag: (double dx, double dy) {
                final double mid = (dx + dy) / 2;

                final double newHeight = height + 2 * mid;
                final double newWidth = width + 2 * mid;

                setState(() {
                  height = newHeight > 0 ? newHeight : 0;
                  width = newWidth > 0 ? newWidth : 0;
                  top = top - mid;
                  left = left - mid;
                });
              },
            ),
          ),
          // bottom center
          Positioned(
            top: top + height - ballDiameter / 2,
            left: left + width / 2 - ballDiameter / 2,
            child: ManipulatingBall(
              onDrag: (double dx, double dy) {
                final double newHeight = height + dy;

                setState(() {
                  height = newHeight > 0 ? newHeight : 0;
                });
              },
            ),
          ),
          // bottom left
          Positioned(
            top: top + height - ballDiameter / 2,
            left: left - ballDiameter / 2,
            child: ManipulatingBall(
              onDrag: (double dx, double dy) {
                final double mid = ((dx * -1) + dy) / 2;

                final double newHeight = height + 2 * mid;
                final double newWidth = width + 2 * mid;

                setState(() {
                  height = newHeight > 0 ? newHeight : 0;
                  width = newWidth > 0 ? newWidth : 0;
                  top = top - mid;
                  left = left - mid;
                });
              },
            ),
          ),
          //left center
          Positioned(
            top: top + height / 2 - ballDiameter / 2,
            left: left - ballDiameter / 2,
            child: ManipulatingBall(
              onDrag: (double dx, double dy) {
                final double newWidth = width - dx;

                setState(() {
                  width = newWidth > 0 ? newWidth : 0;
                  left = left + dx;
                });
              },
            ),
          ),
          // center center
          Positioned(
            top: top + height / 2 - ballDiameter / 2,
            left: left + width / 2 - ballDiameter / 2,
            child: ManipulatingBall(
              onDrag: (double dx, double dy) {
                setState(() {
                  top = top + dy;
                  left = left + dx;
                });
              },
            ),
          ),
        ],
      );
}

///ball for drag
class ManipulatingBall extends StatefulWidget {
  ///initialize the app
  const ManipulatingBall({required this.onDrag});

  ///onj drag method
  final Function onDrag;

  @override
  _ManipulatingBallState createState() => _ManipulatingBallState();
}

class _ManipulatingBallState extends State<ManipulatingBall> {
  late double initX;
  late double initY;

  void _handleDrag(DragStartDetails details) {
    setState(() {
      initX = details.globalPosition.dx;
      initY = details.globalPosition.dy;
    });
  }

  void _handleUpdate(DragUpdateDetails details) {
    final double dx = details.globalPosition.dx - initX;
    final double dy = details.globalPosition.dy - initY;
    initX = details.globalPosition.dx;
    initY = details.globalPosition.dy;
    widget.onDrag(dx, dy);
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onPanStart: _handleDrag,
        onPanUpdate: _handleUpdate,
        child: Container(
          width: ballDiameter,
          height: ballDiameter,
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.5),
            shape: BoxShape.circle,
          ),
        ),
      );
}
