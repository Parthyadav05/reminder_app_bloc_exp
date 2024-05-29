import 'package:equatable/equatable.dart';
class reminderEvents extends Equatable{
  const reminderEvents();
  @override
  List<Object?> get props => [];
}
class addReminderEvents extends reminderEvents{

   final Map<String ,dynamic> reminderMap;
   const addReminderEvents(this.reminderMap);
   @override
   List<Object?> get props => [reminderMap];
}
class editReminderEvents extends reminderEvents{
  final int index;
  final Map<String ,dynamic> reminderMap;
  const editReminderEvents(this.index , this.reminderMap);
  @override
  List<Object?> get props => [index ,reminderMap];

}

class deleteReminderEvents extends reminderEvents{
    final int index;
    const deleteReminderEvents(this.index);
    @override
    List<Object?> get props => [index];
}
class sortReminderEvents extends reminderEvents{
  final String priority;
  const sortReminderEvents(this.priority);
  @override
  List<Object?> get props => [priority];
}