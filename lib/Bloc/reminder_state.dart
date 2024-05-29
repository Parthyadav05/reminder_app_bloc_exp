import 'package:equatable/equatable.dart';
class reminderStates extends Equatable{
   List<Map<String , dynamic>> listReminderMap;
   reminderStates({this.listReminderMap = const []});
   reminderStates copyWith({List<Map<String , dynamic>>  ? listReminderMap}){
     return reminderStates(listReminderMap: listReminderMap ?? this.listReminderMap);
   }
  @override
  // TODO: implement props
  List<Object?> get props => [listReminderMap];
}
