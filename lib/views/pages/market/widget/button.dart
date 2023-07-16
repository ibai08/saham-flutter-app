import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  @override
  _CustomButtonsState createState() => _CustomButtonsState();
}

class _CustomButtonsState extends State<CustomButton> {
  String activeButton = 'Most Active';
  String dataToShow = 'Initial Data';

  void setActiveButton(String buttonName) {
    setState(() {
      activeButton = buttonName;
      if (buttonName == '1D') {
        dataToShow = 'Data for 1D';
      } else if (buttonName == '1W') {
        dataToShow = 'Data for 1W';
      } else if (buttonName == '1M') {
        dataToShow = 'Data for 1M';
      } else if (buttonName == '3M') {
        dataToShow = 'Data for 3M';
      } else if (buttonName == '1Y') {
        dataToShow = 'Data for 1Y';
      } else if (buttonName == '5Y') {
        dataToShow = 'Data for 5Y';
      } else if (buttonName == 'All') {
        dataToShow = 'Data for 1D';
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
              CustomButtons('1D', activeButton, setActiveButton),
              SizedBox(width: 10),
              CustomButtons('1W', activeButton, setActiveButton),
              SizedBox(width: 10),
              CustomButtons('1M', activeButton, setActiveButton),
              SizedBox(width: 10),
              CustomButtons('3M', activeButton, setActiveButton),
              SizedBox(width: 10),
              CustomButtons('1Y', activeButton, setActiveButton),
              SizedBox(width: 10),
              CustomButtons('5Y', activeButton, setActiveButton),
              SizedBox(width: 10),
              CustomButtons('All', activeButton, setActiveButton),
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
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? Color.fromRGBO(53, 6, 153, 1.0) : null,
          borderRadius: BorderRadius.circular(8),
          border: isActive ? Border.all(color: Color.fromRGBO(53, 6, 153, 1.0)) : null
        ),
        child: Text(
          buttonText,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}