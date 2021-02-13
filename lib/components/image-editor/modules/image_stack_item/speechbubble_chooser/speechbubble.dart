import 'package:flutter/material.dart';
import 'package:projectX/components/image-editor/modules/image_stack_item/animated_stack_item.dart';

class SpeechBubbleView extends StatefulWidget {
  final String value;
  final VoidCallback onMoving;
  final Function(AnimatedStackItemState) onStopMoving;
  final VoidCallback onDelete;
  final bool showButtons;
  final AnimatedStackItemState state = AnimatedStackItemState();

  SpeechBubbleView(
      // color, fontsize ve fontu parametre olarak al
      // hareket halindeyken de bir şeyler emit falan etsin kii çöp kutusu çıkısn
      {Key key,
      this.value,
      this.onMoving,
      this.onStopMoving,
      this.onDelete,
      this.showButtons})
      : super(key: key);
  @override
  _SpeechBubbleViewState createState() => _SpeechBubbleViewState();
}

class _SpeechBubbleViewState extends State<SpeechBubbleView> {
  bool showButtons;
  @override
  void initState() {
    showButtons = widget.showButtons;
    super.initState();
  }
  @override
  void didUpdateWidget(covariant SpeechBubbleView oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
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
              state: widget.state,
              imagePath: widget.value,
              hasText: true,
              showButtons: showButtons,
              onMoving: () => {widget.onMoving()},
              onStopMoving: (state) => {widget.onStopMoving(state)},
              onDelete: () => {widget.onDelete()},
              saveState: (stateBeforeDispose) => saveWidgetState(stateBeforeDispose))),
    ]);
  }

  saveWidgetState(stateBeforeDispose) {
    widget.state.position = stateBeforeDispose['position'];
    widget.state.lastPosition = stateBeforeDispose['lastPosition'];
    widget.state.offset = stateBeforeDispose['offset'];
    widget.state.width = stateBeforeDispose['width'];
    widget.state.scaleFactor = stateBeforeDispose['scaleFactor'];
    widget.state.rotation = stateBeforeDispose['rotation'];
  }
}
