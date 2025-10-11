import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:panda_diary/UI/widgets/marquee_text.dart';
import 'package:panda_diary/states/note_content_controller.dart';

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
  bool _keyboardShow = false;

  @override
  void initState() {
    var noteContentController = Get.put(NoteContentController());
    noteContentController.init(widget.id).then((_) {
      _controller.text = noteContentController.currentContent;
    });
    super.initState();
  }

  @override
  void dispose() {
    Get.find<NoteContentController>().clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            Obx(() {
              var noteContentController = Get.find<NoteContentController>();
              return IconButton(
                  onPressed: () {
                    if (!noteContentController.undoDisabled) {
                      noteContentController.undo();
                      _controller.text = noteContentController.currentContent;
                      widget.onContentChange(
                          noteContentController.currentContent);
                      setState(() {});
                    }
                  },
                  icon: Icon(Icons.undo,
                      color: noteContentController.undoDisabled
                          ? Colors.grey
                          : Colors.white));
            }),
            Obx(() {
              var noteContentController = Get.find<NoteContentController>();
              return IconButton(
                  onPressed: () {
                    if (!noteContentController.redoDisabled) {
                      noteContentController.redo();
                      _controller.text = noteContentController.currentContent;
                      widget.onContentChange(
                          noteContentController.currentContent);
                      setState(() {});
                    }
                  },
                  icon: Icon(Icons.redo,
                      color: noteContentController.redoDisabled
                          ? Colors.grey
                          : Colors.white));
            })
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
                Get.find<NoteContentController>().editContent(text);
                setState(() {});
              },
            )));
  }

  _showKeyboard() => setState(() {
        _keyboardShow = true;
        _scrollController = ScrollController();
      });
}
