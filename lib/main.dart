import 'package:flutter/material.dart';
import 'package:home_page/physical_copy.dart';
import 'package:home_page/privacy_policy.dart';
import 'package:home_page/send_feedback.dart';
import 'package:home_page/settings.dart';

import 'compost_pit_management.dart';
import 'consent_form.dart';
import 'contacts.dart';
import 'daily_report_page.dart';
import 'dashboard.dart';
import 'events.dart';
import 'iec_activities.dart';
import 'my_drawer_header.dart';
import 'notes.dart';
import 'notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      routes: {
        '/cpm': (context) => CPMPage(), // Route for the CPM page
        '/iec': (context) => IECPage(), // Route for the IEC page
        '/daily_report': (context) => DailyReportPage(),
        '/physical_copy': (context) => PhysicalCopyPage(formData: {},), // Route for Physical Copy page
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  var currentPage = DrawerSections.dashboard;
  late TabController _tabController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this); // Define 3 tabs
  }


  //Consent Form
  void navigateToConsentForm() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ConsentFormPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[700],
        title: Text("Home Page"),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight), // Ensure the size matches the AppBar
          child: Container(
            color: Colors.white, // Set background color for TabBar separately
            child: TabBar( // Add TabBar below the greeting text
              controller: _tabController,
              isScrollable: true,
              tabs: [
                Tab(text: 'Home Page'),
                Tab(text: 'CPM'), // First tab
                Tab(text: 'IEC'), // Second tab
                Tab(text: 'Daily Report'), // Third tab
              ],
              onTap: (index) {
                switch (index) {
                  case 1:
                    Navigator.pushNamed(context, '/cpm');
                    break;
                  case 2:
                    Navigator.pushNamed(context, '/iec');
                    break;
                  case 3:
                    Navigator.pushNamed(context, '/daily_report');
                    break;
                }
              },
            ),
          ),
        ),
      ),
      body:TabBarView( // Add TabBarView to switch between different tabs
          controller: _tabController,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                  color: Colors.amber[100], // Highlighted area color
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "good morning",
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 4), // Add spacing between the texts
                      Text(
                        "Hello, User",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 16), // Add spacing between the texts and the search bar
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              decoration: BoxDecoration(
                                color: Colors.white, // Background color for the search bar
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: "Search",
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 8), // Add spacing between the search bar and the icon
                          Icon(Icons.search),
                        ],
                      ),
                      SizedBox(height: 10,),
                      SizedBox(height: 16),
                      // Add spacing between the search bar and the button
                      ElevatedButton.icon(
                        onPressed: navigateToConsentForm,
                        icon: Icon(Icons.description), // Icon related to consent form
                        label: Text("Consent Form"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Column(
            children: [
              MyHeaderDrawer(),
              MyDrawerList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget MyDrawerList(){
    return Container(
      padding: EdgeInsets.only(top: 15,),
      child: Column(
        children: [
          menuItem(1, "Dashboard",Icons.dashboard_outlined,
              currentPage == DrawerSections.dashboard? true : false),
          menuItem(2, "Contacts",Icons.people_alt_outlined,
              currentPage == DrawerSections.contacts? true : false),
          menuItem(3, "Forms",Icons.event,
              currentPage == DrawerSections.forms? true : false),
          menuItem(4, "Notes",Icons.notes,
              currentPage == DrawerSections.notes? true : false),
          Divider(),
          menuItem(5, "Settings",Icons.settings_outlined,
              currentPage == DrawerSections.settings? true : false),
          menuItem(6, "Notifications",Icons.notifications_outlined,
              currentPage == DrawerSections.notifications? true : false),
          Divider(),
          menuItem(7, "Privacy Policy",Icons.privacy_tip_outlined,
              currentPage == DrawerSections.privacy_policy? true : false),
          menuItem(8, "Send Feedback",Icons.feedback_outlined,
              currentPage == DrawerSections.send_feedback? true : false),
        ],
      ),
    );
  }

  Widget menuItem(int id ,String title, IconData icon, bool selected){
    return Material(
      color: selected? Colors.grey[300]: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          switch (id) {
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DashboardPage()),
              );
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ContactsPage()),
              );
              break;
            case 3:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyForm()),
              );
              break;
            case 4:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotesPage()),
              );
              break;
            case 5:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
              break;
            case 6:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationPage()),
              );
              break;
            case 7:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PrivacyPolicyPage()),
              );
              break;
            case 8:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SendFeedbackPage()),
              );
              break;
          }
        },
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Row(
            children: [
              Expanded(child: Icon(icon,size: 20,color: Colors.black,),),
              Expanded(flex:3,child: Text(title,style: TextStyle(color: Colors.black,fontSize: 16),),),
            ],
          ),
        ),
      ),
    );
  }
}

enum DrawerSections {
  dashboard,
  contacts,
  forms,
  notes,
  settings,
  notifications,
  privacy_policy,
  send_feedback,
}
