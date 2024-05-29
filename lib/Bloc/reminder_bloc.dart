import 'package:bloc/bloc.dart';
import 'package:reminder_app/Bloc/reminder_event.dart';
import 'package:reminder_app/Bloc/reminder_state.dart';
class reminderBloc extends Bloc<reminderEvents , reminderStates> {
  List<Map<String, dynamic>> listReminderMap = [];

  reminderBloc() : super(reminderStates()) {
    on<addReminderEvents>(_addReminder);
    on<editReminderEvents>(_editReminder);
    on<deleteReminderEvents>(_deleteReminder);
    on<sortReminderEvents>(_sortReminder);
  }

  void _addReminder(addReminderEvents events, Emitter<reminderStates> emit) {
    final newList = List<Map<String, dynamic>>.from(state.listReminderMap);
    newList.add(events.reminderMap);
    emit(state.copyWith(listReminderMap: newList));
  }

  void _editReminder(editReminderEvents events, Emitter<reminderStates> emit) {
    final newList = List<Map<String, dynamic>>.from(state.listReminderMap);
    if (events.index >= 0 && events.index < newList.length) {
      newList[events.index] = events.reminderMap;
    }
    emit(state.copyWith(listReminderMap: newList));
  }

  void _deleteReminder(deleteReminderEvents events,
      Emitter<reminderStates> emit) {
    final newList = List<Map<String, dynamic>>.from(state.listReminderMap);
    if (events.index >= 0 && events.index < newList.length) {
      newList.removeAt(events.index);
    }
    emit(state.copyWith(listReminderMap: newList));
  }

  void _sortReminder(sortReminderEvents events, Emitter<reminderStates> emits) {
    final sortedList = List<Map<String, dynamic>>.from(state.listReminderMap);
    sortedList.sort((a, b) {
      int priorityA = _getPriorityValue(a['Priority']);
      int priorityB = _getPriorityValue(b['Priority']);
      return events.priority == 'High'
          ? priorityB.compareTo(priorityA)
          : priorityA.compareTo(priorityB);
    });
    emit(state.copyWith(listReminderMap: sortedList));
  }

  int _getPriorityValue(String priority) {
    switch (priority) {
      case 'High':
        return 1;
      case 'Medium':
        return 2;
      case 'Low':
        return 3;
      default:
        return 4;
    }
  }
}
