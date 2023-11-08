with Ada.Real_Time; use Ada.Real_Time;
with MicroBit; use MicroBit;
with MicroBit.Console; use MicroBit.Console;
with MicroBit.MotorDriver;
with MicroBit.Ultrasonic;
with MicroBit.IOsForTasking; use MicroBit.IOsForTasking;

package body Tasks is

   --Sense
   task body PollEcho is   
      clockStart : Time;
      period : Time_Span := Milliseconds(150);
   begin
      loop
         clockStart := Clock;
         
         distance    := sensor.Read;
         distance2   := sensor2.Read;
         distance3   := sensor3.Read;
         
         delay until clockStart + period;
      end loop;   
   end PollEcho;
   
   task body CheckSensor is
      clockStart : Time;
      period : Time_Span := Milliseconds(5);
   begin
      loop
         clockStart := Clock;
         
         lineTrackerLeft   := digitalRead (15);
         lineTrackerMiddle := digitalRead (14);
         lineTrackerRight  := digitalRead (16);
         
         delay until clockStart + period;
      end loop;   
   end CheckSensor;
   
   --Think
   task body TrackLine is
      clockStart : Time;
      period : Time_Span := Milliseconds(5);
      type LineTrackerCombinations is (None, L, M, R, L_M, M_R, L_R, L_M_R);  -- 3 trackers, L = Left tracker
      lineTrackerState : LineTrackerCombinations := None;                     --             M = Middle tracker
   begin                                                                      --             R = Right tracker
      loop
         clockStart := Clock;
         
         -- Update line trackers state
         if lineTrackerLeft and not lineTrackerMiddle and not lineTrackerRight then
            lineTrackerState := L;
         elsif not lineTrackerLeft and lineTrackerMiddle and not lineTrackerRight then
            lineTrackerState := M;
         elsif not lineTrackerLeft and not lineTrackerMiddle and lineTrackerRight then
            lineTrackerState := R;
         elsif LineTrackerLeft and LineTrackerMiddle and not lineTrackerRight then
            lineTrackerState := L_M;
         elsif not lineTrackerLeft and lineTrackerMiddle and lineTrackerRight then
            lineTrackerState := M_R;
         elsif lineTrackerLeft and lineTrackerMiddle and lineTrackerRight then
            lineTrackerState := L_M_R;
         else  lineTrackerState := None;
         end if;
        
         -- Set drive variable to correct drive state
         if distance > 10 or distance = 0 then
            case lineTrackerState is   
               when None   => drive := Stop;
               when L      => drive := Curve_Forward_Left;
               when M      => drive := Forward;
               when R      => drive := Curve_Forward_Right;
               when L_M    => drive := Curve_Forward_Left;
               when M_R    => drive := Curve_Forward_Right; 
               when L_M_R  => 
                  drive := Rotating_Right;
                  delay until clockStart + Milliseconds(100);
                  clockStart := Clock;
               when others => null; 
            end case;   
         else drive := Stop;
         end if;
         
         delay until clockStart + period;
      end loop;      
   end TrackLine; 
   
   --Act
   task body UpdateDirection is
      clockStart : Time;
      period : Time_Span := Milliseconds(5);
   begin 
      Set_Analog_Period_Us(20000);
      loop
         clockStart := Clock;   
         
         case drive is
            when Forward               => MotorDriver.Drive(MotorDriver.Forward);
            when Backward              => MotorDriver.Drive(MotorDriver.Backward);
            when Left                  => MotorDriver.Drive(MotorDriver.Left);
            when Right                 => MotorDriver.Drive(MotorDriver.Right);
            when Forward_Left          => MotorDriver.Drive(MotorDriver.Forward_Left);
            when Forward_Right         => MotorDriver.Drive(MotorDriver.Forward_Right);
            when Backward_Left         => MotorDriver.Drive(MotorDriver.Backward_Left);
            when Backward_Right        => MotorDriver.Drive(MotorDriver.Backward_Right);
            when Lateral_Left          => MotorDriver.Drive(MotorDriver.Lateral_Left);
            when Lateral_Right         => MotorDriver.Drive(MotorDriver.Lateral_Right);
            when Rotating_Left         => MotorDriver.Drive(MotorDriver.Rotating_Left);
            when Rotating_Right        => MotorDriver.Drive(MotorDriver.Rotating_Right);
            when Curve_Forward_Left    => MotorDriver.Drive(MotorDriver.Forward, (4095,4095,0,0));
            when Curve_Forward_Right   => MotorDriver.Drive(MotorDriver.Forward, (0,0,4095,4095));
            when Stop                  => MotorDriver.Drive(MotorDriver.Stop);
         end case;   
         
         delay until clockStart + period;
      end loop;   
   end UpdateDirection; 
   
end Tasks;
