import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/models/user.dart';
import 'package:fluttershare/pages/activity_feed.dart';
import 'package:fluttershare/pages/create_account.dart';
import 'package:fluttershare/pages/profile.dart';
import 'package:fluttershare/pages/search.dart';
import 'package:fluttershare/pages/timeline.dart';
import 'package:fluttershare/pages/upload.dart';
import 'package:google_sign_in/google_sign_in.dart';

final GoogleSignIn googlesignin = GoogleSignIn();
final CollectionReference users = Firestore.instance.collection("users");
final DateTime timestamp = DateTime.now();
User currentuser;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isAuth = false;
  PageController pageController;
  int pageIndex = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    googlesignin.onCurrentUserChanged.listen((account) {
      handlesignIn(account);
    }, onError: (err) {
      print('Error signing in: $err');
    });

    googlesignin.signInSilently(suppressErrors: false).then((account) {
      handlesignIn(account);
    });
  }

  void handlesignIn(GoogleSignInAccount account) {
    if (account != null) {
      createUserInFireStore();
      setState(() {
        isAuth = true;
      });
    } else {
      setState(() {
        isAuth = false;
      });
    }
  }

  createUserInFireStore() async {
    final GoogleSignInAccount user = googlesignin.currentUser;
    DocumentSnapshot doc = await usersRef.document(user.id).get();

    if (!doc.exists) {
      final username = await Navigator.push(
          context, MaterialPageRoute(builder: (context) => CreateAccount()));

      usersRef.document(user.id).setData({
        "id": user.id,
        "username": username,
        "photoUrl": user.photoUrl,
        "email": user.email,
        "displayName": user.displayName,
        "bio": "",
        "timestamp": timestamp
      });

      doc = await usersRef.document(user.id).get();
    }

    currentuser = User.fromDocument(doc);
  }

  onPageChanged(int pageIndex) {
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  onTap(int pageIndex) {
    pageController.animateToPage(
      pageIndex,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void login() {
    googlesignin.signIn();
  }

  void logout() {
    googlesignin.signOut();
  }

  Scaffold buildAuthScreen() {
    return Scaffold(
      body: PageView(
        children: <Widget>[
          // Timeline(),
          RaisedButton(
            child: Text("Logout"),
            onPressed: logout,
          ),
          ActivityFeed(),
          Upload(),
          Search(),
          Profile(),
        ],
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: pageIndex,
        onTap: onTap,
        activeColor: Theme.of(context).primaryColor,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.whatshot),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_active),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.photo_camera,
              size: 35,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
          ),
        ],
      ),
    );
  }

  Scaffold buildUnAuthScreen(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Theme.of(context).accentColor,
            Theme.of(context).primaryColor
          ], begin: Alignment.topRight, end: Alignment.bottomLeft),
        ),
        alignment: Alignment.center,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                "FlutterShare",
                style: TextStyle(
                    fontFamily: "Signatra",
                    fontSize: 90.0,
                    color: Colors.white),
              ),
              GestureDetector(
                onTap: login,
                child: Container(
                  width: 260.0,
                  height: 60.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image:
                          AssetImage('assets/images/google_signin_button.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isAuth ? buildAuthScreen() : buildUnAuthScreen(context);
  }
}
