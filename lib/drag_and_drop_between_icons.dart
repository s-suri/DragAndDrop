import 'package:flutter/material.dart';
import 'package:icons_swap/Icons_model.dart';


class DragAndDropBetweenIcons extends StatefulWidget {
  @override
  _DragAndDropBetweenIconsState createState() => _DragAndDropBetweenIconsState();
}

class _DragAndDropBetweenIconsState extends State<DragAndDropBetweenIcons> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();


  // Icons List with color
  List<IconsModel> icons = [
    IconsModel(iconData: Icons.person,color:  Colors.primaries[0.hashCode % Colors.primaries.length]),
    IconsModel(iconData: Icons.message,color:  Colors.primaries[1.hashCode % Colors.primaries.length]),
    IconsModel(iconData: Icons.call ,color:  Colors.primaries[3.hashCode % Colors.primaries.length]),
    IconsModel(iconData: Icons.camera ,color:  Colors.primaries[4.hashCode % Colors.primaries.length]),
    IconsModel(iconData: Icons.photo ,color:  Colors.primaries[5.hashCode % Colors.primaries.length]),
    IconsModel(iconData: Icons.video_call ,color:  Colors.primaries[6.hashCode % Colors.primaries.length]),
    IconsModel(iconData: Icons.notifications ,color:  Colors.primaries[7.hashCode % Colors.primaries.length]),
    IconsModel(iconData: Icons.email ,color:  Colors.primaries[8.hashCode % Colors.primaries.length]),
    IconsModel(iconData: Icons.settings ,color:  Colors.primaries[9.hashCode % Colors.primaries.length]),
    IconsModel(iconData: Icons.account_circle ,color:  Colors.primaries[10.hashCode % Colors.primaries.length]),
    IconsModel(iconData: Icons.group ,color:  Colors.primaries[11.hashCode % Colors.primaries.length]),
    IconsModel(iconData: Icons.chat ,color:  Colors.primaries[12.hashCode % Colors.primaries.length]),
    IconsModel(iconData: Icons.access_alarm ,color:  Colors.primaries[13.hashCode % Colors.primaries.length]),
    IconsModel(iconData: Icons.accessibility ,color:  Colors.primaries[14.hashCode % Colors.primaries.length]),
    IconsModel(iconData: Icons.add ,color:  Colors.primaries[15.hashCode % Colors.primaries.length]),
    IconsModel(iconData: Icons.add_circle ,color:  Colors.primaries[16.hashCode % Colors.primaries.length]),
  ];

  int? draggingIndex; // Track which item is being dragged
  bool isDragging = false;
  double dragOffsetY = 0; // Track the drag item y axis position;
  double dragOffsetX = 0; // Track the drag item x axis position;
  double currentDragOffsetX = 0;
  int? _hoveredIndex;

  @override
  void initState() {

    // Assign the dragOffsetY to screen height because our screen starts from bottom;
    Future.delayed(Duration(seconds: 1), () {
      dragOffsetY = MediaQuery.of(context).size.height;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 70,
              width: size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.black12,
              ),
              padding: const EdgeInsets.all(4),
              child: Center(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    double iconSize = 50; // Icon size

                    // In animated list we use adding and removing items with animation
                    return AnimatedList(
                        key: _listKey,
                        scrollDirection: Axis.horizontal,
                        initialItemCount: icons.length,
                        itemBuilder: (context, index, animation) {
                          return SizeTransition(
                            sizeFactor: animation,
                            child: DragTarget<int>(  // The drag target item is used to accept objects and provide space to land;
                              onAccept: (draggedIndex) {
                                setState(() {
                                  final draggedItem = icons[draggedIndex];

                                  // Remove drag started item with animation You can manage the animation as you like
                                  icons.removeAt(draggedIndex);
                                  _listKey.currentState?.removeItem(
                                    index, (context, animation) => Container(
                                    height: 0,
                                    width: 0,
                                  ),
                                    duration: Duration(milliseconds: 300),
                                  );
                                  int newIndex = index;

                                  // find the odd even to manage the item show left and right side
                                  if (newIndex % 2 == 0) {
                                    if (draggedIndex < newIndex) {
                                      newIndex = newIndex - 1;
                                    }
                                  } else {
                                    if (draggedIndex < newIndex) {
                                      newIndex = newIndex - 1;
                                    }
                                  }

                                  // Add drag item on selected position with animation You can manage the animation as you like
                                  icons.insert(newIndex, draggedItem);
                                  _listKey.currentState?.insertItem(index);
                                });
                              },
                              builder: (context, candidateData, rejectedData) {
                                int iconIndex = index;

                                return Row(
                                  children: [
                                    AnimatedContainer(
                                      width: candidateData.isNotEmpty ? 40 : 15,
                                      height: iconSize,
                                      duration: Duration(milliseconds: 400),
                                      curve: Curves.easeInOut,
                                      decoration: BoxDecoration(),
                                    ),
                                    Draggable<int>(
                                      data: iconIndex,
                                      onDragStarted: () {
                                        setState(() {
                                          isDragging = true;
                                          draggingIndex = iconIndex; // Start dragging
                                          dragOffsetY = size.height;
                                          dragOffsetX = 0;
                                        });
                                      },
                                      onDragEnd: (details) {
                                        setState(() {
                                          isDragging = false;
                                          draggingIndex = null;
                                          dragOffsetX = 0;
                                          currentDragOffsetX = 0;
                                        });
                                      },
                                      onDragUpdate: (details) {
                                        // Track vertical movement while dragging
                                        setState(() {
                                          dragOffsetY = details.localPosition.dy;

                                          if (dragOffsetX == 0) {
                                            dragOffsetX = details.localPosition.dx;
                                          }

                                          currentDragOffsetX = details.localPosition.dx;

                                          print(
                                              "details.localPosition.dx ${dragOffsetX}");
                                          print(
                                              "details.localPosition.dx ${details.localPosition.dx}");
                                        });
                                      },
                                      feedback: AnimatedOpacity(
                                        duration: Duration(milliseconds: 500),
                                        curve: Curves.easeInOut,
                                        opacity:
                                        draggingIndex == iconIndex ? 1.0 : 1.0,
                                        child: Container(
                                          width: 48,
                                          height: 48,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8),
                                            color: icons[iconIndex].color,
                                          ),
                                          child: Center(
                                              child: Icon(icons[iconIndex].iconData,
                                                  color: Colors.white)),
                                        ),
                                      ),
                                      childWhenDragging: AnimatedOpacity(
                                        duration: Duration(milliseconds: 500),
                                        curve: Curves.easeInOut,
                                        opacity: draggingIndex == iconIndex ? 1.0 : 1.0,
                                        child: Container(
                                          child: SizedBox(
                                            width: (size.height - dragOffsetY >= 80 &&
                                                isDragging) ||
                                                ((dragOffsetX - currentDragOffsetX >=
                                                    30 ||
                                                    dragOffsetX -
                                                        currentDragOffsetX <=
                                                        -30) &&
                                                    isDragging)
                                                ? 0
                                                : iconSize * 0.7,
                                            height: (size.height - dragOffsetY >=
                                                80 &&
                                                isDragging) ||
                                                ((dragOffsetX - currentDragOffsetX >=
                                                    30 ||
                                                    dragOffsetX -
                                                        currentDragOffsetX <=
                                                        -30) &&
                                                    isDragging)
                                                ? 0
                                                : iconSize * 0.7,
                                          ),
                                        ),
                                      ),
                                      child: MouseRegion(
                                        onEnter: (_) {
                                          setState(() {
                                            _hoveredIndex = index;
                                          });
                                        },
                                        onExit: (_) {
                                          setState(() {
                                            _hoveredIndex = null;
                                          });
                                        },
                                        child: AnimatedContainer(
                                          duration: Duration(milliseconds: 1500),
                                          curve: Curves.easeInOut,
                                          child: Container(
                                            height: _hoveredIndex == index && isDragging == false ? 56 : 48,
                                            width: _hoveredIndex == index && isDragging == false ? 56 : 48,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(8),
                                              color: icons[iconIndex].color,
                                            ),
                                            child: Center(
                                                child: Icon(icons[iconIndex].iconData,
                                                    color: Colors.white)),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                );
                              },
                            ),
                          );
                        });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



