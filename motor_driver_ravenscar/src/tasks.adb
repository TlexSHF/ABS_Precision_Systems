with Ada.Real_Time;          use Ada.Real_Time;
with Ada.Numerics.Discrete_Random;
with MicroBit;               use MicroBit;
with MicroBit.Console;       use MicroBit.Console;
with MicroBit.MotorDriver;
with MicroBit.Ultrasonic;
with MicroBit.IOsForTasking; use MicroBit.IOsForTasking;
with MicroBit.DisplayRT;
package body Tasks is

   -- Sense
   task body PollEcho is
      clockStart : Time;
      period     : Time_Span := Milliseconds (50);
   begin
      loop
         clockStart := Clock;

         DisplayRT.Clear;
         case car is
            when Roaming =>
               DisplayRT.Display ('R');
            when LineFollowing =>
               DisplayRT.Display ('L');
            when ObjectNavigating =>
               DisplayRT.Display ('O');
            when others =>
               DisplayRT.Display ('X');
               exit;
         end case;

         distanceFront :=
           sensorFront
             .Read; --Integer(sensorFront.Read); -- Hvorfor bruke Integers?
         distanceRight := sensorRight.Read; --Integer(sensorRight.Read);
         distanceLeft  := sensorLeft.Read; --Integer(sensorLeft.Read);

         if distanceFront = 0 then
            distanceFront := 400;
         end if;
         if distanceRight = 0 then
            distanceRight := 400;
         end if;
         if distanceLeft = 0 then
            distanceLeft := 400;
         end if;

         pollFlag := True;

         delay until clockStart + period;
      end loop;
   end PollEcho;

   task body CheckSensor is
      clockStart : Time;
      period     : Time_Span := Milliseconds (5);
   begin
      loop
         clockStart := Clock;

         lineTrackerLeft   := digitalRead (15);
         lineTrackerMiddle := digitalRead (14);
         lineTrackerRight  := digitalRead (16);

         delay until clockStart + period;
      end loop;
   end CheckSensor;

   -- Think
   task body TrackLine is
      clockStart       : Time;
      period           : Time_Span               := Milliseconds (5);
      -- type LineTrackerCombinations is (None, L, M, R, L_M, M_R, L_R, L_M_R);  -- 3 trackers, L = Left tracker
      lineTrackerState : LineTrackerCombinations :=
        None;                     --             M = Middle tracker
   begin                                                                      --             R = Right tracker
      loop
         clockStart := Clock;
         if (car = LineFollowing) then -- Precondition

            lineTrackerState := GetLineTrackerState;

            -- Set drive variable to correct drive state
            if distanceFront > 15 or distanceFront = 0 then
               case lineTrackerState is
                  when None =>
                     drive := Stop;
                     car   := Roaming; -- Added change of state here!
                     -- This is the one causing the problem where car wont stop roaming.
                  when L =>
                     drive := Curve_Forward_Left;
                  when M =>
                     drive := Forward;
                  when R =>
                     drive := Curve_Forward_Right;
                  when L_M =>
                     drive := Curve_Forward_Left;
                  when M_R =>
                     drive := Curve_Forward_Right;
                  when L_M_R =>
                     drive := Rotating_Left;
                     delay until clockStart + Milliseconds (100);
                     clockStart := Clock;
                  when others =>
                     null;
               end case;
            else
               drive := Stop;
               delay (0.2);
               car := ObjectNavigating;
            end if;
         end if;
         delay until clockStart + period;
      end loop;
   end TrackLine;

   task body ObjectNav is
      clockStart : Time;
      period     : Time_Span := Milliseconds (5);
      counter    : Integer   := 0;
      flag       : Boolean   := False;
   begin
      loop
         clockStart := Clock;
         if car = ObjectNavigating then   -- Precondition
            case counter is

               when 0 =>
                  if HinderFound (F, 15) and not HinderFound (R) and
                    not HinderFound (L)  --hinder in the front
                  then
                     Rotate (90, False);
                     drive := Forward;
                     delay (0.4);
                     counter := 1;
                  end if;

                  drive := Forward;

               when 1 .. 4 =>

                  if GetLineTrackerState /= None then --line found
                     counter := 0;
                     car     := LineFollowing;
                  else
                     drive := Forward;
                     
                     if not HinderFound (F, 50) and not HinderFound (R, 50) and
                       not HinderFound (L, 50) --finished
                     then
                        if counter = 4 then
                           drive := Forward;
                           delay (0.4);
                           Rotate (90, False);
                           counter := counter + 1;
                        else
                           drive := Forward;
                           delay (0.4);
                           Rotate (90);
                           drive := Forward;
                           delay (0.4);
                           counter := counter + 1;
                        end if;
                    elsif HinderFound (F, 15) and not HinderFound (R) and
                       not HinderFound (L) then --car
                        Rotate (90);
                        car := Roaming;
                     elsif HinderFound (F) and HinderFound (L, 10) and
                       not HinderFound (R)
                     then  --if car has a hinder front and left
                        Rotate (90);
                        car := Roaming;
                     elsif HinderFound (F) and not HinderFound (L) and
                       HinderFound (R, 15)
                     then  --if car has a hinder front and right
                        Rotate (90, False);
                        car := Roaming;             
                     elsif not HinderFound (R, 15) and HinderFound (R, 17) and
                       not HinderFound(L) and not HinderFound (F)          
                     then --too far from the object, go right
                        drive := Lateral_Right;
                    
                     elsif not HinderFound (F) and HinderFound (R) and
                       not HinderFound (L)
                     then --too close to the object
                        drive := Lateral_Left;
                     end if;
                  end if;
               when others =>
                  drive := Stop;   --next state
                  delay (0.2);
                  counter := 0;
                  car     := Roaming;

            end case;
         end if;
         counter:=0;
         delay until clockStart + period;
      end loop;
   end ObjectNav;

   task body ProbeThink is
      clockStart : Time;
      period     : Time_Span := Milliseconds (10);
   begin
      loop
         clockStart := Clock;

         if car = Roaming then

            --  DisplayRT.Clear;
            --  case probeState is
            --  when Probe => DisplayRT.Display('P');
            --  when GoToFront => DisplayRT.Display('F');
            --  when GoToLeft => DisplayRT.Display('L');
            --  when GoToRight => DisplayRT.Display('R');
            --  when Stop => DisplayRT.Display('S');
            --  when others => DisplayRT.Display('X'); exit;
            --  end case;

            if pollFlag then

               if distanceFront <= 15 then
                  probeState := Stop;
               elsif distanceFront <= 30 then
                  probeState := GoToFront;
               elsif distanceRight <= 30 then
                  probeState := GoToRight;
               elsif distanceLeft <= 30 then
                  probeState := GoToLeft;
               else
                  probeState := Probe;
               end if;
            end if;

            if GetLineTrackerState /= None then
               car := LineFollowing;
            elsif detectObject = True and probeState = Stop then
               car := ObjectNavigating;
            end if;
         end if;

         delay until clockStart + period;
      end loop;
   end ProbeThink;

   -- Act
   task body UpdateDirection is
      clockStart : Time;
      period     : Time_Span := Milliseconds (5);
   begin
      Set_Analog_Period_Us (20_000);
      loop
         clockStart := Clock;

         case drive is
            when Forward =>
               MotorDriver.Drive (MotorDriver.Forward);
            when Backward =>
               MotorDriver.Drive (MotorDriver.Backward);
            when Left =>
               MotorDriver.Drive (MotorDriver.Left);
            when Right =>
               MotorDriver.Drive (MotorDriver.Right);
            when Forward_Left =>
               MotorDriver.Drive (MotorDriver.Forward_Left);
            when Forward_Right =>
               MotorDriver.Drive (MotorDriver.Forward_Right);
            when Backward_Left =>
               MotorDriver.Drive (MotorDriver.Backward_Left);
            when Backward_Right =>
               MotorDriver.Drive (MotorDriver.Backward_Right);
            when Lateral_Left =>
               MotorDriver.Drive (MotorDriver.Lateral_Left);
            when Lateral_Right =>
               MotorDriver.Drive (MotorDriver.Lateral_Right);
            when Rotating_Left =>
               MotorDriver.Drive (MotorDriver.Rotating_Left);
            when Rotating_Right =>
               MotorDriver.Drive (MotorDriver.Rotating_Right);
            when Curve_Forward_Left =>
               MotorDriver.Drive (MotorDriver.Forward, (4_095, 4_095, 0, 0));
            when Curve_Forward_Right =>
               MotorDriver.Drive (MotorDriver.Forward, (0, 0, 4_095, 4_095));
            when Stop =>
               MotorDriver.Drive (MotorDriver.Stop);
         end case;

         delay until clockStart + period;
      end loop;
   end UpdateDirection;

   task body Fare is
      subtype RandAngle is Angle range 90 .. 170;

      -- Random Number Generator
      package Rand_Int is new Ada.Numerics.Discrete_Random (RandAngle);
      gen : Rand_Int.Generator;

      -- Times and Durations
      driveDuration : constant Time_Span := Seconds (3);
      driveStart    : Time;
      wantedAngle   : RandAngle          := 90;
   begin
      Set_Analog_Period_Us (20_000);
      driveStart := Clock;
      loop
         if car = Roaming then

            -- NOTE: There is an unnecessary amount of driveStart := Clock
            -- but I just need to figure out if it works without them

            previousProbeState := probeState;
            if probeState = Probe and previousProbeState /= Probe then
               -- resetting the Fare clock when probing begins
               driveStart := Clock;
            end if;

            if probeState = Stop then

               if detectObject = False then
                  Rotate (90);
               else
                  drive := Stop;
               end if;

               driveStart := Clock;
            else
               --if probeState /= Stop then

               drive := Forward;
               if distanceLeft < 10 then
                  Rotate (10, True);
               elsif distanceRight < 10 then
                  Rotate (10, False);
               end if;

               if probeState = Probe and Clock >= driveStart + driveDuration
               then
                  Rand_Int.Reset (gen);
                  wantedAngle := Rand_Int.Random (gen);
                  Rotate (wantedAngle); -- Worst case: 1 656 ms
                  driveStart := Clock;

               elsif detectObject = True then

                  if probeState = GoToRight and previousProbeState /= GoToRight
                  then
                     Rotate (90, True); -- Worst case: 1 656 ms
                     driveStart := Clock;

                  elsif probeState = GoToLeft and
                    previousProbeState /= GoToLeft
                  then
                     Rotate (90, False); -- Worst case: 1 656 ms
                     driveStart := Clock;
                  end if;
               end if;

            end if;
         end if;
      end loop;
   end Fare;

   -- Functions
   function GetLineTrackerState return LineTrackerCombinations is
      lineTrackerState : LineTrackerCombinations := None;
   begin
      -- Exits immediately if no tracker
      if not (lineTrackerLeft or lineTrackerMiddle or lineTrackerRight) then
         return None;
      end if;

      -- Checks for various combinations of trackers
      if lineTrackerLeft and not lineTrackerMiddle and not lineTrackerRight
      then
         lineTrackerState := L;
      elsif not lineTrackerLeft and lineTrackerMiddle and not lineTrackerRight
      then
         lineTrackerState := M;
      elsif not lineTrackerLeft and not lineTrackerMiddle and lineTrackerRight
      then
         lineTrackerState := R;
      elsif lineTrackerLeft and lineTrackerMiddle and not lineTrackerRight then
         lineTrackerState := L_M;
      elsif not lineTrackerLeft and lineTrackerMiddle and lineTrackerRight then
         lineTrackerState := M_R;
      elsif lineTrackerLeft and lineTrackerMiddle and lineTrackerRight then
         lineTrackerState := L_M_R;
      else
         lineTrackerState := None;
      end if;

      return lineTrackerState;
   end GetLineTrackerState;

   function HinderFound
     (PositionSensor : UltrasonicCombination; dist : Distance_cm := 10)
      return Boolean
   is -- make type for PositionSensor
      distance : Distance_cm;
   begin

      distance :=
        (case PositionSensor is when F => distanceFront,
           when R => distanceRight, when L => distanceLeft);
      return distance < dist;

      --
      --  if PositionSensor = "F" then
      --     if Integer(distanceFront) < dist then     -- case?
      --        return True;
      --     else
      --        return False;
      --        end if;
      --  elsif PositionSensor = "R" then
      --     if Integer(distanceRight) < dist then
      --        return True;
      --     else
      --        return False;
      --     end if;
      --  elsif Integer(distanceLeft) < dist then
      --        return True;
      --  end if;

      --  return False;
   end HinderFound;

   -- Procedures
   procedure Rotate (wantedAngle : Angle; clockwise : Boolean := True) is
      angleDurationMicro : constant Integer := 9_200;
      totalAngleDuration : Time_Span        :=
        Microseconds (Integer (wantedAngle) * angleDurationMicro);
      rotateStart        : Time;

   begin
      rotateStart := Clock;

      if clockwise then
         drive := Rotating_Right;
      else
         drive := Rotating_Left;
      end if;

      delay until rotateStart + totalAngleDuration;
   end Rotate;

   -- Maybe this procedure is not as useful as first thought
   --  procedure AvoidObstacle is
   --  begin
   --
   --     if distanceFront < 10 then
   --        Rotate(180, true);
   --     elsif distanceLeft < 10 then
   --        Rotate(10, true);
   --     elsif distanceRight < 10 then
   --        Rotate(10, false);
   --     end if;
   --
   --  end AvoidObstacle;

end Tasks;
