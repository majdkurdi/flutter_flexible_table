library flutter_flexible_table;

import 'package:flutter/material.dart';

class FlexibleTable extends StatelessWidget {
  const FlexibleTable({
    Key? key,
    required this.headers,
    required this.rows,
    this.cellTS,
    this.headerTS,
    this.divider,
    this.color,
    this.centerContent = false,
    this.fillAllRows = false,
  }) : super(key: key);

  final List<String> headers;
  final List<List<String>> rows;
  final TextStyle? headerTS;
  final TextStyle? cellTS;
  final bool centerContent;
  final Color? color;
  final bool fillAllRows;
  final Widget? divider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TableRow(
          cells: headers,
          isHeader: true,
          textStyle: headerTS,
          centerContent: centerContent,
        ),
        Expanded(
          child: ListView.separated(
            itemBuilder: (ctx, i) => TableRow(
              cells: rows[i],
              headers: headers,
              textStyle: cellTS,
              filled: fillAllRows ? true : i.isEven,
              centerContent: centerContent,
            ),
            itemCount: rows.length,
            shrinkWrap: true,
            separatorBuilder: (context, index) =>
                //  SizedBox()
                divider ?? const SizedBox(height: 2),
          ),
        )
      ],
    );
  }
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

class TableRow extends StatefulWidget {
  TableRow({
    Key? key,
    required this.cells,
    this.headers,
    this.isHeader = false,
    this.textStyle,
    this.color,
    this.centerContent = false,
    this.filled = false,
  }) : super(key: key);
  final List<String> cells;
  final List<String>? headers;
  final bool isHeader;
  final TextStyle? textStyle;
  final bool filled;
  final bool centerContent;
  final Color? color;

  @override
  State<TableRow> createState() => _TableRowState();
}

class _TableRowState extends State<TableRow> {
  bool expanded = false;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final availableSpace = ((width / 100) - 1).round();

    return AnimatedSize(
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
                          textStyle: widget.textStyle,
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
                            textStyle: widget.textStyle,
                          ),
                        ),
                      !widget.isHeader
                          ? GestureDetector(
                              onTap: () {
                                setState(() => expanded = !expanded);
                              },
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
                                      !expanded ? Icons.add : Icons.remove,
                                      color:
                                          expanded ? Colors.red : Colors.green,
                                    ),
                                    backgroundColor: Colors.white,
                                    radius: 14,
                                  )))
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
                                style: widget.textStyle!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                widget.cells[i],
                                style: widget.textStyle,
                              ),
                            ),
                          ],
                        ),
                      )
                ],
              ),
      ),
    );
  }
}
