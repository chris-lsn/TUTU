import 'package:flutter/material.dart';
import '../case/create.dart';
import '../case/view.dart';

class MyCasePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.blue,
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CreateCaseForm()));
            },
            child: Icon(Icons.add)),
        body: ListView(
          padding: EdgeInsets.all(10),
          children: <Widget>[_myCaseCards(context)],
        ));
  }

  Widget _myCaseCards(BuildContext context) {
    TextStyle _caseCardTitleStyle =
        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold);
        
    return Column(children: <Widget>[
      InkWell(
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (context) => ViewCasePage())),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('小五 陳小友', style: _caseCardTitleStyle),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        child: Text('Active',
                            style: TextStyle(color: Colors.white)),
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(15)),
                      )
                    ],
                  ),
                  Divider(height: 15, color: Colors.grey),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: <Widget>[
                      Icon(Icons.timer),
                      Text(' Every Mon, Wed, Fri 09:00-12:00'),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: <Widget>[
                      Icon(Icons.location_on),
                      Text(' Flat A, 17/F, Block 1, Kingston Terrace'),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: <Widget>[
                      Icon(Icons.import_contacts),
                      Text(' 中文，英文，數學'),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Text('\$100', style: TextStyle(fontSize: 25.0)),
                              Text(' /lesson')
                            ],
                          ),
                          Text('\$200/hr - 1hr')
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      
    ),
    SizedBox(height: 10,),
    InkWell(
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (context) => ViewCasePage())),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('小五 陳小友', style: _caseCardTitleStyle),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        child: Text('Active',
                            style: TextStyle(color: Colors.white)),
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(15)),
                      )
                    ],
                  ),
                  Divider(height: 15, color: Colors.grey),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: <Widget>[
                      Icon(Icons.timer),
                      Text(' Every Mon, Wed, Fri 09:00-12:00'),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: <Widget>[
                      Icon(Icons.location_on),
                      Text(' Flat A, 17/F, Block 1, Kingston Terrace'),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: <Widget>[
                      Icon(Icons.import_contacts),
                      Text(' 中文，英文，數學'),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Text('\$100', style: TextStyle(fontSize: 25.0)),
                              Text(' /lesson')
                            ],
                          ),
                          Text('\$200/hr - 1hr')
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      
    ),
    SizedBox(height: 10,),
    InkWell(
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (context) => ViewCasePage())),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('小五 陳小友', style: _caseCardTitleStyle),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        child: Text('Active',
                            style: TextStyle(color: Colors.white)),
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(15)),
                      )
                    ],
                  ),
                  Divider(height: 15, color: Colors.grey),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: <Widget>[
                      Icon(Icons.timer),
                      Text(' Every Mon, Wed, Fri 09:00-12:00'),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: <Widget>[
                      Icon(Icons.location_on),
                      Text(' Flat A, 17/F, Block 1, Kingston Terrace'),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: <Widget>[
                      Icon(Icons.import_contacts),
                      Text(' 中文，英文，數學'),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Text('\$100', style: TextStyle(fontSize: 25.0)),
                              Text(' /lesson')
                            ],
                          ),
                          Text('\$200/hr - 1hr')
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      
    )
    ],);
  }
}
