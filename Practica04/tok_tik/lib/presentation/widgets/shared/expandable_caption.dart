import 'package:flutter/material.dart';

class ExpandableCaption extends StatefulWidget {
  const ExpandableCaption({
    required this.caption,
    this.maxExpandedHeight = 150,
    super.key,
  });

  final String caption;
  final double maxExpandedHeight;

  @override
  State<ExpandableCaption> createState() => _ExpandableCaptionState();
}

class _ExpandableCaptionState extends State<ExpandableCaption> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final width = screenWidth * 0.6;
    final style = Theme.of(context).textTheme.titleLarge
        ?.copyWith(color: Colors.white, fontWeight: FontWeight.w600);
    final painter = TextPainter(
      text: TextSpan(text: widget.caption, style: style),
      maxLines: 2,
      textDirection: Directionality.of(context),
      textScaler: MediaQuery.textScalerOf(context),
    )..layout(maxWidth: width);
    final hasOverflow = painter.didExceedMaxLines;

    return SizedBox(
      width: width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_expanded)
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: widget.maxExpandedHeight),
              child: SingleChildScrollView(
                child: Text(widget.caption, style: style),
              ),
            )
          else
            Text(
              widget.caption,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: style,
            ),
          if (hasOverflow)
            GestureDetector(
              onTap: () => setState(() => _expanded = !_expanded),
              child: Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  _expanded ? '(... menos)' : '(... más)',
                  style: style?.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
