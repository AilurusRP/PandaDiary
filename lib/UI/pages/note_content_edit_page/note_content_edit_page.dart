import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:panda_diary/UI/widgets/marquee_text.dart';
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

  bool get _undoDisabled => _noteContentText.undoDisabled;

  bool get _redoDisabled => _noteContentText.redoDisabled;

  @override
  void initState() {
    NoteContentText.create(setState,
            controller: _controller,
            scrollController: _scrollController,
            id: widget.id)
        .then((value) {
      _noteContentText = value;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _afterBuild();

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          title: SizedBox(
              height: 30,
              child: MarqueeText(
                text: widget.title,
                fontSize: 18,
                blankSpace: 15,
                maxWidth: 180,
              )),
          actions: [
            IconButton(
                onPressed: () {
                  if (!_undoDisabled) {
                    _noteContentText.undo();
                    widget.onContentChange(_noteContentText.toString());
                    setState(() {});
                  }
                },
                icon: Icon(Icons.undo,
                    color: _undoDisabled ? Colors.grey : Colors.white)),
            IconButton(
                onPressed: () {
                  if (!_redoDisabled) {
                    _noteContentText.redo();
                    widget.onContentChange(_noteContentText.toString());
                    setState(() {});
                  }
                },
                icon: Icon(Icons.redo,
                    color: _redoDisabled ? Colors.grey : Colors.white))
          ],
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
                widget.onContentChange(text);
                _noteContentText.save(text);
                setState(() {});
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
