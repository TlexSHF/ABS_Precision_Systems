with MicroBit.Console; use MicroBit.Console;
with MicroBit.TimeHighspeed; use MicroBit.TimeHighspeed;
with Ada.Real_Time; use Ada.Real_Time;
with MicroBit.IOsForTasking; use MicroBit.IOsForTasking;
with MicroBit.Buttons; use MicroBit.Buttons;
--  with MicroBit.Ultrasonic;
with nRF; use nRF;

package body Ultrasensors is
   
   task body ProcessMessages is
      clockStart : Time;
      period : Time_Span := Milliseconds(10);
      distance : Time_Span;
   begin
      delay until Clock + period;
      loop
         clockStart := Clock;
         distance := (echoTime*speedOfSound);
         distance := distance / 1000000;
         Put_Line (distance'Image);
         
         if State(Button_A) = Pressed then
            digitalWrite(12, True);
            Delay_Us(5);
            digitalWrite(12, False);   
         end if;  

         delay until clockStart + period;
      end loop;
   end ProcessMessages; 
   
   
   protected body Receiver is
   
      procedure My_ISR is
         latchPort0 : LATCH_Register;
      begin
   
         nRF.Events.Disable_Interrupt (nRF.Events.GPIOTE_PORT);
   
         latchPort0 := GPIO_Periph.LATCH;
   
         GPIO_Periph.LATCH := GPIO_Periph.LATCH;
   
         if latchPort0.Arr (ultraFront.EchoPin.Pin) = Latched then
            if GPIO_Periph.IN_k.Arr (ultraFront.EchoPin.Pin) = High then
               ultraFront.RisingTime := Clock;
               GPIO_Periph.PIN_CNF (ultraFront.EchoPin.Pin).SENSE := Low;
               GPIO_Periph.PIN_CNF (ultraFront.EchoPin.Pin).PULL := Pullup;
            else
               ultraFront.echoTime := Clock - ultraFront.RisingTime;
               GPIO_Periph.PIN_CNF (ultraFront.EchoPin.Pin).SENSE := High;
               GPIO_Periph.PIN_CNF (ultraFront.EchoPin.Pin).PULL := Pulldown;
            end if;
         end if;
         nRF.Events.Clear (nRF.Events.GPIOTE_PORT);
         nRF.Events.Enable_Interrupt (nRF.Events.GPIOTE_PORT);
      end My_ISR;
   
   end Receiver;
               
begin
   
   nRF.Events.Disable_Interrupt (nRF.Events.GPIOTE_PORT);
   
   ultraFront.EchoPin.Configure_IO (confRising);
   
   GPIO_Periph.DETECTMODE.DETECTMODE := NRF_SVD.GPIO.Default;
   
   nRF.Events.Clear (nRF.Events.GPIOTE_PORT); --clear any prior events of GPIOTE_PORT
   nRF.Events.Enable_Interrupt (nRF.Events.GPIOTE_PORT); --enable interrupt of event 
   nRF.Interrupts.Enable (nRF.Interrupts.GPIOTE_Interrupt);  
   
   ultraFront.EchoPin.Configure_IO (confRising);
   null;
   
end Ultrasensors;
