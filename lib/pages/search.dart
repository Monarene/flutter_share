import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  AppBar buildSearchField() {
    return AppBar(
      backgroundColor: Colors.white,
      title: TextFormField(
        autocorrect: true,
        decoration: InputDecoration(
            hintText: "Search for a user",
            filled: true,
            prefixIcon: Icon(
              Icons.account_box,
              size: 28.0,
            ),
            suffixIcon: IconButton(
              icon: Icon(Icons.clear),
              onPressed: () => print("cleared"),
            )),
      ),
    );
  }

  Container buildNoContent() {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return Container(
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            SvgPicture.asset(
              'assets/images/search.svg',
              height: orientation == Orientation.portrait ? 300.0 : 200,
            ),
            Text(
              "Find Users",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 50.0),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildSearchField(),
      body: buildNoContent(),
    );
  }
}

class UserResult extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text("User Result");
  }
}
