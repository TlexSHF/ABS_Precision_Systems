with System;
with Ada.Interrupts;
with nRF.GPIO; use nRF.GPIO;
with NRF_SVD.GPIO; use NRF_SVD.GPIO;
with nRF.Interrupts;
with nRF.Events;
with Ada.Real_Time; use Ada.Real_Time;
with Ada.Interrupts.Names; 
with MicroBit.Console; use MicroBit.Console;
use MicroBit;
with HAL; use HAL;

package body Ultrasensors is
   
   type Ultrasensors is record
      EchoPin : GPIO_Point;
      TriggerPin : GPIO_Point;
      FallingTime : Time := 0;
      RisingTIme : Time := 0;
   end record; 
   
   
   

end Ultrasensors;
