with MicroBit; use MicroBit;
with MicroBit.MotorDriver;
with Ada.Real_Time; use Ada.Real_Time;
with MicroBit.TimeWithRTC1; use MicroBit.TimeWithRTC1;
with MicroBit.IOsForTasking; use MicroBit.IOsForTasking;
with MicroBit.Console;
with Ada.Numerics.Discrete_Random;
with MicroBit.DisplayRT;

package body tasks is

   -- Bytter aldri tilbake til probe state


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
         if probeState = Stop then
            MotorDriver.Drive(MotorDriver.Stop);
            driveStart := Clock;
         else

            -- Car drives for "driveDuration"
            MotorDriver.Drive(MotorDriver.Forward);

            -- delay until driveStart + driveDuration;

            if probeState = probe and Clock >= driveStart + driveDuration then
               -- Car rotates for "wantedAngle" degrees
               Rand_Int.reset(gen);
               wantedAngle := Rand_Int.random(gen);
               Rotate(wantedAngle);
               driveStart := Clock;

            elsif probeState = GoToRight and  previousProbeState /= GoToRight then
               previousProbeState := GoToRight;
               Rotate(90, true);
               driveStart := Clock;

            elsif probeState = GoToLeft and previousProbeState /= GoToLeft then
               previousProbeState := GoToLeft;
               Rotate(90, false);
               driveStart := Clock;
            end if;
         end if;
      end loop;
   end Fare;

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

            if distanceFront > 0 and distanceFront <= 20 then
               probeState := Stop;
            elsif distanceFront > 0 and distanceFront <= 30 then
               probeState := GoToFront;
             elsif distanceRight > 0 and distanceRight <= 50 then
               probeState := GoToRight;
             elsif distanceLeft > 0 and distanceLeft <= 50 then
               probeState := GoToLeft;
            else
               probeState := Probe;
            end if;
         end if;

        delay until clockStart + period;
      end loop;
   end ProbeThink;

   -- Sense (stolen shamelessly from Bendik)
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

      delay until rotateStart + totalAngleDuration;
   end Rotate;
end tasks;
