library flutter_flexible_table;

import 'package:flutter/material.dart';

class FlexibleTable<T> extends StatelessWidget {
  const FlexibleTable({
    Key? key,
    required this.headers,
    required this.rows,
    this.cellTS,
    this.coloredCellTS,
    this.headerTS,
    this.divider,
    this.color,
    this.values,
    this.onDoubleTap,
    this.onLongPress,
    this.onTap,
    this.scrollable = true,
    this.centerContent = false,
    this.fillAllRows = false,
    this.errorValues = const [],
    this.errorRowDecoration = const ErrorRowDecoration(),
    this.focusIndex,
  }) : super(key: key);

  final List<String> headers;
  final List<List<String>> rows;
  final TextStyle? headerTS;
  final TextStyle? cellTS;
  final TextStyle? coloredCellTS;
  final bool centerContent;
  final Color? color;
  final bool fillAllRows;
  final Widget? divider;
  final List<T>? values;
  final bool scrollable;
  final void Function(T?)? onTap;
  final void Function(T?)? onLongPress;
  final void Function(T?)? onDoubleTap;
  final List<T> errorValues;
  final ErrorRowDecoration errorRowDecoration;
  final int? focusIndex;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TableRow(
          cells: headers,
          isHeader: true,
          color: color,
          textStyle: headerTS,
          centerContent: centerContent,
        ),
        scrollable
            ? Expanded(
                child: ListView.separated(
                  itemBuilder: (ctx, i) => TableRow<T>(
                    cells: rows[i],
                    headers: headers,
                    textStyle: values == null
                        ? cellTS
                        : (errorValues.contains(values![i])
                            ? errorRowDecoration.textStyle
                            : cellTS),
                    coloredCellTextStyle: coloredCellTS,
                    color: values == null
                        ? color
                        : (errorValues.contains(values![i])
                            ? errorRowDecoration.rowColor
                            : color),
                    filled: (values != null && errorValues.contains(values![i]))
                        ? true
                        : (fillAllRows ? true : i.isEven),
                    centerContent: centerContent,
                    value: values?[i],
                    onDoubleTap: onDoubleTap,
                    onTap: onTap,
                    onLongPress: onLongPress,
                    hasFocus: focusIndex != null ? focusIndex == i : false,
                  ),
                  itemCount: rows.length,
                  shrinkWrap: true,
                  physics: scrollable ? null : NeverScrollableScrollPhysics(),
                  separatorBuilder: (context, index) =>
                      //  SizedBox()
                      divider ?? const SizedBox(height: 2),
                ),
              )
            : ListView.separated(
                itemBuilder: (ctx, i) => TableRow<T>(
                  cells: rows[i],
                  headers: headers,
                  textStyle: values == null
                      ? cellTS
                      : (errorValues.contains(values![i])
                          ? errorRowDecoration.textStyle
                          : cellTS),
                  coloredCellTextStyle: coloredCellTS,
                  color: values == null
                      ? color
                      : (errorValues.contains(values![i])
                          ? errorRowDecoration.rowColor
                          : color),
                  filled: fillAllRows ? true : i.isEven,
                  centerContent: centerContent,
                  value: values?[i],
                  onDoubleTap: onDoubleTap,
                  onTap: onTap,
                  onLongPress: onLongPress,
                ),
                itemCount: rows.length,
                shrinkWrap: true,
                physics: scrollable ? null : NeverScrollableScrollPhysics(),
                separatorBuilder: (context, index) =>
                    //  SizedBox()
                    divider ?? const SizedBox(height: 2),
              ),
      ],
    );
  }
}

class ErrorRowDecoration {
  final Color? rowColor;
  final TextStyle? textStyle;

  const ErrorRowDecoration({this.rowColor = Colors.red, this.textStyle});
}

class Cell extends StatelessWidget {
  const Cell({
    Key? key,
    required this.content,
    this.textStyle,
    this.maxWidth = 150,
    this.centerContent = false,
  }) : super(key: key);

  final String content;
  final TextStyle? textStyle;
  final double maxWidth;
  final bool centerContent;

  @override
  Widget build(BuildContext context) {
    // double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Container(
        constraints:
            BoxConstraints(minWidth: 50, minHeight: 60, maxWidth: maxWidth),
        // width: double.infinity,
        child: Center(
          child: Column(
            crossAxisAlignment: centerContent
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.stretch,
            children: [
              Text(content, style: textStyle),
            ],
          ),
        ),
      ),
    );
  }
}

class TableRow<T> extends StatefulWidget {
  TableRow({
    Key? key,
    required this.cells,
    this.headers,
    this.isHeader = false,
    this.textStyle,
    this.color,
    this.value,
    this.onDoubleTap,
    this.onLongPress,
    this.onTap,
    this.coloredCellTextStyle,
    this.centerContent = false,
    this.filled = false,
    this.hasFocus = false,
  }) : super(key: key);
  final List<String> cells;
  final List<String>? headers;
  final bool isHeader;
  final TextStyle? textStyle;
  final TextStyle? coloredCellTextStyle;
  final bool filled;
  final bool centerContent;
  final Color? color;
  final T? value;
  final void Function(T?)? onTap;
  final void Function(T?)? onDoubleTap;
  final void Function(T?)? onLongPress;
  final bool hasFocus;

  @override
  State<TableRow<T>> createState() => _TableRowState();
}

class _TableRowState<T> extends State<TableRow<T>> {
  bool expanded = false;
  final focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant TableRow<T> oldWidget) {
    if (widget.hasFocus) {
      FocusScope.of(context).requestFocus(focusNode);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final availableSpace = ((width / 100) - 1).round();

    return InkWell(
      focusNode: focusNode,
      onTap: () {
        if (widget.onTap != null) widget.onTap!(widget.value);
      },
      onDoubleTap: () {
        if (widget.onDoubleTap != null) widget.onDoubleTap!(widget.value);
      },
      onLongPress: () {
        if (widget.onLongPress != null) widget.onLongPress!(widget.value);
      },
      child: AnimatedSize(
        alignment: Alignment.topCenter,
        duration: Duration(milliseconds: 300),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 2),
          color: widget.filled ? (widget.color ?? Colors.grey[200]) : null,
          child: (widget.cells.length * 100 < width - 40)
              ? Row(
                  children: widget.cells
                      .map((e) => Cell(
                            content: e,
                            centerContent: widget.centerContent,
                            textStyle: widget.filled
                                ? widget.coloredCellTextStyle ??
                                    widget.textStyle
                                : widget.textStyle,
                            maxWidth: (width - 80) / widget.cells.length,
                          ))
                      .toList(),
                )
              : Column(
                  children: [
                    Row(
                      children: [
                        for (int i = 0; i < availableSpace; i++)
                          Expanded(
                            child: Cell(
                              content: widget.cells[i],
                              textStyle: widget.filled
                                  ? widget.coloredCellTextStyle ??
                                      widget.textStyle
                                  : widget.textStyle,
                            ),
                          ),
                        !widget.isHeader
                            ? GestureDetector(
                                onTap: () {
                                  setState(() => expanded = !expanded);
                                },
                                child: Container(
                                  color: Colors.transparent,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                        margin: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                                blurRadius: 8,
                                                color: Colors.grey[400]!,
                                                spreadRadius: 2)
                                          ],
                                        ),
                                        child: CircleAvatar(
                                          child: Icon(
                                            !expanded
                                                ? Icons.expand_more
                                                : Icons.expand_less,
                                            color: expanded
                                                ? Colors.red
                                                : Colors.green,
                                          ),
                                          backgroundColor: Colors.white,
                                          radius: 20,
                                        )),
                                  ),
                                ))
                            : SizedBox(width: 48)
                      ],
                    ),
                    if (expanded)
                      for (int i = availableSpace; i < widget.cells.length; i++)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              SizedBox(width: width >= 250 ? 40 : width / 10),
                              Expanded(
                                child: Text(
                                  widget.headers![i] + ':       ',
                                  style: widget.textStyle != null
                                      ? (widget.filled
                                              ? widget.coloredCellTextStyle ??
                                                  widget.textStyle
                                              : widget.textStyle)!
                                          .copyWith(fontWeight: FontWeight.bold)
                                      : widget.textStyle,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  widget.cells[i],
                                  style: widget.filled
                                      ? widget.coloredCellTextStyle ??
                                          widget.textStyle
                                      : widget.textStyle,
                                ),
                              ),
                            ],
                          ),
                        )
                  ],
                ),
        ),
      ),
    );
  }
}
