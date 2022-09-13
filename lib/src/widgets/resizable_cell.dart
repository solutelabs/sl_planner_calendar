// import 'package:flutter/material.dart';

// class ResizableCell extends StatefulWidget {
//   @override
//   _ResizableCellState createState() => _ResizableCellState();
// }

// class _ResizableCellState extends State<ResizableCell> {
//   @override
//   Widget build(BuildContext context) => Container(
//       padding: EdgeInsets.all(60),
//       child: ResizableWidget(
//         child: Text(
// '''I've just did simple prototype to show main idea.
//   1. Draw size handlers with container;
//   2. Use GestureDetector to get new variables of sizes
//   3. Refresh the main container size.''',
//         ),
//       ),
//     );
// }

// class ResizableWidget extends StatefulWidget {
//   const ResizableWidget({required this.child});

//   final Widget child;
//   @override
//   _ResizableWidgetState createState() => _ResizableWidgetState();
// }

// const double ballDiameter = 30.0;

// class _ResizableWidgetState extends State<ResizableWidget> {
//   double height = 400;
//   double width = 200;

//   double top = 0;
//   double left = 0;

//   void onDrag(double dx, double dy) {
//     final double newHeight = height + dy;
//     final double newWidth = width + dx;

//     setState(() {
//       height = newHeight > 0 ? newHeight : 0;
//       width = newWidth > 0 ? newWidth : 0;
//     });
//   }

//   @override
//   Widget build(BuildContext context) => Stack(
//       children: <Widget>[
//         Positioned(
//           top: top,
//           left: left,
//           child: Container(
//             height: height,
//             width: width,
//             color: Colors.red[100],
//             child: widget.child,
//           ),
//         ),
//         // top left
//         Positioned(
//           top: top - ballDiameter / 2,
//           left: left - ballDiameter / 2,
//           child: ManipulatingBall(
//             onDrag: (dx, dy) {
//               final mid = (dx + dy) / 2;
//               final double newHeight = height - 2 * mid;
//               final double newWidth = width - 2 * mid;

//               setState(() {
//                 height = newHeight > 0 ? newHeight : 0;
//                 width = newWidth > 0 ? newWidth : 0;
//                 top = top + mid;
//                 left = left + mid;
//               });
//             },
//           ),
//         ),
//         // top middle
//         Positioned(
//           top: top - ballDiameter / 2,
//           left: left + width / 2 - ballDiameter / 2,
//           child: ManipulatingBall(
//             onDrag: (dx, dy) {
//               final double newHeight = height - dy;

//               setState(() {
//                 height = newHeight > 0 ? newHeight : 0;
//                 top = top + dy;
//               });
//             },
//           ),
//         ),
//         // top right
//         Positioned(
//           top: top - ballDiameter / 2,
//           left: left + width - ballDiameter / 2,
//           child: ManipulatingBall(
//             onDrag: (dx, dy) {
//               final mid = (dx + (dy * -1)) / 2;

//               final double newHeight = height + 2 * mid;
//               final double newWidth = width + 2 * mid;

//               setState(() {
//                 height = newHeight > 0 ? newHeight : 0;
//                 width = newWidth > 0 ? newWidth : 0;
//                 top = top - mid;
//                 left = left - mid;
//               });
//             },
//           ),
//         ),
//         // center right
//         Positioned(
//           top: top + height / 2 - ballDiameter / 2,
//           left: left + width - ballDiameter / 2,
//           child: ManipulatingBall(
//             onDrag: (dx, dy) {
//               final double newWidth = width + dx;

//               setState(() {
//                 width = newWidth > 0 ? newWidth : 0;
//               });
//             },
//           ),
//         ),
//         // bottom right
//         Positioned(
//           top: top + height - ballDiameter / 2,
//           left: left + width - ballDiameter / 2,
//           child: ManipulatingBall(
//             onDrag: (dx, dy) {
//               final mid = (dx + dy) / 2;

//               final double newHeight = height + 2 * mid;
//               final double newWidth = width + 2 * mid;

//               setState(() {
//                 height = newHeight > 0 ? newHeight : 0;
//                 width = newWidth > 0 ? newWidth : 0;
//                 top = top - mid;
//                 left = left - mid;
//               });
//             },
//           ),
//         ),
//         // bottom center
//         Positioned(
//           top: top + height - ballDiameter / 2,
//           left: left + width / 2 - ballDiameter / 2,
//           child: ManipulatingBall(
//             onDrag: (dx, dy) {
//               final double newHeight = height + dy;

//               setState(() {
//                 height = newHeight > 0 ? newHeight : 0;
//               });
//             },
//           ),
//         ),
//         // bottom left
//         Positioned(
//           top: top + height - ballDiameter / 2,
//           left: left - ballDiameter / 2,
//           child: ManipulatingBall(
//             onDrag: (dx, dy) {
//               final mid = ((dx * -1) + dy) / 2;

//               final double newHeight = height + 2 * mid;
//               final double newWidth = width + 2 * mid;

//               setState(() {
//                 height = newHeight > 0 ? newHeight : 0;
//                 width = newWidth > 0 ? newWidth : 0;
//                 top = top - mid;
//                 left = left - mid;
//               });
//             },
//           ),
//         ),
//         //left center
//         Positioned(
//           top: top + height / 2 - ballDiameter / 2,
//           left: left - ballDiameter / 2,
//           child: ManipulatingBall(
//             onDrag: (dx, dy) {
//               final double newWidth = width - dx;

//               setState(() {
//                 width = newWidth > 0 ? newWidth : 0;
//                 left = left + dx;
//               });
//             },
//           ),
//         ),
//         // center center
//         Positioned(
//           top: top + height / 2 - ballDiameter / 2,
//           left: left + width / 2 - ballDiameter / 2,
//           child: ManipulatingBall(
//             onDrag: (dx, dy) {
//               setState(() {
//                 top = top + dy;
//                 left = left + dx;
//               });
//             },
//           ),
//         ),
//       ],
//     );
// }

// class ManipulatingBall extends StatefulWidget {
//   const ManipulatingBall({Key key, this.onDrag});

//   final Function onDrag;

//   @override
//   _ManipulatingBallState createState() => _ManipulatingBallState();
// }

// class _ManipulatingBallState extends State<ManipulatingBall> {
//   double initX;
//   double initY;

//   _handleDrag(details) {
//     setState(() {
//       initX = details.globalPosition.dx;
//       initY = details.globalPosition.dy;
//     });
//   }

//   _handleUpdate(details) {
//     final dx = details.globalPosition.dx - initX;
//     final dy = details.globalPosition.dy - initY;
//     initX = details.globalPosition.dx;
//     initY = details.globalPosition.dy;
//     widget.onDrag(dx, dy);
//   }

//   @override
//   Widget build(BuildContext context) => GestureDetector(
//       onPanStart: _handleDrag,
//       onPanUpdate: _handleUpdate,
//       child: Container(
//         width: ballDiameter,
//         height: ballDiameter,
//         decoration: BoxDecoration(
//           color: Colors.blue.withOpacity(0.5),
//           shape: BoxShape.circle,
//         ),
//       ),
//     );
// }
