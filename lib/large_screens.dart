import 'package:flutter/material.dart';
import 'style.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ResponsiveAppBar(
        backgroundColor: AppTheme.coffe300,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppTheme.logoIcon,
            SearchInput(
              textController: TextEditingController(),
              hintText: "search...",
            ),
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: AppTheme.settingsIcon
                ),
                SizedBox(width: 40,),
                TextButton(
                  style: AppTheme.textButtonStyle,
                  onPressed: () {},
                  child: Text("Sign up", style: AppTheme.normalText,),
                ),
                SizedBox(width: 15,),
                TextButton(
                  style: AppTheme.textButtonStyle,
                  onPressed: () {},
                  child: Text("Sign in", style: AppTheme.normalText,),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Row(
        children: [
          Expanded(
            flex: 27,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 83,
                  child: Container(
                    color: AppTheme.coffe200,
                    child: Column(
                      children: [
                        SizedBox(height: 25,),
                        Text("File Explorer", style: AppTheme.h3,),
                        SizedBox(height: 25,),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: Container(
                    color: AppTheme.coffe300,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(width: 25,),
                        IconButton(
                        onPressed: () {},
                        icon: AppTheme.addIcon,
                        ),
                        IconButton(
                        onPressed: () {},
                        icon: AppTheme.newFolderIcon,
                        ),
                        IconButton(
                        onPressed: () {},
                        icon: AppTheme.deleteIcon,
                        ),
                        SizedBox(width: 25,),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          VerticalDivider(
            width: 2,
            color: AppTheme.buttonActive,
          ),
          Expanded(
            flex: 44,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 83,
                  child: Container(
                    color: AppTheme.coffe200,
                    child: Column(
                      children: [
                        SizedBox(height: 25,),
                        Text("Click to file...", style: AppTheme.h4,),
                        SizedBox(height: 25,),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: Container(
                    color: AppTheme.coffe300,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(width: 15,),
                        IconButton(
                        onPressed: () {},
                        icon: AppTheme.calendarIcon,
                        ),
                        IconButton(
                        onPressed: () {},
                        icon: AppTheme.alarmIcon,
                        ),
                        IconButton(
                        onPressed: () {},
                        icon: AppTheme.addIcon,
                        ),
                        SizedBox(width: 15,),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          VerticalDivider(
            width: 2,
            color: AppTheme.buttonActive,
          ),
          Expanded(
            flex: 27,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 83,
                  child: Container(
                    color: AppTheme.coffe200,
                    child: Column(
                      children: [
                        SizedBox(height: 25,),
                        Text("Tasks & Events", style: AppTheme.h3,),
                        SizedBox(height: 25,),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: Container(
                    color: AppTheme.coffe300,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(width: 25,),
                        IconButton(
                        onPressed: () {},
                        icon: AppTheme.timeIcon,
                        ),
                        IconButton(
                        onPressed: () {},
                        icon: AppTheme.graphIcon,
                        ),
                        SizedBox(width: 25,),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//
// Search Input
//
class SearchInput extends StatelessWidget {
  final TextEditingController textController;
  final String hintText;
  const SearchInput({required this.textController, required this.hintText, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 728,
          height: 40,
            child: TextField(
             controller: textController,
              onChanged: (value) {
                //Do something wi
              },
              decoration: InputDecoration(
                
                filled: true,
                fillColor: AppTheme.buttonActive,
                hintText: hintText,
                hintStyle: AppTheme.hintText,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(255.0)),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: AppTheme.coffe200, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: AppTheme.coffe200, width: 2.0),
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                ),
              ),
            ),
        ),
        IconButton(
          onPressed: () {},
          icon: AppTheme.searchIcon,
        ),
      ],
    );
  }
}

//
// AppBar custom
//
class ResponsiveAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;
  final Color backgroundColor;

  const ResponsiveAppBar({Key? key, required this.title, required this.backgroundColor}) : super(key: key);

  @override
  Size get preferredSize {
    // Вычисляем 5.6% от высоты экрана
    final screenHeight = WidgetsBinding.instance.window.physicalSize.height;
    final appBarHeight = screenHeight * 0.102; // 5.6%
    return Size.fromHeight(appBarHeight);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final appBarHeight = constraints.maxHeight;

        return Container(
          height: appBarHeight,
          color: backgroundColor,
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: title,
        );
      },
    );
  }
}