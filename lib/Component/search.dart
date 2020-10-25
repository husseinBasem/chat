import 'package:flutter/material.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget({this.onTap,this.onChanged,
    Key key,

  }) : super(key: key);

  final Function onTap,onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      height: 35.0,
      child: TextField(
        autofocus: false,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Search For Users',
          prefixIcon: Icon(
            Icons.search,
            color: Colors.black38,
          ),
          border: OutlineInputBorder(
              borderRadius:
              BorderRadius.all(Radius.circular(20.0))),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          contentPadding: EdgeInsets.symmetric(vertical: 1.0),
        ),
        onTap: onTap,
        onChanged: onChanged,


      ),
    );
  }
}