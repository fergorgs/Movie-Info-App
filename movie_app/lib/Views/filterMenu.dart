import 'package:flutter/material.dart';

class FilterMenu extends StatefulWidget {

  FilterMenu(this.prevSelectedGenres, this.filterFunction);
  final List<String> prevSelectedGenres;
  final Function filterFunction;

  @override
  _FilterMenuState createState() => _FilterMenuState(prevSelectedGenres, filterFunction);
}

class _FilterMenuState extends State<FilterMenu> {

  _FilterMenuState(this.prevSelectedGenres, this.filterFunction);
  final List<String> prevSelectedGenres;
  final Function filterFunction;

  Map genres = {
    'Comedy' : false,
    'Drama' : false,
    'Romance' : false,
    'Crime' : false,
    'Animation' : false,
    'History' : false,
    'War' : false,
    'Family' : false,
    'Fantasy' : false,
    'Thriller' : false,
    'Horror' : false
  };

  @override
  initState()
  {
    super.initState();
    prevSelectedGenres.forEach((genre) {
      genres[genre] = true;
    });
  }

  List<String> convertMapToList(){

    List<String> genreList = [];

    genres.forEach((key, value) {
      
      if(genres[key])
        genreList.add(key);
    });

    return genreList;
  }

  List<Widget> getGenreBoxes(){

    List<Widget> genreBoxes = [];

    genres.forEach((genre, selected) {

      genreBoxes.add(
        CheckboxListTile(
          title: Text(
            genre,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[300]
            )
          ),
          checkColor: Colors.grey[300],
          activeColor: Colors.grey[300],
          value: selected,
          onChanged: (value) {
            setState(() {
              genres[genre] = value;
            });
          },
        ),
      );
    });

    return genreBoxes;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Filter by genre',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[300]
            )
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: getGenreBoxes(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    genres.forEach((key, value) {
                      genres[key] = false;
                    });
                  });
                  Navigator.pop(context);
                  filterFunction(convertMapToList()); 
                },
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'Reset',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.blue[400]
                    )
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  filterFunction(convertMapToList()); 
                },
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'Apply',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.blue[400]
                    )
                  ),
                ),
              )
            ]
          )
        ]
      ),
    );
  }
}