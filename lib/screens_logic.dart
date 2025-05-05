import 'package:flutter/material.dart';
import 'style.dart';
import 'file_logic.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter/services.dart'; // Для LogicalKeyboardKey
import 'dart:io' as io;
// import 'dart:ui';
import 'package:path/path.dart' as p;

class MarkdownEditor extends StatefulWidget {
  final FileNode? selectedFile;
  final Function(String content)? onContentChange;

  const MarkdownEditor({
    Key? key,
    this.selectedFile,
    this.onContentChange,
  }) : super(key: key);

  @override
  State<MarkdownEditor> createState() => _MarkdownEditorState();
}

class _MarkdownEditorState extends State<MarkdownEditor> {
  bool _isEditing = false;
  late TextEditingController _controller;
  String _markdownData = '';
  String _cssStyle = AppTheme.defaultMarkdownStyles;
  FocusNode _textFieldFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _textFieldFocusNode = FocusNode();
    _textFieldFocusNode.addListener(() {
    if (!_textFieldFocusNode.hasFocus && _isEditing) {
      setState(() {
        _isEditing = false;
        _markdownData = _controller.text;
      });}});
    _loadInitialContent();
  }

  @override
  void didUpdateWidget(covariant MarkdownEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedFile != oldWidget.selectedFile) {
      _loadInitialContent();
    }
  }

  //
  MarkdownStyleSheet _buildMarkdownStyleSheet() {
  return MarkdownStyleSheet(
    h1: AppTheme.h1,
    h2: AppTheme.h2,
    h3: AppTheme.h3,
    p: AppTheme.normalText,
    // em: AppTheme.emText,
    strong: AppTheme.strongText,
    // blockquote: AppTheme.blockquoteStyle,
    code: AppTheme.normalText,
    a: AppTheme.normalText,
    listBullet: AppTheme.normalText,
    horizontalRuleDecoration: BoxDecoration(
      border: Border(
        top: BorderSide(color: AppTheme.buttonActive, width: 1),
      ),
    ),
    // Добавьте другие стили по необходимости
  );
}
  //

  Future<void> _loadInitialContent() async {
    if (widget.selectedFile == null) {
      setState(() {
        _markdownData = '';
        _isEditing = false;
      });
      return;
    }

    try {
      final file = io.File(widget.selectedFile!.fullPath);
      final content = await file.readAsString();
      setState(() {
        _markdownData = content;
        _controller.text = content;
      });

      // Загрузить стиль .css если он существует
      if (p.extension(widget.selectedFile!.fullPath).toLowerCase() == '.md') {
        final cssPath = p.join(p.dirname(file.path), '${p.basenameWithoutExtension(file.path)}.css');
        final cssFile = io.File(cssPath);
        if (await cssFile.exists()) {
          final style = await cssFile.readAsString();
          setState(() {
            _cssStyle = style;
          });
        } else {
          setState(() {
            _cssStyle = AppTheme.defaultMarkdownStyles;
          });
        }
      }
    } catch (e) {
      _showErrorDialog("Ошибка чтения файла: $e");
    }
  }

  void _saveToFile() async {
    if (widget.selectedFile == null) return;

    try {
      final file = io.File(widget.selectedFile!.fullPath);
      await file.writeAsString(_controller.text);
      widget.onContentChange?.call(_controller.text);
      _showSuccessDialog("Файл сохранён");
    } catch (e) {
      _showErrorDialog("Ошибка при сохранении: $e");
    }
  }

  void _toggleEditMode() {
    setState(() {
      if (_isEditing) {
        _markdownData = _controller.text;
      }
      _isEditing = !_isEditing;
    });
  }


  void _handleKey(KeyEvent event) {
  if (event is KeyDownEvent) {
    final key = event.logicalKey;

    final bool isControlPressed = HardwareKeyboard.instance.isControlPressed; //event.isControlPressed
    // final bool isMetaPressed = event.isMetaPressed;

    if (key == LogicalKeyboardKey.keyS && isControlPressed ) {
      _saveToFile();
    }
  }
}

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppTheme.coffe200,
        title: Text("Ошибка", style: AppTheme.normalText),
        content: Text(message, style: AppTheme.normalText),
        actions: [
          TextButton(onPressed: Navigator.of(context).pop, child: Text("OK", style: AppTheme.normalText)),
        ],
      ),
    );
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppTheme.coffe200,
        title: Text("Сохранено", style: AppTheme.normalText),
        content: Text(message, style: AppTheme.normalText),
        actions: [
          TextButton(onPressed: Navigator.of(context).pop, child: Text("OK", style: AppTheme.normalText)),
        ],
      ),
    );
  }
  @override
  void dispose() {
    _textFieldFocusNode.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Focus(
      autofocus: true,
      onKeyEvent: (node, event) {
        _handleKey(event);
        return KeyEventResult.ignored;
      },
      child: Expanded(
        flex: 44,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 83,
              child: GestureDetector(
                onTap: () {
                  if (!_isEditing) {
                    setState(() {
                      _isEditing = true;
                    });
                  }
                },
                child: Container(
                  color: AppTheme.coffe200,
                  padding: const EdgeInsets.all(16),
                  child: widget.selectedFile == null
                      ? Center(child: Text("Click to file...", style: AppTheme.h4))
                      : (_isEditing
                          ? TextField(
                              controller: _controller,
                              focusNode: _textFieldFocusNode,
                              maxLines: null,
                              expands: true,
                              keyboardType: TextInputType.multiline,
                              // decoration: InputDecoration.collapsed(hintText: "Редактируйте здесь..."),
                              style: AppTheme.normalText,
                            )
                          : Column(
                            children: [
                              Text(
                                widget.selectedFile!.name,
                                style: AppTheme.h1,
                              ),
                              SizedBox(height: 16),
                              Expanded(
                                child: Markdown(
                                    data: _markdownData,
                                    styleSheet: _buildMarkdownStyleSheet(),
                                    // styleSheet: MarkdownStyleSheet.fromCssString(_cssStyle),
                                  ),
                              ),
                            ],
                          )),
                ),
              ),
            ),
            // Expanded(
            //   flex: 7,
            //   child: Container(
            //     color: AppTheme.coffe300,
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: [
            //         SizedBox(width: 15,),
            //         IconButton(
            //           onPressed: () {},
            //           icon: AppTheme.calendarIcon,
            //         ),
            //         IconButton(
            //           onPressed: () {},
            //           icon: AppTheme.alarmIcon,
            //         ),
            //         IconButton(
            //           onPressed: () {
            //             if (_isEditing) {
            //               _saveToFile();
            //             }
            //             _toggleEditMode();
            //           },
            //           icon: Icon(
            //             _isEditing ? Icons.save_rounded : Icons.edit_rounded,
            //             color: AppTheme.buttonActive,
            //           ),
            //         ),
            //         SizedBox(width: 15,),
            //       ],
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}