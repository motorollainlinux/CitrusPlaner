import 'package:flutter/material.dart';
import 'style.dart';
import 'package:path/path.dart' as p;
import 'dart:io';
import 'file_logic.dart';

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

      //
      // BODY
      //

      body: Row(
        children: [
          FutureBuilder<String>(
          future: getUserSharedDir(), // асинхронный метод
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text("Ошибка: ${snapshot.error}");
              } else if (!snapshot.hasData || snapshot.data == null) {
                return Text("Не удалось получить путь");
              }

              final rootPath = snapshot.data!;

              return FileManager(
                rootPath: rootPath,
              ); 
            }
          ),
          // FileManager(rootPath: path),
          // FileManager(),
          Container(
            width: 6,
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
          Container(
            width: 6,
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

//                                                  FILE MANAGER
//                                                  FILE MANAGER
//                                                  FILE MANAGER
class FileManager extends StatefulWidget {
  final String rootPath;

  const FileManager({Key? key, required this.rootPath}) : super(key: key);
  // const FileManager({
  //   super.key,
  // });

  @override
  State<FileManager> createState() => _FileManagerState();
}

class _FileManagerState extends State<FileManager> {
  late Future<FileNode> _fileTreeFuture;

  FileNode? selectedFolder;
  FileNode? selectedFile;

  bool _isInputActive = false;
  TextEditingController _inputController = TextEditingController();
  String? _currentItemType; // может быть 'file' или 'folder'
  
  @override
  void initState() {
    super.initState();
    _fileTreeFuture = getUserSharedDir().then((basePath) async {
      final root = await getDirectoryTree(basePath);
      final path = await getUserSharedDir();
      setState(() {
        selectedFolder = root;
      });
      return root;
    });
  }

  Future<FileNode> _loadFileTree() async {
    final path = await getUserSharedDir();
    return await getDirectoryTree(path);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
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
                  Text("File manager", style: AppTheme.h3,),
                  SizedBox(height: 25,),
                  FutureBuilder<FileNode>(
                    future: _fileTreeFuture,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return FileTreeWidget(
                          node: snapshot.data!,
                          selectedFolder: selectedFolder!,
                          selectedFile: selectedFile,
                          onFolderSelected: (folder) {
                            setState(() {
                              selectedFolder = folder;
                            });
                          },
                          onFileSelected: (file) {
                            setState(() {
                              selectedFile = file;
                            });
                          },
                        ); 
                      } else if (snapshot.hasError) {
                        return Text("Ошибка: ${snapshot.error}");
                      }
                      return Center(child: CircularProgressIndicator());
                    },
                  ),
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
                  onPressed: selectedFolder != null ? () => _promptInput('file') : null,
                  icon: AppTheme.addIcon,
                  ),
                  IconButton(
                  onPressed: selectedFolder != null ? () => _promptInput('folder') : null,
                  icon: AppTheme.newFolderIcon,
                  ),
                  IconButton(
                  onPressed: (selectedFile != null || (selectedFolder != null && selectedFolder?.fullPath != widget.rootPath))
                      ? _deleteSelectedItem
                      : null,
                  icon: AppTheme.deleteIcon,
                  ),
                  SizedBox(width: 25,),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  //
  void _createFile(String fileName) async {
    if (![".md", ".css"].any(fileName.endsWith)) {
      _showErrorDialog("Разрешены только расширения .md и .css");
      return;
    }

    final path = p.join(selectedFolder!.fullPath, fileName);
    final file = File(path);

    try {
      await file.create();
      _refreshTree();
    } catch (e) {
      _showErrorDialog("Ошибка при создании файла: $e");
    }
  }
  void _createFolder(String folderName) async {
    final path = p.join(selectedFolder!.fullPath, folderName);
    final dir = Directory(path);

    try {
      await dir.create();
      _refreshTree();
    } catch (e) {
      _showErrorDialog("Ошибка при создании папки: $e");
    }
  }
  void _deleteSelectedItem() async {
    if (selectedFile != null) {
      final file = File(selectedFile!.fullPath);
      try {
        await file.delete();
        setState(() {
          selectedFile = null;
        });
        _refreshTree();
      } catch (e) {
        _showErrorDialog("Ошибка при удалении файла: $e");
      }
    } else if (selectedFolder != null && selectedFolder?.fullPath != widget.rootPath) {
      final dir = Directory(selectedFolder!.fullPath);
      try {
        await dir.delete(recursive: true);
        setState(() {
          selectedFolder = _getRootNode();// setState(() {
          //   selectedFolder = null;
          // }); // выбрать корень или другую папку //
        });
        _refreshTree();
      } catch (e) {
        _showErrorDialog("Ошибка при удалении папки: $e");
      }
    }
  }
  void _refreshTree() {
    setState(() {
      _fileTreeFuture = getUserSharedDir().then(getDirectoryTree);
    });
  }

void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Ошибка"),
        content: Text(message),
        actions: [
          TextButton(onPressed: Navigator.of(context).pop, child: Text("OK"))
        ],
      ),
    );
  }
  void _promptInput(String type) {
    _currentItemType = type;
    _isInputActive = true;
    _inputController.clear();

    showGeneralDialog(
      context: context,
      pageBuilder: (_, __, ___) => Container(),
      transitionDuration: Duration.zero,
      barrierDismissible: true,
      barrierLabel: '',
      transitionBuilder: (_, anim1, __, child) {
        return FadeTransition(
          opacity: anim1,
          child: child,
        );
      },
      routeSettings: RouteSettings(name: "InputDialog"),
      useRootNavigator: true,
    ).then((_) {
      _isInputActive = false;
    });

    FocusNode focusNode = FocusNode();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppTheme.coffe200,
        title: Text(type == 'file' ? "Введите имя файла" : "Введите имя папки", style: AppTheme.normalText,),
        content: TextField(
          cursorColor: AppTheme.buttonActive,
          style: AppTheme.normalText,
          controller: _inputController,
          autofocus: true,
          focusNode: focusNode,
          decoration: InputDecoration(hintText: type == 'file' ? "example.md" : "my_folder", hintStyle: AppTheme.hintText),
          onSubmitted: (value) {
            Navigator.of(context).pop();
            if (type == 'file') {
              _createFile(value);
            } else {
              _createFolder(value);
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: Navigator.of(context).pop,
            child: Text("Отмена", style: AppTheme.normalText,),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (type == 'file') {
                _createFile(_inputController.text);
              } else {
                _createFolder(_inputController.text);
              }
            },
            child: Text("Создать", style: AppTheme.normalText,),
          )
        ],
      ),
    );
  }
  FileNode _getRootNode() {
    return FileNode(
      name: "index",
      fullPath: widget.rootPath,
      isDirectory: true,
    );
  }
}

//                                                             SEARCH INPUT
//                                                             SEARCH INPUT
//                                                             SEARCH INPUT
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

//                                                                 APPBAR CUSTOM
//                                                                 APPBAR CUSTOM
//                                                                 APPBAR CUSTOM
class ResponsiveAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;
  final Color backgroundColor;

  const ResponsiveAppBar({Key? key, required this.title, required this.backgroundColor}) : super(key: key);

  @override
  Size get preferredSize {
    final screenHeight = WidgetsBinding.instance.window.physicalSize.height;
    final appBarHeight = screenHeight * 0.102;
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