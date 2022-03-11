import 'package:date_time_picker_widget/src/date_time_picker_controller.dart';
import 'package:date_time_picker_widget/src/model/date_time_picker_model.dart';
import 'package:flutter/material.dart';

class WeekdayView extends StatelessWidget {
  final DateTimePickerModel model;

  final DateTimePickerController controller;

  const WeekdayView({required this.model, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: model.firstDayOfWeek == DateTime.monday
              ? [1, 2, 3, 4, 5, 6, 7]
                  .map((e) => _build(context, model.viewConverter.weekdays[e]!))
                  .toList()
              : [7, 1, 2, 3, 4, 5, 6]
                  .map((e) => _build(context, model.viewConverter.weekdays[e]!))
                  .toList(),
        ),
      ),
    );
  }

  Widget _build(BuildContext context, String caption) {
    return Container(
      width: 32,
      child: Text(
        caption,
        style: TextStyle(
          fontSize: 18,
          color: Colors.grey,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
