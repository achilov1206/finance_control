import 'package:flutter/material.dart';
import '../utils/helpers.dart';

class DateRangeSelector extends StatefulWidget {
  final Function onDateSelected;
  final DateTime startDate;
  final DateTime endDate;
  const DateRangeSelector({
    Key? key,
    required this.onDateSelected,
    required this.startDate,
    required this.endDate,
  }) : super(key: key);

  @override
  State<DateRangeSelector> createState() => _DateRangeSelectorState();
}

class _DateRangeSelectorState extends State<DateRangeSelector> {
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    _startDate = widget.startDate;
    _endDate = widget.endDate;
    super.initState();
  }

  void _show() async {
    final DateTimeRange? result = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2022, 1, 1),
      lastDate: DateTime(2030, 12, 31),
      currentDate: DateTime.now(),
      saveText: 'Done',
    );

    if (result != null) {
      setState(() {
        _startDate = result.start;
        _endDate = result.end;
      });
      widget.onDateSelected(_startDate, _endDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10),
      color: Colors.white,
      width: double.infinity,
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: _show,
            child: Text(
              '${Helpers.dateFormatMMMEd(_startDate!)} - ${Helpers.dateFormatMMMEd(_endDate!)}',
            ),
          ),
          Icon(
            Icons.calendar_month,
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }
}
