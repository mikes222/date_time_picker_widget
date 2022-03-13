import 'package:date_time_picker_widget/src/date_time_picker_controller.dart';
import 'package:date_time_picker_widget/src/model/date_time_picker_model.dart';
import 'package:date_time_picker_widget/src/model/timeslot.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class TimePickerView extends StatelessWidget {
  final DateTimePickerModel model;

  final DateTimePickerController controller;

  final ItemScrollController _timeScrollController = ItemScrollController();

  // final ItemPositionsListener _timePositionsListener =
  //     ItemPositionsListener.create();

  TimePickerView({
    Key? key,
    required this.model,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SelectedTimestamp>(
        stream: controller.selectedTimestampObserve,
        builder: (context, AsyncSnapshot<SelectedTimestamp> snapshot) {
          if (snapshot.data == null) return const SizedBox();
          if (snapshot.connectionState == ConnectionState.waiting)
            return const SizedBox();

          SelectedTimestamp selectedTimestamp = snapshot.data!;
          List<Timeslot> timeslots = selectedTimestamp
              .day.timeslots; // controller.getTimeslotsForSelectedDay();

          int idx = 0;
          for (Timeslot timeslot in timeslots) {
            if (controller.isSelectedTime(timeslot.date)) {
              break;
            }
            ++idx;
          }
          if (idx < timeslots.length) {
            if (idx < 3) idx = 0;
            if (idx >= 3) idx -= 2;
          }

          return Container(
            height: 45,
            alignment: Alignment.center,
            child: ScrollablePositionedList.builder(
              initialScrollIndex: idx,
              itemScrollController: _timeScrollController,
              //itemPositionsListener: viewModel.timePositionsListener,
              scrollDirection: Axis.horizontal,
              itemCount: timeslots.length,
              itemBuilder: (context, index) {
                Timeslot timeslot = timeslots[index];
                if (idx >= 0) {
                  // still not working
                  // _timeScrollController.scrollTo(
                  //     index: idx, duration: const Duration(milliseconds: 500));
                  idx = -1;
                }
                return _buildItem(timeslot, context);
              },
            ),
          );
        });
  }

  InkWell _buildItem(Timeslot timeslot, BuildContext context) {
    return InkWell(
      onTap: timeslot.enabled ? () => controller.setTime(timeslot.date) : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: controller.isSelectedTime(timeslot.date)
                ? Theme.of(context).accentColor
                : Colors.grey,
          ),
          color: timeslot.enabled
              ? controller.isSelectedTime(timeslot.date)
                  ? Theme.of(context).accentColor
                  : Colors.white
              : Colors.grey.shade300,
        ),
        alignment: Alignment.center,
        child: Text(
          // ignore: lines_longer_than_80_chars
          '${model.viewConverter.timeToView(timeslot.date)}',
          style: TextStyle(
              fontSize: 14,
              color: controller.isSelectedTime(timeslot.date)
                  ? Colors.white
                  : Colors.grey),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
