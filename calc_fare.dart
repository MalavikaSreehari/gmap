import 'package:farespy/global/fare_details.dart';

double calculateFare(double distance) {
  
  if(distance==0.0)
  {
    return 0.0;
  }
  else if(distance<=1.5){
    return minimumCharge;
  }
  double fare = minimumCharge;  
    
    double additionalKilometers=0.0;

      // Calculate fare based on distance
      double additionalDistance = distance - 1.5; // Subtract the initial 1.5 km
      if (additionalDistance > 0) {
        additionalKilometers = additionalDistance.floorToDouble();
        fare += additionalKilometers * ratePerKilometer;
      }

      // Calculate fare based on remaining meters
      //double remainingMeters = distance % 1000;
      double remainingMeters = (additionalDistance - additionalKilometers)*1000;
      double additionalHundredMeters = remainingMeters / 100;
      fare += additionalHundredMeters * ratePerHundredMeter;
      

  
      
      return fare;
    }

    double calculateWaitingCharge(double hr, double min) {
      double waitingTime = hr * 60 + min;
      double waitingCharge = 0.0;

      if(waitingTime==0.0){
        return waitingCharge;
      }
      if(waitingTime<24*60){
        waitingCharge +=
          (waitingTime / 15).ceil() * waitingChargePerFifteenMinutes;
      
      waitingCharge = waitingCharge.clamp(0, maximumChargePerDay);
      return waitingCharge;

      }
      while(waitingTime>=24*60){
        waitingCharge+=250.0;
        waitingTime-=24*60;
      }
      
      //double waitingTime = hr * 60 + min;
      waitingCharge +=
          (waitingTime / 15).ceil() * waitingChargePerFifteenMinutes;
      
      
      

      return waitingCharge;
    }

    double calculateTotalFare(
        double distance, double hr, double min) {
      double fare = calculateFare(distance);
      double waitingCharge = calculateWaitingCharge(hr, min);
      double totalFare = fare + waitingCharge;

      return totalFare;
    }
