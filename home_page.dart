import 'package:farespy/findroute.dart';
import 'package:farespy/map.dart';
import 'package:farespy/paymentone.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  static const  String idScreen = "home";
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 100,
            ),
            Image.asset(
                'assets/images/logo.jpeg',
                width: 350,
                height: 400,
              ),
            const SizedBox(
              height: 100,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                 TextButton(
                          onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => (PaymentOne())),
                        );
                      }, child: Column(
                        children: [
                          Container(
                    width: 120,
                    height: 140,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFF258EAB),
                        width: 3.0,
                      ),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.9),
                          spreadRadius: 3.0,
                          blurRadius: 10.0,
                          offset: const Offset(0, 3),
                        )
                      ]
                    ),
                    child: 
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Image.asset('assets/images/getfare.png'),
                              //SizedBox(height: 20,),
                              Text(
                                'Get Fare',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Color(0xFF258EAB)
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                      
                  ),
      
                        ],
                      ),
                        ),
                  
                
                Container(
                    width: 120,
                    height: 140,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFF258EAB),
                        width: 3.0,
                      ),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 3.0,
                          blurRadius: 10.0,
                          offset: const Offset(0, 3),
                        )
                      ]
                    ),
                    
                    child: TextButton(
                          onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => (FindRoute())),
                        );
                      }, child: 
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Image.asset('assets/images/newroute.png',height: 70,),
                              Text(
                              'Find Route',
                              style: TextStyle(
                                fontSize: 20,
                                color: Color(0xFF258EAB)
                              ),
                                                    ),
                            ],
                          ),
                        
                       
                        ),
                  ),
                  
              ],
            )
          ],
        ),
      ),
      
    );
  }
}