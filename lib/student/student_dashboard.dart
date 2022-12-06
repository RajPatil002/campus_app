import 'package:campus_subsystem/messaging/conversation_screen.dart';
import 'package:campus_subsystem/student/student_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../firebase/signIn.dart';
import '../redux/reducer.dart';
import 'student_home.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({
    Key? key,
  }) : super(key: key);

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard>
    with WidgetsBindingObserver {
  final navigationKey = GlobalKey<CurvedNavigationBarState>();
  final Auth auth = Auth();
  int index = 0;

  void setStatus(String status) {
    FirebaseFirestore.instance
        .collection("Student_Detail")
        .where('Email', isEqualTo: FirebaseAuth.instance.currentUser?.email)
        .get()
        .then((value) => {
              FirebaseFirestore.instance
                  .doc("Student_Detail/${value.docs[0]["PRN"]}")
                  .set({'status': status}, SetOptions(merge: true))
            });
  }

  @override
  void initState() {
    super.initState();
    setStatus("Online");
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setStatus("Online");
    } else {
      setStatus("Offline");
    }
  }

  @override
  Widget build(BuildContext context) {
    var data = StoreProvider.of<AppState>(context).state;

    final screen = [
      const StudentHome(),
      const ConversationScreen(),
      const StudentProfile(),
    ];
    final items = <Widget>[
      const Icon(
        Icons.home_outlined,
        size: 30,
      ),
      const Icon(
        Icons.messenger_outline_rounded,
        size: 30,
      ),
      const Icon(
        Icons.person_outline_outlined,
        size: 30,
      ),
    ];
    return Scaffold(
        backgroundColor: Colors.white,
        body: screen[index],
        bottomNavigationBar: CurvedNavigationBar(
          key: navigationKey,
          backgroundColor: Colors.transparent,
          height: 60,
          items: items,
          index: index,
          onTap: (index) {
            setState(() {
              this.index = index;
            });
          },
        ));
  }
}
