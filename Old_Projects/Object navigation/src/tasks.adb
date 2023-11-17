with Ada.Real_Time; use Ada.Real_Time;
with MicroBit; use MicroBit;
with MicroBit.Console; use MicroBit.Console;
with MicroBit.MotorDriver;
with MicroBit.Ultrasonic;
with MicroBit.IOsForTasking; use MicroBit.IOsForTasking;
package body Tasks is

   --Sense
   task body Drive_1 is
      clockStart : Time;
      period : Time_Span := Milliseconds(50);
   begin
      loop
         clockStart := Clock;
         MotorDriver.Drive(MotorDriver.Forward);
         delay until clockStart + period;
      end loop;
   end Drive_1;

   task body Drive_2 is
      clockStart : Time;
      period : Time_Span := Milliseconds(5);
   begin
      loop
         clockStart := Clock;
         MotorDriver.Drive(MotorDriver.Stop);
         delay until clockStart + period;
      end loop;
   end Drive_2;

   --Act
   --  task body UpdateDirection is
   --     clockStart : Time;
   --     period : Time_Span := Milliseconds(5);
   --  begin
   --     Set_Analog_Period_Us(20000);
   --     loop
   --        clockStart := Clock;
   --
   --        case drive is
   --           when Forward               => MotorDriver.Drive(MotorDriver.Forward);
   --           when Backward              => MotorDriver.Drive(MotorDriver.Backward);
   --           when Left                  => MotorDriver.Drive(MotorDriver.Left);
   --           when Right                 => MotorDriver.Drive(MotorDriver.Right);
   --           when Forward_Left          => MotorDriver.Drive(MotorDriver.Forward_Left);
   --           when Forward_Right         => MotorDriver.Drive(MotorDriver.Forward_Right);
   --           when Backward_Left         => MotorDriver.Drive(MotorDriver.Backward_Left);
   --           when Backward_Right        => MotorDriver.Drive(MotorDriver.Backward_Right);
   --           when Lateral_Left          => MotorDriver.Drive(MotorDriver.Lateral_Left);
   --           when Lateral_Right         => MotorDriver.Drive(MotorDriver.Lateral_Right);
   --           when Rotating_Left         => MotorDriver.Drive(MotorDriver.Rotating_Left);
   --           when Rotating_Right        => MotorDriver.Drive(MotorDriver.Rotating_Right);
   --           when Curve_Forward_Left    => MotorDriver.Drive(MotorDriver.Forward, (4095,4095,0,0));
   --           when Curve_Forward_Right   => MotorDriver.Drive(MotorDriver.Forward, (0,0,4095,4095));
   --           when Stop                  => MotorDriver.Drive(MotorDriver.Stop);
   --        end case;
   --
   --        delay until clockStart + period;
   --     end loop;
   --  end UpdateDirection;

end Tasks;
