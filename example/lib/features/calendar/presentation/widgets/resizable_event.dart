import 'package:flutter/material.dart';

///resizable event
class ResizableEvent extends StatefulWidget {
  @override
  _ResizableEventState createState() => _ResizableEventState();
}

class _ResizableEventState extends State<ResizableEvent> {
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
  const ResizableWidget(
      {required this.child, this.bottom, this.top, this.height, this.width});

  final double? height, width, top, bottom;

  ///child
  final Widget child;

  @override
  _ResizableWidgetState createState() => _ResizableWidgetState();
}

///ball diameter
const double ballDiameter = 12;

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
  void initState() {
    height = widget.height ?? height;
    width = widget.width ?? width;
    top = widget.top ?? top;

    super.initState();
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

          //left center
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
          width: 500,
          height: 4,
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.5),
          ),
        ),
      );
}

// class TryDemo extends StatelessWidget {
//   const TryDemo({Key? key}) : super(key: key);
//   final double maxTop, maxBottom, top, height;


//   @override
//   Widget build(BuildContext context) {}
// }
