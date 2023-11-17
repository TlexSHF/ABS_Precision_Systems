with Ada.Real_Time;          use Ada.Real_Time;
with MicroBit.TimeHighspeed; use MicroBit.TimeHighspeed;
with Ada.Numerics.Discrete_Random;
with MicroBit;               use MicroBit;
with MicroBit.Console;       use MicroBit.Console;
with MicroBit.MotorDriver;
--  with MicroBit.Ultrasonic;
with MicroBit.IOsForTasking; use MicroBit.IOsForTasking;
with MicroBit.DisplayRT;
package body Tasks is

   -- Sense
   task body PollEcho is
      clockStart : Time;
      period     : Time_Span := Milliseconds (9);
   begin
      loop
         clockStart := Clock;

         digitalWrite (12, True);
         Delay_Us (5);
         digitalWrite (12, False);
         delay until Clock + Milliseconds (9);

         -- Timeout
         if GPIO_Periph.PIN_CNF
             (ultraSensorArray (Integer (sensorArrIndex)).EchoPin.Pin)
             .SENSE =
           Low
         then
            GPIO_Periph.PIN_CNF
              (ultraSensorArray (Integer (sensorArrIndex)).EchoPin.Pin)
              .SENSE :=
              High;
            GPIO_Periph.PIN_CNF
              (ultraSensorArray (Integer (sensorArrIndex)).EchoPin.Pin)
              .PULL  :=
              Pulldown;
         end if;

         ultraSensorArray (Integer (sensorArrIndex)).echoTime :=
           ultraSensorArray (Integer (sensorArrIndex)).echoTime * 16_400;

         distanceFront :=
           ultraSensorArray (Integer (sensorArrIndex)).echoTime /
           Microseconds (1_000_000);

         --  sensorArrIndex := sensorArrIndex + 1;
         --  
         --  digitalWrite (13, True);
         --  Delay_Us (5);
         --  digitalWrite (13, False);
         --  delay until Clock + Milliseconds (9);
         --  
         --  -- Timeout
         --  if GPIO_Periph.PIN_CNF
         --      (ultraSensorArray (Integer (sensorArrIndex)).EchoPin.Pin)
         --      .SENSE =
         --    Low
         --  then
         --     GPIO_Periph.PIN_CNF
         --       (ultraSensorArray (Integer (sensorArrIndex)).EchoPin.Pin)
         --       .SENSE :=
         --       High;
         --     GPIO_Periph.PIN_CNF
         --       (ultraSensorArray (Integer (sensorArrIndex)).EchoPin.Pin)
         --       .PULL  :=
         --       Pulldown;
         --  end if;
         --  
         --  ultraSensorArray (Integer (sensorArrIndex)).echoTime :=
         --    ultraSensorArray (Integer (sensorArrIndex)).echoTime * 16_400;
         --  
         --  distanceLeft :=
         --    ultraSensorArray (Integer (sensorArrIndex)).echoTime /
         --    Microseconds (1_000_000);
         --  
         --  sensorArrIndex := sensorArrIndex + 1;
         --  
         --  digitalWrite (8, True);
         --  Delay_Us (5);
         --  digitalWrite (8, False);
         --  delay until Clock + Milliseconds (9);
         --  
         --  -- Timeout
         --  if GPIO_Periph.PIN_CNF
         --      (ultraSensorArray (Integer (sensorArrIndex)).EchoPin.Pin)
         --      .SENSE =
         --    Low
         --  then
         --     GPIO_Periph.PIN_CNF
         --       (ultraSensorArray (Integer (sensorArrIndex)).EchoPin.Pin)
         --       .SENSE :=
         --       High;
         --     GPIO_Periph.PIN_CNF
         --       (ultraSensorArray (Integer (sensorArrIndex)).EchoPin.Pin)
         --       .PULL  :=
         --       Pulldown;
         --  end if;
         --  
         --  ultraSensorArray (Integer (sensorArrIndex)).echoTime :=
         --    ultraSensorArray (Integer (sensorArrIndex)).echoTime * 16_400;
         --  
         --  distanceRight :=
         --    ultraSensorArray (Integer (sensorArrIndex)).echoTime /
         --    Microseconds (1_000_000);
         --  
         --  sensorArrIndex := sensorArrIndex + 1;

         Put_Line
           (ultraSensorArray(0).echoTime'Image & ", " & distanceLeft'Image & ", " &
            distanceRight'Image);

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
            if navState = Quadratic then
               QuadraticNavigating (counter, flag);
            else
               CircularNavigating;
            end if;
         end if;
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
               MotorDriver.Drive (MotorDriver.Forward, speed);
            when Backward =>
               MotorDriver.Drive (MotorDriver.Backward, speed);
            when Left =>
               MotorDriver.Drive (MotorDriver.Left, speed);
            when Right =>
               MotorDriver.Drive (MotorDriver.Right, speed);
            when Forward_Left =>
               MotorDriver.Drive (MotorDriver.Forward_Left, speed);
            when Forward_Right =>
               MotorDriver.Drive (MotorDriver.Forward_Right, speed);
            when Backward_Left =>
               MotorDriver.Drive (MotorDriver.Backward_Left, speed);
            when Backward_Right =>
               MotorDriver.Drive (MotorDriver.Backward_Right, speed);
            when Lateral_Left =>
               MotorDriver.Drive (MotorDriver.Lateral_Left, speed);
            when Lateral_Right =>
               MotorDriver.Drive (MotorDriver.Lateral_Right, speed);
            when Rotating_Left =>
               MotorDriver.Drive (MotorDriver.Rotating_Left, speed);
            when Rotating_Right =>
               MotorDriver.Drive (MotorDriver.Rotating_Right, speed);
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
     (PositionSensor : UltraSensor; dist : Integer := 10) return Boolean
   is -- make type for PositionSensor
      distance : Integer;
   begin

      distance :=
        (case PositionSensor is when F => distanceFront,
           when R => distanceRight, when L => distanceLeft);

      return distance < dist;

   end HinderFound;

   -- Procedures
   procedure Straighten (ultra : UltraSensor) is
      type DistancePointer is access all Integer;
      distance       : DistancePointer;
      distanceBefore : DistancePointer := new Integer;
      finished       : Boolean         := False;
      clockwise      : Boolean         := True;
      changes        : Integer         := 8;
      prevDrive      : DriveState      := Rotating_Right;
   begin
      distance           :=
        (case ultra is when F => distanceFront'Access,
           when R => distanceRight'Access, when L => distanceLeft'Access);
      distanceBefore.all := distance.all;
      speed              := (1_024, 1_024, 1_024, 1_024);
      drive              := Rotating_Right;
      delay until Clock + Milliseconds (100);
      loop
         exit when finished;
         drive := Stop;
         if distanceBefore.all < distance.all then
            drive :=
              (case prevDrive is when Rotating_Right => Rotating_Left,
                 when Rotating_Left => Rotating_Right, when others => Stop);
            if drive /= Stop then
               prevDrive := drive;
            end if;
            changes := changes + 1;
         else
            changes := changes - 1;
         end if;
         distanceBefore.all := distance.all;
         delay until Clock + Milliseconds (100);

         if changes > 10 or changes < 0 then
            finished := True;
            speed    := (4_095, 4_095, 4_095, 4_095);
            DisplayRT.Clear;
            DisplayRT.Display ('9');
         end if;
      end loop;
   end Straighten;

   procedure QuadraticNavigating
     (counter : in out Integer; flag : in out Boolean)
   is
   begin
      case counter is
         when 0 =>
            if
              (distanceFront < 15 and distanceLeft > 10 and distanceRight > 10)
               --hinder in the front

            then
               Straighten (F);
               Rotate (90, False);
               drive   := Forward;
               counter := 1;
            else
               --or just be in another state
               drive :=
                 Forward; -- Added State here, but unsure if this was the correct place !!
            end if;
         when 1 .. 4 =>
            if (lineTrackerLeft or lineTrackerMiddle or lineTrackerRight) then
               counter := 0;
               car     := LineFollowing;
            elsif distanceRight <= 20 and distanceRight > 17 and
              distanceLeft > 10 and distanceFront > 10
               --too far from the object, go right

            then
               drive := Lateral_Right;
            elsif distanceRight <= 17 and distanceRight >= 15 and
              distanceLeft > 10 and distanceFront > 10
               --right distance

            then
               drive := Forward;
               flag  := True;
            elsif distanceRight >= 20 and distanceLeft > 10 and
              distanceFront > 10 and flag = False
               --not reached the side yet

            then
               drive := Forward;
            elsif distanceFront > 10 and distanceRight < 15 and
              distanceLeft > 10
            then
               --too close to the object
               drive := Lateral_Left;
            elsif distanceFront > 30 and distanceRight > 30 and
               --finished

              distanceLeft > 30 and flag = True
            then
               if counter = 4 then
                  Rotate (90, False);
                  flag    := False;
                  counter := counter + 1;
               else
                  drive := Forward;
                  delay (0.4);
                  Rotate (90);
                  flag    := False;
                  counter := counter + 1;
               end if;
            else
               drive := Forward;
            end if;
         when others =>
            drive   := Stop;   --next state
            counter := 0;
            car     := Roaming;
      end case;
   end QuadraticNavigating;

   procedure CircularNavigating is
   begin
      null;
   end CircularNavigating;

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

   protected body Receiver is

      procedure My_ISR is
         latchPort0 : LATCH_Register;
      begin

         nRF.Events.Disable_Interrupt (nRF.Events.GPIOTE_PORT);

         latchPort0 := GPIO_Periph.LATCH;

         GPIO_Periph.LATCH := GPIO_Periph.LATCH;

         if latchPort0.Arr
             (ultraSensorArray (Integer (sensorArrIndex)).EchoPin.Pin) =
           Latched
         then
            if GPIO_Periph.IN_k.Arr
                (ultraSensorArray (Integer (sensorArrIndex)).EchoPin.Pin) =
              High
            then
               ultraSensorArray (Integer (sensorArrIndex)).RisingTime := Clock;
               GPIO_Periph.PIN_CNF
                 (ultraSensorArray (Integer (sensorArrIndex)).EchoPin.Pin)
                 .SENSE                                               :=
                 Low;
               GPIO_Periph.PIN_CNF
                 (ultraSensorArray (Integer (sensorArrIndex)).EchoPin.Pin)
                 .PULL                                                :=
                 Pullup;
            else
               ultraSensorArray (Integer (sensorArrIndex)).echoTime :=
                 Clock -
                 ultraSensorArray (Integer (sensorArrIndex)).RisingTime;
               GPIO_Periph.PIN_CNF
                 (ultraSensorArray (Integer (sensorArrIndex)).EchoPin.Pin)
                 .SENSE                                             :=
                 High;
               GPIO_Periph.PIN_CNF
                 (ultraSensorArray (Integer (sensorArrIndex)).EchoPin.Pin)
                 .PULL                                              :=
                 Pulldown;
            end if;
         end if;
         nRF.Events.Clear (nRF.Events.GPIOTE_PORT);
         nRF.Events.Enable_Interrupt (nRF.Events.GPIOTE_PORT);
      end My_ISR;

   end Receiver;

begin
   nRF.Events.Disable_Interrupt (nRF.Events.GPIOTE_PORT);

   for sensor of ultraSensorArray loop
      sensor.EchoPin.Configure_IO (confRising);
   end loop;

   --  ultraFront.EchoPin.Configure_IO (confRising);

   GPIO_Periph.DETECTMODE.DETECTMODE := NRF_SVD.GPIO.Default;

   nRF.Events.Clear
     (nRF.Events.GPIOTE_PORT); --clear any prior events of GPIOTE_PORT
   nRF.Events.Enable_Interrupt
     (nRF.Events.GPIOTE_PORT); --enable interrupt of event
   nRF.Interrupts.Enable (nRF.Interrupts.GPIOTE_Interrupt);

   for sensor of ultraSensorArray loop
      sensor.EchoPin.Configure_IO (confRising);
   end loop;

   null;

end Tasks;
