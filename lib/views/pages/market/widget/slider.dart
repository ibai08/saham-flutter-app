import 'package:flutter/material.dart';

class EmitenCategory extends StatefulWidget {
  @override
  _EmitenCategoryState createState() => _EmitenCategoryState();
}

class _EmitenCategoryState extends State<EmitenCategory> {
  String activeButton = 'Most Active';
  String dataToShow = 'Initial Data';

  void setActiveButton(String buttonName) {
    setState(() {
      activeButton = buttonName;
      if (buttonName == 'Most Active') {
        dataToShow = 'Data for Most Active';
      } else if (buttonName == 'Top Gamer (by %)') {
        dataToShow = 'Data for top gamer';
      } else if (buttonName == 'Top Loser (by %)') {
        dataToShow = 'Data for top loser';
      } else if (buttonName == 'Top Volume') {
        dataToShow = 'Data for top volume';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10,),
        
        // Button
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: <Widget>[
              CustomButtons('Most Active', activeButton, setActiveButton),
              SizedBox(width: 10),
              CustomButtons('Top Gamer (by %)', activeButton, setActiveButton),
              SizedBox(width: 10),
              CustomButtons('Top Loser (by %)', activeButton, setActiveButton),
              SizedBox(width: 10),
              CustomButtons('Top Volume', activeButton, setActiveButton),
            ],
          ),
        ),
        Text(
          dataToShow,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
  }
}

class CustomButtons extends StatelessWidget {
  final String buttonText;
  final String activeButton;
  final Function setActiveButton;

  CustomButtons(this.buttonText, this.activeButton, this.setActiveButton);

  bool get isActive => buttonText == activeButton;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setActiveButton(buttonText);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? Color.fromRGBO(46, 42, 255, 0.5) : null,
          borderRadius: BorderRadius.circular(8),
          border: isActive ? Border.all(color: Color.fromRGBO(53, 6, 153, 1.0)) : Border.all(color: Colors.grey)
        ),
        child: Text(
          buttonText,
          style: TextStyle(
            color: isActive ? Colors.black : Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}