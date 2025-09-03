import 'package:dashboard/features/AI/view%20model/cubit/ai_statistics_cubit.dart';
import 'package:dashboard/features/AI/view%20model/cubit/ai_statistics_state.dart';
import 'package:dashboard/features/AI/views/widgets/ai_page_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AiPage extends StatefulWidget {
  const AiPage({super.key});

  @override
  State<AiPage> createState() => _AiPageState();
}

class _AiPageState extends State<AiPage> {
  @override
  void initState() {
    super.initState();
    statistics();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AiStatisticsCubit, AiStatisticsState>(
        builder: (context, state) {
          if (state is AiStatisticsLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is AiStatisticsSuccess) {
            return AiPageBody();
          } else {
            return Text('Failure');
          }
        },
      ),
    );
  }

  Future<void> statistics() async {
    await BlocProvider.of<AiStatisticsCubit>(context).statistics();
  }
}
