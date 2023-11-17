with MicroBit; use MicroBit;
with MicroBit.MotorDriver;
with Ada.Real_Time; use Ada.Real_Time;
with MicroBit.TimeWithRTC1; use MicroBit.TimeWithRTC1;
with MicroBit.IOsForTasking; use MicroBit.IOsForTasking;
with MicroBit.Console;
with Ada.Numerics.Discrete_Random;
with MicroBit.DisplayRT;

package body tasks is

 -- Sense
   task body PollEcho is
      clockStart : Time;
      period : Time_Span := Milliseconds(27);
   begin
      loop
         clockStart := Clock;

         distanceFront  := sensorFront.Read;
         distanceRight  := sensorRight.Read;
         distanceLeft   := sensorLeft.Read;

         pollFlag := True;

         if distanceFront = 0 then distanceFront := 400; end if;
         if distanceRight = 0 then distanceRight := 400; end if;
         if distanceLeft = 0 then distanceLeft := 400; end if;

         delay until clockStart + period;
      end loop;
   end PollEcho;

   -- Think
   task body ProbeThink is
      clockStart : Time;
      period : Time_Span := Milliseconds(10);
   begin
      loop
         clockStart := Clock;

         DisplayRT.Clear;
         case probeState is
            when Probe => DisplayRT.Display('P');
            when GoToFront => DisplayRT.Display('F');
            when GoToLeft => DisplayRT.Display('L');
            when GoToRight => DisplayRT.Display('R');
            when Stop => DisplayRT.Display('S');
            when others => DisplayRT.Display('X'); exit;
         end case;

         if pollFlag then

            if distanceFront <= 20 then
               probeState := Stop;
            elsif distanceFront <= 50 then
               probeState := GoToFront;
            elsif distanceRight <= 50 then
              probeState := GoToRight;
             elsif distanceLeft <= 50 then
               probeState := GoToLeft;
            else
               probeState := Probe;
            end if;
         end if;

        delay until clockStart + period;
      end loop;
   end ProbeThink;

   -- Act
   task body Fare is
      -- Random Number Generator
      package Rand_Int is new ada.numerics.discrete_random(Angle);
      gen : Rand_Int.Generator;

      -- Times and Durations
      driveDuration : constant Time_Span := Seconds(3);
      driveStart : Time;
      wantedAngle : Angle := 90;

   begin
      Set_Analog_Period_Us(20000);
      driveStart := Clock;
      loop
         previousProbeState := probeState;

         if probeState = Stop then
            MotorDriver.Drive(MotorDriver.Stop);
            driveStart := Clock;
         else

            -- Car drives for "driveDuration"
            MotorDriver.Drive(MotorDriver.Forward);

            if probeState = Probe and Clock >= driveStart + driveDuration then
               -- Car rotates for "wantedAngle" degrees
               Rand_Int.reset(gen);
               wantedAngle := Rand_Int.random(gen);
               Rotate(wantedAngle); -- Worst case: 1 656 ms
               driveStart := Clock;

            elsif probeState = GoToRight and  previousProbeState /= GoToRight then
               Rotate(90, true); -- Worst case: 1 656 ms
               driveStart := Clock;

            elsif probeState = GoToLeft and previousProbeState /= GoToLeft then
               Rotate(90, false); -- Worst case: 1 656 ms
               driveStart := Clock;
            end if;
         end if;
      end loop;
   end Fare;


  	-- Procedures

   procedure Rotate (wantedAngle : Angle; clockwise : Boolean := True) is
      angleDurationMicro : constant Integer := 9200;
      totalAngleDuration : Time_Span := Microseconds(Integer(wantedAngle) * angleDurationMicro);
      rotateStart : Time;

   begin
      rotateStart := Clock;

      if clockwise then
         MotorDriver.Drive(MotorDriver.Rotating_Right);
      else
         MotorDriver.Drive(MotorDriver.Rotating_Left);
      end if;

      delay until rotateStart + totalAngleDuration; -- Worst case: 1 656 ms
                                                    -- = 1 656 000 us = 180*9200 (MaxAngle*duration)
   end Rotate;
end tasks;
