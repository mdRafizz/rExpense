part of 'analytics_bloc.dart';

sealed class AnalyticsEvent extends Equatable {
  const AnalyticsEvent();

  @override
  List<Object?> get props => [];
}

final class LoadMonthlyAnalytics extends AnalyticsEvent {
  final int year;
  final int month;

  const LoadMonthlyAnalytics({required this.year, required this.month});

  @override
  List<Object?> get props => [year, month];
}

final class LoadYearlyAnalytics extends AnalyticsEvent {
  final int year;

  const LoadYearlyAnalytics({required this.year});

  @override
  List<Object?> get props => [year];
}
