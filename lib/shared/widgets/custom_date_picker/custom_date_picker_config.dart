library custom_widget;

import 'package:flutter/material.dart';
import 'package:hc_management_app/shared/widgets/custom_widget/custom_widget.dart';

enum CustomDatePickerType { single, range }

class CustomDatePickerConfig {
  CustomDatePickerConfig({
    CustomDatePickerType? calendarType,
    DateTime? firstDate,
    DateTime? lastDate,
    DateTime? currentDate,
    DatePickerMode? calendarViewMode,
    this.enableDays,
    this.weekdayLabels,
    this.weekdayLabelTextStyle,
    this.controlsHeight,
    this.lastMonthIcon,
    this.nextMonthIcon,
    this.controlsTextStyle,
    this.dayTextStyle,
    this.selectedDayTextStyle,
    this.selectedDayHighlightColor,
    this.disabledDayTextStyle,
    this.todayTextStyle,
    this.yearTextStyle,
    this.dayBorderRadius,
    this.yearBorderRadius,
  })  : calendarType = calendarType ?? CustomDatePickerType.single,
        firstDate = firstDate ?? DateTime(1970),
        lastDate = lastDate ?? DateTime(DateTime.now().year + 50),
        currentDate = currentDate ?? DateUtils.dateOnly(DateTime.now()),
        calendarViewMode = calendarViewMode ?? DatePickerMode.day;

  /// The enabled date picker mode
  final CustomDatePickerType calendarType;

  /// The earliest allowable [DateTime] that the user can select.
  final DateTime firstDate;

  /// The latest allowable [DateTime] that the user can select.
  final DateTime lastDate;

  /// The [DateTime] representing today. It will be highlighted in the day grid.
  final DateTime currentDate;

  /// The initially displayed view of the calendar picker.
  final DatePickerMode calendarViewMode;

  /// Custom weekday labels for the current locale
  final List<String>? weekdayLabels;

  /// Custom text style for weekday labels
  final TextStyle? weekdayLabelTextStyle;

  /// Custom height for calendar control toggle's height
  final double? controlsHeight;

  /// Custom icon for last month button control
  final Widget? lastMonthIcon;

  /// Custom icon for next month button control
  final Widget? nextMonthIcon;

  /// Custom text style for calendar mode toggle control
  final TextStyle? controlsTextStyle;

  /// Custom text style for calendar day text
  final TextStyle? dayTextStyle;

  /// Custom text style for selected calendar day(s)
  final TextStyle? selectedDayTextStyle;

  /// The highlight color for selected day
  final Color? selectedDayHighlightColor;

  /// Custom text style for disabled calendar day(s)
  final TextStyle? disabledDayTextStyle;

  /// Custom text style for the current day
  final TextStyle? todayTextStyle;

  // Custom text style for years list
  final TextStyle? yearTextStyle;

  /// Custom border radius for day indicator
  final BorderRadius? dayBorderRadius;

  /// Custom border radius for year indicator
  final BorderRadius? yearBorderRadius;

  final List<Month>? enableDays;

  CustomDatePickerConfig copyWith(
      {CustomDatePickerType? calendarType,
      DateTime? firstDate,
      DateTime? lastDate,
      List<Month>? enableDays,
      DateTime? currentDate,
      DatePickerMode? calendarViewMode,
      List<String>? weekdayLabels,
      TextStyle? weekdayLabelTextStyle,
      double? controlsHeight,
      Widget? lastMonthIcon,
      Widget? nextMonthIcon,
      TextStyle? controlsTextStyle,
      TextStyle? dayTextStyle,
      TextStyle? selectedDayTextStyle,
      Color? selectedDayHighlightColor,
      TextStyle? disabledDayTextStyle,
      TextStyle? todayTextStyle,
      TextStyle? yearTextStyle,
      BorderRadius? dayBorderRadius,
      BorderRadius? yearBorderRadius}) {
    return CustomDatePickerConfig(
      calendarType: calendarType ?? this.calendarType,
      firstDate: firstDate ?? this.firstDate,
      lastDate: lastDate ?? this.lastDate,
      enableDays: enableDays ?? this.enableDays,
      currentDate: currentDate ?? this.currentDate,
      calendarViewMode: calendarViewMode ?? this.calendarViewMode,
      weekdayLabels: weekdayLabels ?? this.weekdayLabels,
      weekdayLabelTextStyle:
          weekdayLabelTextStyle ?? this.weekdayLabelTextStyle,
      controlsHeight: controlsHeight ?? this.controlsHeight,
      lastMonthIcon: lastMonthIcon ?? this.lastMonthIcon,
      nextMonthIcon: nextMonthIcon ?? this.nextMonthIcon,
      controlsTextStyle: controlsTextStyle ?? this.controlsTextStyle,
      dayTextStyle: dayTextStyle ?? this.dayTextStyle,
      selectedDayTextStyle: selectedDayTextStyle ?? this.selectedDayTextStyle,
      selectedDayHighlightColor:
          selectedDayHighlightColor ?? this.selectedDayHighlightColor,
      disabledDayTextStyle: disabledDayTextStyle ?? this.disabledDayTextStyle,
      todayTextStyle: todayTextStyle ?? this.todayTextStyle,
      yearTextStyle: yearTextStyle ?? this.yearTextStyle,
      dayBorderRadius: dayBorderRadius ?? this.dayBorderRadius,
      yearBorderRadius: yearBorderRadius ?? this.yearBorderRadius,
    );
  }
}

class CalendarDatePicker2WithActionButtonsConfig
    extends CustomDatePickerConfig {
  CalendarDatePicker2WithActionButtonsConfig({
    CustomDatePickerType? calendarType,
    DateTime? firstDate,
    DateTime? lastDate,
    List<Month>? enableDays,
    DateTime? currentDate,
    DatePickerMode? calendarViewMode,
    List<String>? weekdayLabels,
    TextStyle? weekdayLabelTextStyle,
    double? controlsHeight,
    Widget? lastMonthIcon,
    Widget? nextMonthIcon,
    TextStyle? controlsTextStyle,
    TextStyle? dayTextStyle,
    TextStyle? selectedDayTextStyle,
    Color? selectedDayHighlightColor,
    TextStyle? disabledDayTextStyle,
    TextStyle? todayTextStyle,
    TextStyle? yearTextStyle,
    BorderRadius? dayBorderRadius,
    BorderRadius? yearBorderRadius,
    this.gapBetweenCalendarAndButtons,
    this.cancelButtonTextStyle,
    this.cancelButton,
    this.okButtonTextStyle,
    this.okButton,
    this.openedFromDialog,
    this.shouldCloseDialogAfterCancelTapped,
  }) : super(
          calendarType: calendarType,
          firstDate: firstDate,
          lastDate: lastDate,
          enableDays: enableDays,
          currentDate: currentDate,
          calendarViewMode: calendarViewMode,
          weekdayLabels: weekdayLabels,
          weekdayLabelTextStyle: weekdayLabelTextStyle,
          controlsHeight: controlsHeight,
          lastMonthIcon: lastMonthIcon,
          nextMonthIcon: nextMonthIcon,
          controlsTextStyle: controlsTextStyle,
          dayTextStyle: dayTextStyle,
          selectedDayTextStyle: selectedDayTextStyle,
          selectedDayHighlightColor: selectedDayHighlightColor,
          disabledDayTextStyle: disabledDayTextStyle,
          todayTextStyle: todayTextStyle,
          yearTextStyle: yearTextStyle,
          dayBorderRadius: dayBorderRadius,
          yearBorderRadius: yearBorderRadius,
        );

  /// The gap between calendar and action buttons
  final double? gapBetweenCalendarAndButtons;

  /// Text style for cancel button
  final TextStyle? cancelButtonTextStyle;

  /// Custom cancel button
  final Widget? cancelButton;

  /// Text style for ok button
  final TextStyle? okButtonTextStyle;

  /// Custom ok button
  final Widget? okButton;

  /// Is the calendar opened from dialog
  final bool? openedFromDialog;

  /// If the dialog should be closed when user taps the cancel button
  final bool? shouldCloseDialogAfterCancelTapped;

  @override
  CalendarDatePicker2WithActionButtonsConfig copyWith({
    CustomDatePickerType? calendarType,
    DateTime? firstDate,
    DateTime? lastDate,
    List<Month>? enableDays,
    DateTime? currentDate,
    DatePickerMode? calendarViewMode,
    List<String>? weekdayLabels,
    TextStyle? weekdayLabelTextStyle,
    double? controlsHeight,
    Widget? lastMonthIcon,
    Widget? nextMonthIcon,
    TextStyle? controlsTextStyle,
    TextStyle? dayTextStyle,
    TextStyle? selectedDayTextStyle,
    Color? selectedDayHighlightColor,
    TextStyle? disabledDayTextStyle,
    TextStyle? todayTextStyle,
    TextStyle? yearTextStyle,
    double? gapBetweenCalendarAndButtons,
    TextStyle? cancelButtonTextStyle,
    Widget? cancelButton,
    TextStyle? okButtonTextStyle,
    Widget? okButton,
    bool? openedFromDialog,
    bool? shouldCloseDialogAfterCancelTapped,
    BorderRadius? dayBorderRadius,
    BorderRadius? yearBorderRadius,
  }) {
    return CalendarDatePicker2WithActionButtonsConfig(
      calendarType: calendarType ?? this.calendarType,
      firstDate: firstDate ?? this.firstDate,
      lastDate: lastDate ?? this.lastDate,
      enableDays: enableDays ?? this.enableDays,
      currentDate: currentDate ?? this.currentDate,
      calendarViewMode: calendarViewMode ?? this.calendarViewMode,
      weekdayLabels: weekdayLabels ?? this.weekdayLabels,
      weekdayLabelTextStyle:
          weekdayLabelTextStyle ?? this.weekdayLabelTextStyle,
      controlsHeight: controlsHeight ?? this.controlsHeight,
      lastMonthIcon: lastMonthIcon ?? this.lastMonthIcon,
      nextMonthIcon: nextMonthIcon ?? this.nextMonthIcon,
      controlsTextStyle: controlsTextStyle ?? this.controlsTextStyle,
      dayTextStyle: dayTextStyle ?? this.dayTextStyle,
      selectedDayTextStyle: selectedDayTextStyle ?? this.selectedDayTextStyle,
      selectedDayHighlightColor:
          selectedDayHighlightColor ?? this.selectedDayHighlightColor,
      disabledDayTextStyle: disabledDayTextStyle ?? this.disabledDayTextStyle,
      todayTextStyle: todayTextStyle ?? this.todayTextStyle,
      yearTextStyle: yearTextStyle ?? this.yearTextStyle,
      gapBetweenCalendarAndButtons:
          gapBetweenCalendarAndButtons ?? this.gapBetweenCalendarAndButtons,
      cancelButtonTextStyle:
          cancelButtonTextStyle ?? this.cancelButtonTextStyle,
      cancelButton: cancelButton ?? this.cancelButton,
      okButtonTextStyle: okButtonTextStyle ?? this.okButtonTextStyle,
      okButton: okButton ?? this.okButton,
      openedFromDialog: openedFromDialog ?? this.openedFromDialog,
      shouldCloseDialogAfterCancelTapped: shouldCloseDialogAfterCancelTapped ??
          this.shouldCloseDialogAfterCancelTapped,
      dayBorderRadius: dayBorderRadius ?? this.dayBorderRadius,
      yearBorderRadius: yearBorderRadius ?? this.yearBorderRadius,
    );
  }
}
