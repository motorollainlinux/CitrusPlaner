import 'dart:io';
import 'package:path/path.dart' as p;
import 'screens_logic.dart';
import 'style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class FileNode {
  final String name;
  final String fullPath;
  final bool isDirectory;
  final List<FileNode> children;

  FileNode({
    required this.name,
    required this.fullPath,
    required this.isDirectory,
    this.children = const [],
  });
}

Future<FileNode> getDirectoryTree(String path) async {
  final dir = Directory(path);
  if (!await dir.exists()) {
    return FileNode(name: '', fullPath: '', isDirectory: false);
  }

  final nodes = <FileNode>[];
  await for (var entity in dir.list().handleError((_) {})) {
    if (entity is File) {
      nodes.add(FileNode(
        name: p.basename(entity.path),
        fullPath: entity.path,
        isDirectory: false,
      ));
    } else if (entity is Directory) {
      final child = await getDirectoryTree(entity.path);
      nodes.add(FileNode(
        name: p.basename(entity.path),
        fullPath: entity.path,
        isDirectory: true,
        children: child.children,
      ));
    }
    nodes.sort((a, b) => a.isDirectory == b.isDirectory ? 0 : a.isDirectory ? -1 : 1);
  }

  return FileNode(
    name: p.basename(path),
    fullPath: path,
    isDirectory: true,
    children: nodes,
  );
}

Future<String> getUserSharedDir() async {
  final homeDir = Platform.environment['HOME'];
  if (homeDir == null || homeDir.isEmpty) {
    throw Exception('Не удалось найти домашнюю директорию');
  }

  final sharedPath = p.join(homeDir, '.local', 'share', 'citrus_planer', 'index');

  final dir = Directory(sharedPath);
  if (!await dir.exists()) {
    await dir.create(recursive: true);
  }

  return sharedPath;
}

// Triangle
class TriangleIcon extends StatelessWidget {
  final bool expanded;

  const TriangleIcon({Key? key, this.expanded = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: TrianglePainter(isDown: expanded),
      size: Size(12, 12),
    );
  }
}

class TrianglePainter extends CustomPainter {
  final bool isDown;

  TrianglePainter({required this.isDown});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.interactObj
      ..style = PaintingStyle.fill;

    final path = Path();
    if (isDown) {
      path.moveTo(0, 0);
      path.lineTo(size.width / 2, size.height);
      path.lineTo(size.width, 0);
    } else {
      path.moveTo(0, 0);
      path.lineTo(size.width, size.height / 2);
      path.lineTo(0, size.height);
    }
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(TrianglePainter oldDelegate) => oldDelegate.isDown != isDown;
}

//
class FileTreeWidget extends StatefulWidget {
  final FileNode node;
  final FileNode selectedFolder;
  final FileNode? selectedFile;
  final ValueChanged<FileNode?> onFolderSelected;
  final ValueChanged<FileNode?> onFileSelected;
  
  const FileTreeWidget({
    Key? key,
    required this.node,
    required this.selectedFolder,
    required this.selectedFile,
    required this.onFolderSelected,
    required this.onFileSelected,
  }) : super(key: key);
  //TODO: понять что это такое
  @override
  _FileTreeWidgetState createState() => _FileTreeWidgetState();
}

class _FileTreeWidgetState extends State<FileTreeWidget> {
  late Map<String, bool> _expandedStates;

  @override
  void initState() {
    super.initState();
    _expandedStates = {};
    _precacheExpandedStates(widget.node);
  }

  void _precacheExpandedStates(FileNode node) {
    if (node.isDirectory) {
      _expandedStates[node.fullPath] = false;
      for (var child in node.children) {
        _precacheExpandedStates(child);
      }
    }
  }

  Widget _buildNode(FileNode node, {String? parentPath}) {
    final isFolder = node.isDirectory;
    final isSelectedFolder = isFolder && node.fullPath == widget.selectedFolder?.fullPath;
    final isSelectedFile = !isFolder && node.fullPath == widget.selectedFile?.fullPath;

    final selectedStyle = isSelectedFolder || isSelectedFile ? AppTheme.selectedItems : null;

    final bool isExpanded = _expandedStates[node.fullPath] ?? false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            if (isFolder) {
              widget.onFolderSelected(node);
              widget.onFileSelected(null);
            } else {
              widget.onFileSelected(node);
              final folder = _findParentFolder(node, widget.node);
              if (folder != null) {
                widget.onFolderSelected(folder);
              }
            }
          },
          child: Row(
                children: [
                  if (isFolder)
                    InkWell(
                      onTap: () {
                        setState(() {
                          // _expandedStates[node.fullPath] = !_expandedStates[node.fullPath]!;
                           _expandedStates[node.fullPath] = !(_expandedStates[node.fullPath] ?? false);
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TriangleIcon(expanded: isExpanded),
                      ),
                    )
                  else
                    SizedBox(width: 20),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        if (isFolder) {
                          widget.onFolderSelected(node);
                          widget.onFileSelected(null);
                        } else {
                          widget.onFileSelected(node);
                          final folder = _findParentFolder(node, widget.node);
                          if (folder != null) {
                            widget.onFolderSelected(folder);
                          }
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          color: selectedStyle?.backgroundColor ?? Colors.transparent,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          node.name,
                          style: selectedStyle?.textStyle ?? AppTheme.normalText,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          if (isFolder && isExpanded)
          Padding(
            padding: const EdgeInsets.only(left: 20),
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: node.children.map((child) => _buildNode(child, parentPath: node.fullPath)).toList(),
            ),
          ),
        ],
      );
  }

  FileNode? _findParentFolder(FileNode fileNode, FileNode currentNode) {
    if (currentNode.isDirectory) {
      for (var child in currentNode.children) {
        if (child == fileNode) return currentNode;
        final result = _findParentFolder(fileNode, child);
        if (result != null) return result;
      }
    }
    return null;
  }

  /*
  Widget _buildFileContentArea() {
    bool _isEditing = false;
    if (widget.selectedFile == null) {
      return Center(child: Text("Выберите файл", style: AppTheme.h4));
    }

    final file = File(widget.selectedFile!.fullPath);

    if (!file.existsSync()) {
      return Text("Файл не найден", style: AppTheme.normalText);
    }

    final content = file.readAsStringSync();

    // Если это .md — показываем Markdown
    if (widget.selectedFile!.fullPath.endsWith('.md')) {
      return MarkdownViewerWithTags(
        filePath: widget.selectedFile!.fullPath,
        content: content,
        markdownStyle: AppTheme.defaultMarkdownStyles,
        onEditRequested: () {
          setState(() {
            _isEditing = true;
          });
        },
      );
    }

    // Иначе — просто текст
    return TextViewerWithEdit(
      content: content,
      isEditing: _isEditing,
      onContentChanged: (newContent) {
        file.writeAsStringSync(newContent);
      },
      onFinishEditing: () {
        setState(() {
          _isEditing = false;
        });
      },
    );
  }
*/
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: _buildNode(widget.node),
    );
  }
}
/*
class MarkdownViewerWithTags extends StatelessWidget {
  final String filePath;
  final String content;
  final VoidCallback onEditRequested;

  const MarkdownViewerWithTags({
    Key? key,
    required this.filePath,
    required this.content,
    required this.onEditRequested,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lines = content.split('\n');
    final tags = <String>[];
    String parsedContent = content;

    // Извлекаем теги, если они есть (например: #tags: work, personal)
    if (lines.isNotEmpty && lines[0].startsWith('#tags:')) {
      final tagLine = lines[0].replaceFirst('#tags:', '').trim();
      tags.addAll(tagLine.split(',').map((t) => t.trim()).where((t) => t.isNotEmpty));
      parsedContent = lines.sublist(1).join('\n');
    }

    return GestureDetector(
      onTap: onEditRequested,
      child: ListView(
        padding: EdgeInsets.all(16),
        children: [
          // Блок с тегами
          if (tags.isNotEmpty)
            Wrap(
              spacing: 8,
              children: tags.map((tag) =>
                  Chip(label: Text("#$tag", style: TextStyle(fontSize: 14)))
              ).toList(),
            ),

          SizedBox(height: 16),

          // Отображение Markdown
          Markdown(
            data: parsedContent,
            styleSheet: MarkdownStyleSheet(
              p: AppTheme.defaultMarkdownStyles,
              h1: AppTheme.defaultMarkdownStyles.copyWith(fontSize: FontSize.large),
              h2: AppTheme.defaultMarkdownStyles.copyWith(fontSize: FontSize.mediumLarge),
              a: AppTheme.defaultMarkdownStyles.copyWith(color: Colors.blue),
              listBullet: AppTheme.defaultMarkdownStyles,
              code: TextStyle.backgroundColor = Colors.grey.shade300,
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }
}

class TextViewerWithEdit extends StatefulWidget {
  final String content;
  final bool isEditing;
  final Function(String) onContentChanged;
  final VoidCallback onFinishEditing;

  const TextViewerWithEdit({
    Key? key,
    required this.content,
    required this.isEditing,
    required this.onContentChanged,
    required this.onFinishEditing,
  }) : super(key: key);

  @override
  _TextViewerWithEditState createState() => _TextViewerWithEditState();
}

class _TextViewerWithEditState extends State<TextViewerWithEdit> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.content);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isEditing) {
      return TextField(
        controller: _controller,
        expands: true,
        maxLines: null,
        onChanged: widget.onContentChanged,
        decoration: InputDecoration.collapsed(hintText: "Редактировать..."),
      );
    }

    return GestureDetector(
      onTap: widget.onFinishEditing,
      child: SingleChildScrollView(
        child: Text(widget.content),
      ),
    );
  }
}*/