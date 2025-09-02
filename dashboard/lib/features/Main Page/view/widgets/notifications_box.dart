import 'package:dashboard/core/utils/theme.dart';
import 'package:dashboard/features/Main%20Page/model/notification_model.dart';
import 'package:dashboard/features/Main%20Page/view%20model/cubit/main_cubit.dart';
import 'package:dashboard/features/Main%20Page/view%20model/cubit/main_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationsBox extends StatefulWidget {
  const NotificationsBox({super.key});

  @override
  State<NotificationsBox> createState() => _NotificationsBoxState();
}

class _NotificationsBoxState extends State<NotificationsBox> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainCubit, MainState>(
      builder: (context, state) {
        if (state is NotificationsLoadingState || state is MainLoadingState) {
          return Center(child: CircularProgressIndicator());
        } else {
          List<NotificationModel> notifications =
              BlocProvider.of<MainCubit>(context).notifications;
          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  ListTile(
                    title: Text(
                      notifications[index].title,
                      style: TextStyle(
                        color: Themes.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    subtitle: Text(
                      notifications[index].body,
                      style: TextStyle(color: Themes.text, fontSize: 18),
                    ),
                    trailing: Text(notifications[index].date.substring(0, 10)),
                    onLongPress: () async {
                      await BlocProvider.of<MainCubit>(
                        context,
                      ).deleteNotifications(id: notifications[index].id);
                    },
                  ),
                  Divider(),
                ],
              );
            },
          );
        }
      },
    );
  }
}
