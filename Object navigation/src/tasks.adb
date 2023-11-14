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
      period : Time_Span := Milliseconds(50);
   begin
      loop
         clockStart := Clock;

         distanceFront  := Integer(sensorFront.Read);
         distanceRight  := Integer(sensorRight.Read);
         distanceLeft   := Integer(sensorLeft.Read);
         if distanceFront = 0 then
            distanceFront := 400;
         end if;
         if distanceRight = 0 then
            distanceRight := 400;
         end if;
         if distanceLeft = 0 then
            distanceLeft := 400;
         end if;

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
         if (car = LineFollowing) then -- Precondition
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
         if distanceFront > 15 or distanceFront = 0 then
               case lineTrackerState is
                  when None   => drive := Stop;
                  when L      => drive := Curve_Forward_Left;
                  when M      => drive := Forward;
                  when R      => drive := Curve_Forward_Right;
                  when L_M    => drive := Curve_Forward_Left;
                  when M_R    => drive := Curve_Forward_Right;
                  when L_M_R  =>
                  drive := Rotating_Left;
                  delay until clockStart + Milliseconds(100);
                  clockStart := Clock;
               when others => null;
               end case;
            else
               drive := Stop;
               delay(0.2);
               car   := ObjectNavigating;
            end if;
         end if;

         delay until clockStart + period;
      end loop;
   end TrackLine;

   task body ObjectNav is
      clockStart : Time;
      period : Time_Span := Milliseconds(5);
      counter  : Integer  := 0;
      flag : Boolean := False;
   begin
      loop
         clockStart := Clock;
         if car = ObjectNavigating then   -- Precondition
            case counter is
               when 0 =>
                  if (distanceFront < 10 and distanceLeft > 10 and --hinder in the front
                        distanceRight > 10)
                  then
                     drive := Rotating_Left;
                     delay (0.828);
                     drive := Forward;
                     counter := 1;
                  elsif (distanceFront > 10 and distanceLeft > 10 and --hinder in the right
                           distanceRight < 20) then
                     counter := 1;
                  else
                     drive := Forward; --or just be in another state
                  end if;

               when 1 .. 4 =>
                  if (lineTrackerLeft or lineTrackerMiddle or lineTrackerRight) then
                        counter := 0;
                     car := LineFollowing;
                     end if;
                  if distanceRight <= 25 and distanceRight > 15 and distanceLeft > 10 and --too far from the object, go right
                    distanceFront > 10
                  then
                     drive := Lateral_Right;
                  elsif distanceRight < 15 and distanceRight >= 10 and distanceLeft > 10 and --right distance
                    distanceFront > 10
                  then
                     drive := Forward;
                     flag := True;
                  elsif distanceRight >= 25 and distanceLeft > 10 and --not reached target
                    distanceFront > 10 and flag = False
                  then
                     drive := Forward;
                  elsif distanceFront > 10 and distanceRight < 10 and distanceLeft > 10 then --too close to the object
                     drive := Lateral_Left;
                  elsif distanceFront > 10 and distanceRight > 30 and --finished
                    distanceLeft > 10 and flag = true
                  then
                     if counter = 4 then
                        counter := counter +1;
                     else
                        drive := Forward;
                        delay(0.400);
                        drive := Rotating_Right;
                        delay (0.828);
                        flag := False;

                        counter := counter + 1;
                      end if;

                  end if;


               when others =>
                  drive := Stop;   --next state
                  counter := 0;
            end case;

         end if;

         delay until clockStart + period;
      end loop;
   end ObjectNav;

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
