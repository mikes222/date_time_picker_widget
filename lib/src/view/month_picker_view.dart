import 'package:date_time_picker_widget/src/date_time_picker_controller.dart';
import 'package:date_time_picker_widget/src/model/date_time_picker_model.dart';
import 'package:flutter/material.dart';

/// Shows the month/year and a arrow on each side of it to jump to the previous/next month
class MonthPickerView extends StatelessWidget {
  final DateTimePickerModel model;

  final DateTimePickerController controller;

  const MonthPickerView(
      {Key? key, required this.model, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StreamBuilder<SelectedPage>(
            stream: controller.selectedPageObserve,
            builder: (context, AsyncSnapshot<SelectedPage> snapshot) {
              if (snapshot.data == null) return const SizedBox();
              if (snapshot.connectionState == ConnectionState.waiting)
                return const SizedBox();
              SelectedPage selectedPage = snapshot.data!;
              DateTime dateTime = selectedPage
                  .weeks[(model.numberOfWeeksToDisplay / 2).floor()]
                  .days[3]
                  .date;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                        icon: Icon(
                          Icons.keyboard_double_arrow_left_outlined,
                          color: Theme.of(context).textTheme.bodyText2?.color,
                        ),
                        onPressed: controller.previousYear),
                    IconButton(
                        icon: Icon(
                          Icons.navigate_before,
                          color: Theme.of(context).textTheme.bodyText2?.color,
                        ),
                        onPressed: controller.previousMonth),
                    Text(
                      '${model.viewConverter.monthYearToView(dateTime)}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).textTheme.bodyText2?.color,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    IconButton(
                        icon: Icon(
                          Icons.navigate_next,
                          color: Theme.of(context).textTheme.bodyText2?.color,
                        ),
                        onPressed: controller.nextMonth),
                    IconButton(
                        icon: Icon(
                          Icons.keyboard_double_arrow_right_outlined,
                          color: Theme.of(context).textTheme.bodyText2?.color,
                        ),
                        onPressed: controller.nextYear),
                  ],
                ),
              );
            }),
      ],
    );
  }
}
