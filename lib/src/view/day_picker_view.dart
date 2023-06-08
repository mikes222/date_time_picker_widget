import 'package:date_time_picker_widget/src/date_time_picker_controller.dart';
import 'package:date_time_picker_widget/src/model/date_time_picker_model.dart';
import 'package:date_time_picker_widget/src/model/day.dart';
import 'package:date_time_picker_widget/src/model/week.dart';
import 'package:flutter/material.dart';

class DayPickerView extends StatelessWidget {
  final PageController _dateScrollController = PageController();

  final DateTimePickerModel model;

  final DateTimePickerController controller;

  DayPickerView({required this.model, required this.controller});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SelectedTimestamp>(
        stream: controller.selectedTimestampObserve,
        builder: (context, AsyncSnapshot<SelectedTimestamp> snapshot) {
          if (snapshot.data == null) return const SizedBox();
          if (snapshot.connectionState == ConnectionState.waiting)
            return const SizedBox();

          SelectedTimestamp selectedTimestamp = snapshot.data!;

          return Stack(
            children: [
              Container(
                height: (53 * model.numberOfWeeksToDisplay).toDouble(),
                child: PageView.builder(
                  controller: _dateScrollController,
                  onPageChanged: (int pageNbr) {
                    controller.setPageNbr(pageNbr, "DayPicker");
                  },
                  itemCount: controller.maxPages,
                  itemBuilder: (BuildContext context, int page) {
                    //print("displaying page $page");
                    return _buildPage(context, page);
                  },
                ),
              ),
              StreamBuilder(
                  stream: controller.selectedPageObserve,
                  builder: (context, AsyncSnapshot<SelectedPage> snapshot) {
                    if (snapshot.data == null) return const SizedBox();
                    if (snapshot.connectionState == ConnectionState.waiting)
                      return const SizedBox();
                    if (snapshot.data!.origin != "DayPicker")
                      _dateScrollController.animateToPage(
                          snapshot.data!.pageNbr,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.ease);
                    return const SizedBox();
                  }),
            ],
          );
        });
  }

  Widget _buildPage(BuildContext context, int pageNbr) {
    List<Week> weeks = controller.getWeeks(pageNbr);
    List<Widget> children = [];
    for (int i = 0; i < weeks.length; ++i) {
      Week week = weeks[i];
      children.add(Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: week.days.map((day) => _buildDay(day, context)).toList(),
        ),
      ));
    }
    return Column(
      children: children,
    );
  }

  Center _buildDay(Day day, BuildContext context) {
    return Center(
      child: InkWell(
        onTap: !day.enabled ? null : () => controller.setDay(day.date),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(90),
            border: Border.all(
              color: controller.isSelectedDay(day.date)
                  ? Theme.of(context).primaryColor
                  : Colors.grey,
            ),
            color: day.enabled
                ? controller.isSelectedDay(day.date)
                    ? Theme.of(context).primaryColor
                    : Colors.white
                : Colors.grey.shade300,
          ),
          alignment: Alignment.center,
          width: 32,
          height: 32,
          child: Text(
            '${day.date.day}',
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: controller.isSelectedDay(day.date)
                    ? Colors.white
                    : Colors.grey),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
