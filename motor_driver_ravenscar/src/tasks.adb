with Ada.Real_Time; use Ada.Real_Time;
with MicroBit; use MicroBit;
with MicroBit.Console; use MicroBit.Console;
with MicroBit.MotorDriver; use MicroBit.MotorDriver;
with MicroBit.Ultrasonic;
with MicroBit.IOsForTasking; use MicroBit.IOsForTasking;

package body tasks is

   task body updateDirection is
      clockStart : Time;
      Period : Time_Span := Milliseconds(500);
   begin 
      Set_Analog_Period_Us(20000);
      loop
         clockStart := Clock;   
         
         case State is
            when Forward               => Drive(Forward);
            when Backward              => Drive(Backward);
            when Left                  => Drive(Left);
            when Right                 => Drive(Right);
            when Forward_Left          => Drive(Forward_Left);
            when Forward_Right         => Drive(Forward_Right);
            when Backward_Left         => Drive(Backward_Left);
            when Backward_Right        => Drive(Backward_Right);
            when Lateral_Left          => Drive(Lateral_Left);
            when Lateral_Right         => Drive(Lateral_Right);
            when Rotating_Left         => Drive(Rotating_Left);
            when Rotating_Right        => Drive(Rotating_Right);
            when Curve_Forward_Left    => Drive(Forward, (4095,4095,2047,2047));
            when Curve_Forward_Right   => Drive(Forward, (2047,2047,4095,4095));
            when Stop                  => Drive(Stop);
         end case;   
         
         delay until clockStart + Period;
      end loop;   
   end updateDirection; 
   
   task body checkSensor is
      clockStart : Time;
      Period : Time_Span := Milliseconds(50);
      LineTrackerLeft  : Boolean    := False;
      LineTrackerRight : Boolean    := False;
   begin
      loop
         clockStart := Clock;
         
         distance := sensor.Read;
         LineTrackerLeft  := digitalRead (16);
         LineTrackerRight := digitalRead (15);
         
         Put_Line("Left: " & LineTrackerLeft'Image & ", Right: " & LineTrackerRight'Image);
         
         delay until clockStart + Period;
      end loop;   
   end checkSensor;
   
end tasks;
