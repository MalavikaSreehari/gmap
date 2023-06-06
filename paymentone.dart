import 'package:farespy/calc_fare.dart';
import 'package:farespy/paymenttwo.dart';
import 'package:flutter/material.dart';

class PaymentOne extends StatefulWidget {
  const PaymentOne({Key? key}) : super(key: key);

  @override
  _PaymentOneState createState() => _PaymentOneState();
}

class _PaymentOneState extends State<PaymentOne> {
  TextEditingController distanceTextEditingController = TextEditingController();
  TextEditingController hrTextEditingController = TextEditingController();
  TextEditingController minTextEditingController = TextEditingController();

  double fare = 0.0;
  double waitingCharge = 0.0;
  double totalFare = 0.0;
  

  void updateFares() {
  double distance = double.tryParse(distanceTextEditingController.text) ?? 0;
  double hr = double.tryParse(hrTextEditingController.text) ?? 0;
  double min = double.tryParse(minTextEditingController.text) ?? 0;

  setState(() {
    fare = calculateFare(distance);
    waitingCharge = calculateWaitingCharge(hr, min);
    totalFare = calculateTotalFare(distance, hr, min);
  });
}


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: const Color(0xFF93C561),
                width: double.infinity,
                height: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: const [
                        SizedBox(
                            width: 60,
                            child:
                                Image(image: AssetImage('assets/images/tick.png'))),
                        Text('PickUp')
                      ],
                    ),
                    Column(
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        Container(
                          color: Colors.black,
                          width: 120,
                          height: 3,
                        )
                      ],
                    ),
                    Column(
                      children: const [
                        SizedBox(
                            width: 60,
                            child: Image(
                                image: AssetImage('assets/images/tick.png'))),
                        Text('Destination')
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 60,),
              const Text(
                'Fare',
                style: TextStyle(fontSize: 31),
              ),
              const Divider(
                color: Color(0xFF93C561),
                thickness: 3,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Image(
                    image: AssetImage('assets/images/road_icon.png'),
                    width: 50,
                  ),
                  Text(
                    ' On road Charge',
                    style: TextStyle(fontSize: 20),
                  )
                ],
              ),
              const SizedBox(
                width: 250, // Set the width of the divider
                child: Divider(
                  color: Color(0xFF93C561),
                  thickness: 1,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text(
                        'Distance',
                        style: TextStyle(fontSize: 15),
                      ),
                      Row(
                        children: [
                          Container(
                            //color: Colors.blueAccent,
                            height: 30,
                            width: 60,
                            child: TextField(
                              controller: distanceTextEditingController,
                              keyboardType: TextInputType.numberWithOptions(),
                              decoration: InputDecoration(border: OutlineInputBorder(),),
                              style: TextStyle(
                                color: Color(0xFF258EAB), // set the text color to blue
                                fontSize: 24, // set the font size
                                fontWeight: FontWeight.bold, // set the font weight
                              ),
                              onChanged: (value) => updateFares(),
                            ),
                          ),
                          Text('km',style: TextStyle(
                                color: Color(0xFF258EAB), // set the text color to blue
                                fontSize: 24, // set the font size
                                fontWeight: FontWeight.bold, // set the font weight
                              ),)
                        ],
                      ),
                    ],
                  ),
                  const Padding(padding: EdgeInsets.only(right: 50)),
                  Container(
                    color: const Color(0xFF93C561),
                    width: 1,
                    height: 100,
                  ),
                  const Padding(padding: EdgeInsets.only(left: 50)),
                  Column(
                    //'\u{20B9}${440.00}'
                    children:[
                      Text(
                        'Fare',
                        style: TextStyle(fontSize: 15),
                      ),
                      Text(
                        '\u{20B9}${calculateFare(double.tryParse(distanceTextEditingController.text) ?? 0,).toStringAsFixed(2)}',
                        style: TextStyle(
                          color: Color(0xFF258EAB), // set the text color to blue
                          fontSize: 24, // set the font size
                          fontWeight: FontWeight.bold, // set the font weight
                        ),
                      ),
                    ],
                  )
                ],
              ),
              const Divider(
                color: Color(0xFF93C561),
                thickness: 2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Image(
                    image: AssetImage('assets/images/waiting_icon.png'),
                    width: 50,
                  ),
                  Text(
                    ' Waiting Charge',
                    style: TextStyle(fontSize: 20),
                  )
                ],
              ),
              const SizedBox(
                width: 250, // Set the width of the divider
                child: Divider(
                  color: Color(0xFF93C561),
                  thickness: 1,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text(
                        'Time',
                        style: TextStyle(fontSize: 15),
                      ),
                      Row(
                        children: [
                          Container(
                            //color: Colors.blueAccent,
                            height: 30,
                            width: 60,
                            child: TextField(
                              controller: hrTextEditingController,
                              keyboardType: TextInputType.numberWithOptions(),
                              decoration: InputDecoration(border: OutlineInputBorder(),),
                              style: TextStyle(
                                color: Color(0xFF258EAB), // set the text color to blue
                                fontSize: 24, // set the font size
                                fontWeight: FontWeight.bold, // set the font weight
                              ),
                              onChanged: (value) => updateFares(),
                            ),
                          ),
                          Text('hr',style: TextStyle(
                                color: Color(0xFF258EAB), // set the text color to blue
                                fontSize: 24, // set the font size
                                fontWeight: FontWeight.bold, // set the font weight
                              ),),
                              Container(
                            //color: Colors.blueAccent,
                            height: 30,
                            width: 60,
                            child: TextField(
                              controller: minTextEditingController,
                              keyboardType: TextInputType.numberWithOptions(),
                              decoration: InputDecoration(border: OutlineInputBorder(),),
                              style: TextStyle(
                                color: Color(0xFF258EAB), // set the text color to blue
                                fontSize: 24, // set the font size
                                fontWeight: FontWeight.bold, // set the font weight
                              ),
                              onChanged: (value) => updateFares(),
                            ),
                          ),
                          Text('min',style: TextStyle(
                                color: Color(0xFF258EAB), // set the text color to blue
                                fontSize: 24, // set the font size
                                fontWeight: FontWeight.bold, // set the font weight
                              ),)

                        ],
                      ),
                    ],
                  ),
                  const Padding(padding: EdgeInsets.only(right: 50)),
                  Container(
                    color: const Color(0xFF93C561),
                    width: 1,
                    height: 100,
                  ),
                  const Padding(padding: EdgeInsets.only(left: 50)),
                  Column(
                    children: [
                      Text(
                        'Fare',
                        style: TextStyle(fontSize: 15),
                      ),
                      Text(
                        '\u{20B9}${calculateWaitingCharge(double.tryParse(hrTextEditingController.text) ?? 0,double.tryParse(minTextEditingController.text) ?? 0).toStringAsFixed(2)}',
                        style: TextStyle(
                          color: Color(0xFF258EAB), // set the text color to blue
                          fontSize: 24, // set the font size
                          fontWeight: FontWeight.bold, // set the font weight
                        ),
                      ),
                    ],
                  )
                ],
              ),
              const Divider(
                color: Color(0xFF258EAB),
                thickness: 3,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Image(
                    image: AssetImage('assets/images/total_cost_icon.png'),
                    width: 80,
                  ),
                  Text(
                    'Total Fare',
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Text(
                '\u{20B9}'+ totalFare.toStringAsFixed(2),
                style: TextStyle(
                  color: Color(0xFF258EAB),
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
              //const Padding(padding: EdgeInsets.only(top: 20)),
              
              
              
            ],
          ),
        ),
      ),
    );
  }
}
