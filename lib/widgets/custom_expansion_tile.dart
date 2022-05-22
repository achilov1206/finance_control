import 'package:flutter/material.dart';

class CustomExpansionTile extends StatefulWidget {
  final String? title;
  final List<Widget>? children;
  const CustomExpansionTile({Key? key, this.title, this.children})
      : super(key: key);

  @override
  State<CustomExpansionTile> createState() => _CustomExpansionTileState();
}

class _CustomExpansionTileState extends State<CustomExpansionTile> {
  bool _isExpanded = true;
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        widget.title!,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      trailing: Icon(
        _isExpanded ? Icons.arrow_downward : Icons.arrow_upward,
        color: Colors.indigo,
        size: 30,
      ),
      children: widget.children!,
      onExpansionChanged: (expanded) {
        setState(() {
          _isExpanded = !expanded;
        });
      },
    );
  }
}
