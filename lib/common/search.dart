// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class SearchTextField extends StatefulWidget {
  Function onSearchUpdate;

  SearchTextField({
    super.key,
    required this.onSearchUpdate, // callback function
  });

  @override
  State<SearchTextField> createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: searchController,
      decoration: InputDecoration(
        label: const Text("Search"),
        labelStyle: Theme.of(context).textTheme.labelSmall,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6.0),
            borderSide: const BorderSide(color: Colors.white, width: 0.5)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.0),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor, // Border color when focused
            width: 0.5,
          ),
        ),
        suffixIcon: IconButton(
            onPressed: () {
              widget.onSearchUpdate(searchController.text);
            },
            icon: Icon(
              Icons.search,
              color: Theme.of(context).primaryColor,
            )),
      ),
    );
  }
}

///This is How you add the search functionality to the main page
/// String search = '';
/// void updateSearch(String newSearch) {
///   setState(() {
///     search = newSearch;
///   });
/// }
