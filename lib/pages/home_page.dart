import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:powerstone/common/list_card_workout.dart';
import 'package:powerstone/common/muscle_card.dart';
import 'package:powerstone/common/notification.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Assuming you renamed WorkoutCard file

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String docID;
  late String yourValue;

  @override
  void initState() {
    super.initState();
    docID = '';
    yourValue = '';
    getUserDetails();
  }

  void getUserDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('userID') ?? '';
    String value = await getSingleValue(id) ?? '';
    setState(() {
      docID = id;
      yourValue = value;
    });
  }

  Future<String?> getSingleValue(String docID) async {
    try {
      DocumentSnapshot snapshot =
          await FirebaseFirestore.instance.collection('user').doc(docID).get();
      var data = snapshot.data() as Map<String, dynamic>;
      return data['firstName']; // Replace with your field name
    } catch (e) {
      print('Error fetching single value: $e');
      return null;
    }
  }

  void openNotification() {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const NotificationPage()));
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                yourValue.isNotEmpty
                    ? Text('Welcome, $yourValue',
                        style: Theme.of(context).textTheme.labelLarge)
                    : Text('Welcome',
                        style: Theme.of(context).textTheme.labelLarge),
                IconButton(
                  onPressed: openNotification,
                  icon: const Icon(Icons.notifications),
                  color: Theme.of(context).primaryColor,
                  iconSize: 36,
                ),
              ],
            ),
            const SizedBox(height: 10,),
            Align(
              alignment: Alignment.center,
              child: Text('Workouts',
                            style: Theme.of(context).textTheme.labelLarge),
            ),
            const SizedBox(height: 10,),
            MuscleCard(muscle: 'CHEST', imagePath: 'assets/muscle/chest.png', onPressed: (){
              Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WorkoutCard(muscle: 'chest'),
                      ),
                    );
            }),
            const SizedBox(height: 10,),
            MuscleCard(muscle: 'BACK', imagePath: 'assets/muscle/lats.png', onPressed: (){
              Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WorkoutCard(muscle: 'lat'),
                      ),
                    );
            }),
            const SizedBox(height: 10,),
            MuscleCard(muscle: 'SHOULDER', imagePath: 'assets/muscle/shoulder.png', onPressed: (){
              Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WorkoutCard(muscle: 'delt'),
                      ),
                    );
            }),
            const SizedBox(height: 10,),
            MuscleCard(muscle: 'BICEPS', imagePath: 'assets/muscle/bicep.png', onPressed: (){
              Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WorkoutCard(muscle: 'bicep'),
                      ),
                    );
            }),
            const SizedBox(height: 10,),
            MuscleCard(muscle: 'TRICEP', imagePath: 'assets/muscle/tricep.png', onPressed: (){
              Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WorkoutCard(muscle: 'tricep'),
                      ),
                    );
            }),
            const SizedBox(height: 10,),
            MuscleCard(muscle: 'LEG', imagePath: 'assets/muscle/leg.png', onPressed: (){
              Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WorkoutCard(muscle: 'leg'),
                      ),
                    );
            }),
            const SizedBox(height: 10,),
            MuscleCard(muscle: 'CARDIO', imagePath: 'assets/muscle/cardio.png', onPressed: (){
              Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WorkoutCard(muscle: 'cardio'),
                      ),
                    );
            }),
          ],
        ),
      ),
    );
  }
}
