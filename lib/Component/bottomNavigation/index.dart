import 'package:flutter/material.dart';
import 'package:face_recog_flutter/main.dart';

class BottomNavigationMenu extends StatefulWidget {
  final width;
  final height;
  final bool isDark;
  final bool isBahasaIndo;
  final String activeItem;
  final keyBottomNavigation;

  const BottomNavigationMenu({
    required this.width,
    required this.height,
    this.isDark = false,
    this.isBahasaIndo = true,
    this.keyBottomNavigation,
    required this.activeItem,
    Key? key,
  }) : super(key: key);

  @override
  State<BottomNavigationMenu> createState() => BottomNavigationMenuState();
}

class BottomNavigationMenuState extends State<BottomNavigationMenu> {
  List bottomNavigationItem = [
    {
      "id": "home",
      "iconDefault": Icons.house_outlined,
      "iconActive": Icons.house,
      "labelID": LabelsID.labelBeranda,
      "labelEN": LabelsEN.labelBeranda,
      "onNavigate": "/Home",
    },
    {
      "id": "search",
      "iconDefault": Icons.search_outlined,
      "iconActive": Icons.search,
      "labelID": LabelsID.labelPencarian,
      "labelEN": LabelsEN.labelPencarian,
      "onNavigate": "/Search",
    },
    {
      "id": "stats",
      "iconDefault": Icons.post_add,
      "iconActive": Icons.post_add_outlined,
      "labelID": LabelsID.labelStatistik,
      "labelEN": LabelsEN.labelStatistik,
      "onNavigate": "/Stats",
    },
    {
      "id": "profile",
      "iconDefault": Icons.person_outline_rounded,
      "iconActive": Icons.person,
      "labelID": LabelsID.labelProfil,
      "labelEN": LabelsEN.labelProfil,
      "onNavigate": "/Profile",
    },
  ];

  void onNavigate(pages, parsingData) {
    Navigator.pushReplacementNamed(context, pages, arguments: parsingData);
  }

  Widget bottomNavigation(width_, height_) {
    return ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: bottomNavigationItem.length,
        itemBuilder: (context, index) {
          var menuBottom = bottomNavigationItem[index];
          var isActive = widget.activeItem == menuBottom["id"];
          return Container(
            width: width_ / bottomNavigationItem.length,
            height: height_,
            alignment: Alignment.center,
            child: ButtonPinch(
              onPressed: () {
                if (widget.activeItem != menuBottom["id"]) {
                  onNavigate(menuBottom["onNavigate"], "");
                }
              },
              scale: 0.95,
              boxColor: transparent,
              isShadow: false,
              isBorder: false,
              enable: true,
              paddingChild: const EdgeInsets.all(0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isActive
                        ? menuBottom["iconActive"]
                        : menuBottom["iconDefault"],
                    size: height_ / 3.5,
                    color: isActive ? basic : gray,
                  ),
                  Text(
                    widget.isBahasaIndo
                        ? menuBottom["labelID"]
                        : menuBottom["labelEN"],
                    style: Helpers.font2(
                        12.0, widget.isDark ? white : black, FontWeight.w400),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    var bottomNavigationColor = widget.isDark ? black2 : white;
    return Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Container(
          key: widget.keyBottomNavigation,
          width: widget.width,
          height: (widget.width * 0.15) + (defaultPadding * 2),
          padding: const EdgeInsets.all(defaultPadding),
          decoration: BoxDecoration(
            color: bottomNavigationColor,
            boxShadow: [
              BoxShadow(
                color: widget.isDark
                    ? white.withOpacity(0.3)
                    : black.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: bottomNavigation(widget.width - defaultPadding * 2,
              (widget.width * 0.15) + defaultPadding * 2),
        ));
  }
}
