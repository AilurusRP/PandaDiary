import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:panda_diary/db/data_binders/note_content_text.dart';

class NoteContentEditPage extends StatefulWidget {
  const NoteContentEditPage(
      {Key? key,
      required this.id,
      required this.title,
      required this.onContentChange})
      : super(key: key);

  final String id;
  final String title;
  final void Function(String) onContentChange;

  static navigatorPush(context,
      {required String id,
      required String title,
      required void Function(String) onContentChange}) {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => NoteContentEditPage(
            id: id, title: title, onContentChange: onContentChange)));
  }

  @override
  State<NoteContentEditPage> createState() => _NoteContentEditPageState();
}

class _NoteContentEditPageState extends State<NoteContentEditPage> {
  final _controller = TextEditingController();
  var _scrollController = ScrollController();
  late final NoteContentText _noteContentText;
  bool _keyboardShow = false;

  @override
  void initState() {
    _noteContentText = NoteContentText(setState,
        controller: _controller,
        scrollController: _scrollController,
        id: widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _afterBuild();

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          title: Text(widget.title),
        ),
        body: Container(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            child: TextField(
              key: _keyboardShow ? const Key("1") : const Key("0"),
              controller: _controller,
              scrollController: _scrollController,
              expands: true,
              maxLines: null,
              minLines: null,
              autofocus: true,
              keyboardType:
                  _keyboardShow ? TextInputType.multiline : TextInputType.none,
              onTap: _keyboardShow ? () {} : _showKeyboard,
              decoration: const InputDecoration(border: InputBorder.none),
              onChanged: (text) {
                 _noteContentText.save(text, widget.onContentChange);
              },
            )));
  }

  Future<void> _afterBuild() async {
    if (_noteContentText.init == null) return;
    await Future.delayed(Duration.zero);
    _noteContentText.init!();
  }

  _showKeyboard() => setState(() {
        _keyboardShow = true;
        _scrollController = ScrollController();
        _noteContentText.setNewScrollController(_scrollController);
      });
}
