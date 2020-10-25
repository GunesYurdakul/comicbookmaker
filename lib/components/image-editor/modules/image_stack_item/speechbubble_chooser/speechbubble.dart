import 'package:flutter/material.dart';
import 'package:projectX/components/image-editor/modules/image_stack_item/animated_stack_item.dart';

class SpeechBubbleView extends StatefulWidget {
  final String value;
  final VoidCallback onMoving;
  SpeechBubbleView(
      // color, fontsize ve fontu parametre olarak al
      // hareket halindeyken de bir şeyler emit falan etsin kii çöp kutusu çıkısn
      {Key key,
      this.value,
      this.onMoving})
      : super(key: key);
  @override
  _SpeechBubbleViewState createState() => _SpeechBubbleViewState();
}

class _SpeechBubbleViewState extends State<SpeechBubbleView> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center, children: <Widget>[
      Container(
          child: AnimatedStackItem(
                  hasText: true,
                  imagePath: widget.value,
                  onMoving: () => {widget.onMoving()},
      )),
    ]);
  }
  
}
