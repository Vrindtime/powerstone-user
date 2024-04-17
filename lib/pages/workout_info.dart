import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:powerstone/common/video_player.dart';

class WorkoutInfo extends StatefulWidget {
  final String docid;
  const WorkoutInfo({super.key, required this.docid});

  @override
  State<WorkoutInfo> createState() => _WorkoutInfoState();
}

class _WorkoutInfoState extends State<WorkoutInfo> {
  late Future<DocumentSnapshot<Map<String, dynamic>>> _workoutFuture;

  @override
  void initState() {
    super.initState();
    // Fetch the workout document based on docid
    _workoutFuture = FirebaseFirestore.instance
        .collection('workout')
        .doc(widget.docid)
        .get();
  }

  final MainAxisAlignment axis = MainAxisAlignment.spaceBetween;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: _workoutFuture,
        builder: (context,
            AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching data'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData && snapshot.data != null) {
            Map<String, dynamic> workoutData =
                snapshot.data!.data() as Map<String, dynamic>;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      workoutData['WorkoutName'],
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  AspectRatio(
                    aspectRatio: 16/9,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: ChewieVideoPlayer(
                        videoUrl: workoutData['WorkoutVideoLink'],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: axis,
                        children: [
                          Text(
                            'Muscle:',
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(fontSize: 20),
                          ),
                          Text(
                            workoutData['WorkoutMuscle'],
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    color: Theme.of(context).primaryColor,
                    thickness: 1,
                    height: 16,
                  ),
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: axis,
                        children: [
                          Text(
                            'Sets:',
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(fontSize: 20),
                          ),
                          Text(
                            workoutData['WorkoutSet'],
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    color: Theme.of(context).primaryColor,
                    thickness: 1,
                    height: 16,
                  ),
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: axis,
                        children: [
                          Text(
                            'Reps:',
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(fontSize: 20),
                          ),
                          Text(
                            workoutData['WorkoutRep'],
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    color: Theme.of(context).primaryColor,
                    thickness: 1,
                    height: 16,
                  ),
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: axis,
                        children: [
                          Text(
                            'Intensity:',
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(fontSize: 20),
                          ),
                          Text(
                            workoutData['WorkoutIntensity'],
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    color: Theme.of(context).primaryColor,
                    thickness: 1,
                    height: 16,
                  ),
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start  ,
                          children: [
                            Text(
                              'Workout Instruction:',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium
                                  ?.copyWith(fontSize: 20),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              workoutData['WorkoutInstruction'],
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }

  //custom components Here after
  AppBar customAppBar(BuildContext context) {
    return AppBar(
      toolbarHeight: 65,
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(
          Icons.clear_outlined,
          size: 32,
        ),
        color: Theme.of(context).primaryColor,
      ),
      title: const Text('WORKOUT DETAILS'),
      centerTitle: true,
    );
  }
}
