import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:powerstone/pages/workout_info.dart';

class WorkoutCard extends StatelessWidget {
  final String muscle;
  
  const WorkoutCard({Key? key, required this.muscle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$muscle workouts'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 8,),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection("workout").where('WorkoutMuscle', isEqualTo: muscle).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No workouts found'));
                }
            
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var workoutData = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                    String workoutID = snapshot.data!.docs[index].id;
                    String name = workoutData["WorkoutName"] ?? '';
                    String muscle = workoutData["WorkoutMuscle"] ?? '';
                    String rep = workoutData["WorkoutRep"] ?? '';
                    String set = workoutData["WorkoutSet"] ?? '';
                    String intensity = workoutData["WorkoutIntensity"] ?? '';
            
                    return Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(name, style: Theme.of(context).textTheme.labelMedium?.copyWith(fontSize: 20)),
                                      const SizedBox(height: 8),
                                      Text('Muscle: $muscle', style: Theme.of(context).textTheme.labelSmall),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Set: $set * Rep: $rep \nIntensity: $intensity', style: Theme.of(context).textTheme.labelSmall),
                                      const SizedBox(height: 4),
                                      IconButton(
                                        icon: const Icon(Icons.info),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => WorkoutInfo(docid: workoutID),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
