import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:panda_diary/UI/pages/data_binders/note_content_text.dart';

class NoteContentEditPage extends StatefulWidget {
  const NoteContentEditPage({Key? key, required this.id}) : super(key: key);

  final String id;

  static navigatorPush(context, {required String id}) {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => NoteContentEditPage(id: id)));
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
        appBar: AppBar(),
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
              onChanged: _noteContentText.save,
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
