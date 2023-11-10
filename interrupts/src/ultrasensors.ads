with System;
with Ada.Interrupts;
with nRF.GPIO; use nRF.GPIO;
with NRF_SVD.GPIO; use NRF_SVD.GPIO;
with nRF.Interrupts;
with nRF.Events;
with Ada.Real_Time; use Ada.Real_Time;
with Ada.Interrupts.Names; 
with MicroBit; use MicroBit;
with HAL; use HAL;

package Ultrasensors is

   type Ultrasensors is record
      EchoPin : GPIO_Point;
      TriggerPin : GPIO_Point;
      FallingTime : Time;
      RisingTIme : Time;
      status : Boolean;
   end record;

   
   clockTime : Time := Clock;
   ultraFront  : Ultrasensors := (EchoPin => (Pin => 02), TriggerPin => (Pin => 12), FallingTime => clockTime, RisingTime => clockTime, status => False);
   --  ultraLeft   : Ultrasensors := (EchoPin => (Pin => 03), TriggerPin => (Pin => 17), FallingTime => clockTime, RisingTime => clockTime, status => False);
   --  ultraRight  : Ultrasensors := (EchoPin => (Pin => 04), TriggerPin => (Pin => 10), FallingTime => clockTime, RisingTime => clockTime, status => False);
   
   confFalling : GPIO_Configuration := (Mode => Mode_In, Resistors => Pull_Up,    
                                        Input_Buffer => Input_Buffer_Connect,       
                                        Drive => Drive_S0S1, Sense => Sense_For_Low_Level);
   confRising  : GPIO_Configuration := (Mode => Mode_In, Resistors => Pull_Down,
                                        Input_Buffer => Input_Buffer_Connect,
                                        Drive => Drive_S0S1, Sense => Sense_For_High_Level);
   
   protected Receiver is
   
      pragma Interrupt_Priority(System.Interrupt_Priority'First);
   private
      procedure My_ISR;
      pragma Attach_Handler(My_ISR, Ada.Interrupts.Names.GPIOTE_Interrupt);
   end Receiver;
   
   task ProcessMessages with Priority => 1;
end Ultrasensors;
