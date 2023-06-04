import 'package:farespy/paymentone.dart';
import 'package:flutter/material.dart';

class PaymentTwo extends StatelessWidget {
  const PaymentTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: const Color(0xFF258EAB),
            height: 100,
            child: Row(
              children: [
                const Padding(padding: EdgeInsets.only(left: 20)),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PaymentOne()),
                  );
                },
                  child: const SizedBox(
                    width: 50,
                    child:
                        Image(image: AssetImage('assets/images/back_icon.png')),
                  ),
                ),
                const SizedBox(
                  width: 50,
                ),
                Text(
                  'Select UPI App',
                  style: TextStyle(
                    fontSize: 24,
                  ),
                )
              ],
            ),
          ),
          const Text(
            'Total Fare',
            style: TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.w400,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Align(),
              SizedBox(
                width: 100,
                child: Image(
                    image: AssetImage('assets/images/total_cost_icon.png')),
              ),
              SizedBox(
                width: 50,
              ),
              Text(
                '\u{20B9}${490.00}',
                style: TextStyle(
                    color: Color(0xFF258EAB),
                    fontSize: 50,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const Text(
            'Choose to pay',
            style: TextStyle(
              fontSize: 24,
            ),
          ),
          const Divider(
            color: Color(0xFFEAE6E6),
            thickness: 2,
          ),
          Row(
            children: [
              SizedBox(
                child: Row(
                  children: const [
                    SizedBox(
                        width: 80,
                        child: Image(
                            image: AssetImage('assets/images/phonepe.png'))),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      'PhonePe',
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          const Divider(
            color: Color(0xFFEAE6E6),
            thickness: 2,
          ),
          Row(
            children: [
              SizedBox(
                child: Row(
                  children: const [
                    SizedBox(
                        height: 80,
                        child: Image(
                            image: AssetImage('assets/images/paytm.png'))),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      'Paytm',
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          const Divider(
            color: Color(0xFFEAE6E6),
            thickness: 2,
          ),
          Row(
            children: [
              SizedBox(
                child: Row(
                  children: const [
                    SizedBox(
                        height: 80,
                        child: Image(
                            image: AssetImage('assets/images/applepay.png'))),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      'Apple Pay',
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          const Divider(
            color: Color(0xFFEAE6E6),
            thickness: 2,
          ),
          Row(
            children: [
              SizedBox(
                child: Row(
                  children: const [
                    SizedBox(
                        height: 80,
                        child:
                            Image(image: AssetImage('assets/images/gpay.png'))),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      'Google Pay',
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
