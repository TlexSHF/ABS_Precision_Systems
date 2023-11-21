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
      period     : Time_Span := pollEchoPeriod;
   begin
      loop
         clockStart := Clock;
         
         -- displayStates;

         distanceFront := sensorFront.Read;
         distanceRight := sensorRight.Read;
         distanceLeft  := sensorLeft.Read;

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

   task body CheckLineTracker is
      clockStart : Time;
      period     : Time_Span := checkLineTrackerPeriod;
   begin
      loop
         clockStart := Clock;

         lineTrackerLeft   := digitalRead (15);
         lineTrackerMiddle := digitalRead (14);
         lineTrackerRight  := digitalRead (16);

         delay until clockStart + period;
      end loop;
   end CheckLineTracker;

   -- Think
   task body TrackLine is
      clockStart       : Time;
      period           : Time_Span               := Milliseconds (80);
      lineTrackerState : LineTrackerCombinations := None;
   begin
      loop
         clockStart := Clock;
         if (car = LineFollowing) then

            lineTrackerState := GetLineTrackerState;

            -- Set drive variable to correct drive state
            if distanceFront > 15 or distanceFront = 0 then
               case lineTrackerState is
                  when None =>
                     drive := Stop;
                     car   := Roaming;
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
               navState := Quadratic;
               car := ObjectNavigating;
            end if;
         end if;
         delay until clockStart + period;
      end loop;
   end TrackLine;

   task body ObjectNav is
      clockStart : Time;
      circleStart : Time;
      period     : Time_Span := thinkPeriod;
      counter    : Integer   := 0;
      flag       : Boolean   := False;
   begin
      loop
         clockStart := Clock;
         if car = ObjectNavigating then
            if navState = Quadratic then
               QuadraticNavigating(counter, flag);
            else 
               CircularNavigating(circleStart);
            end if;
         end if;  
         delay until clockStart + period;
      end loop;
   end ObjectNav;
   
   task body Roam is
      clockStart : Time;   
      period     : Time_Span := thinkPeriod;
      subtype RandAngle is Angle range 90 .. 170;

      -- Random Number Generator
      package Rand_Int is new Ada.Numerics.Discrete_Random (RandAngle);
      gen : Rand_Int.Generator;

      -- Times and Durations
      driveDuration : constant Time_Span := Seconds (3); -- 5
      driveStart    : Time;
      wantedAngle   : RandAngle          := 90;
      resetTimer    : Boolean            := True;
   begin
      Set_Analog_Period_Us (20_000);
      loop
         clockStart := Clock;
         if car = Roaming then

            if pollFlag then
               LookForObjects;
            end if;

            -- Changing the States in the FSM
            if GetLineTrackerState /= None then
               car := LineFollowing;
            elsif enableObjectDetect = True and probeState = Stop then
               navState := Circular;
               car := ObjectNavigating;
            end if;
            
            if probeState = Probe and previousProbeState /= Probe then
               -- resetting probe clock when probing begins
               previousProbeState := probeState;
               -- driveStart := Clock;
               resetTimer := True;
            end if;
            
            if resetTimer then
               driveStart := Clock;
               resetTimer := False;
            end if;

            if probeState = Stop then
               previousProbeState := probeState;

               if enableObjectDetect = False then
                  Rotate (90);
               else
                  drive := Stop;
               end if;

               driveStart := Clock;
            else

               drive := Forward;

               if probeState = Probe and Clock >= driveStart + driveDuration
               then
                  previousProbeState := probeState;
                  Rand_Int.Reset (gen);
                  wantedAngle := Rand_Int.Random (gen);
                  Rotate (wantedAngle);
                  --driveStart := Clock;
                  resetTimer := True;

               elsif enableObjectDetect = True then

                  if probeState = GoToRight and previousProbeState /= GoToRight
                  then
                     previousProbeState := probeState;
                     drive := Forward;
                     delay(0.5);
                     Rotate (90, True);
                     -- driveStart := Clock;
                     resetTimer := True;

                  elsif probeState = GoToLeft and previousProbeState /= GoToLeft
                  then
                     previousProbeState := probeState;
                     drive := Forward;
                     delay(0.5);
                     Rotate (90, False);
                     --driveStart := Clock;
                     resetTimer := True;
                  end if;
               end if;
            end if;
         else
            resetTimer := True;
         end if;
         delay until clockStart + period;
      end loop;
   end Roam;

   -- Act
   task body UpdateDirection is
      clockStart : Time;
      period     : Time_Span := updateDirectionPeriod;
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
     (PositionSensor : UltraSensor; dist : Distance_cm := 10)
      return Boolean
   is
      distance : Distance_cm;
   begin
      distance := (case PositionSensor is 
                      when F => distanceFront,  
                      when R => distanceRight,  
                      when L => distanceLeft);
      return distance < dist;
   end HinderFound;

   -- Procedures
   procedure Straighten (ultra : UltraSensor) is 
      type DistancePointer is access all Distance_cm;
      distance       : DistancePointer;
      distanceBefore : DistancePointer := new Distance_cm;
      finished       : Boolean := False;
      clockwise      : Boolean := True;
      changes        : Integer := 0;
   begin
      distance := (case ultra is
                      when F => distanceFront'Access,
                      when R => distanceRight'Access,
                      when L => distanceLeft'Access);
      drive := Rotating_Right;
      speed := (700, 700, 700, 700);
      loop
         exit when finished;
         distanceBefore.all := distance.all;
         delay until Clock + Milliseconds(20);
         if distanceBefore.all < distance.all then 
            drive := (case drive is
                         when Rotating_Right => Rotating_Left,
                         when Rotating_Left  => Rotating_Right,
                         when others         => Stop); 
            changes := changes + 1;
         end if;
         if changes > 10 then
            finished := true;
            speed := (4095, 4095, 4095, 4095);
            DisplayRT.Clear;  
            DisplayRT.Display ('9');   
         end if;  
      end loop;   
   end Straighten;   

   procedure QuadraticNavigating (counter : in out Integer; flag : in out Boolean) is
   begin
      case counter is
               when 0 =>
                  if (  HinderFound(F,15) and not HinderFound(L) and     
                        not HinderFound(R))     
                  --hinder in the front 
                  then     
                     Rotate(90,False); 
                     drive := Forward;
                     counter := 1;        
                  else
                     drive:= Forward;
            end if;
         when 1 =>
            if HinderFound(R,20) and not HinderFound(R,12) and not HinderFound(L) and      
                    not HinderFound(F) 
                      --too far from the object, go right
                  then
               drive := Lateral_Right;
                  elsif HinderFound(R,12) and not HinderFound(R,10) and not HinderFound(L)
                       --right distance    
                  then     
                     drive := Forward;
                     flag := True; 
                  elsif not HinderFound(R,20) and not HinderFound(L) and                        
                    not HinderFound(F) and flag = False 
                     --not reached the side yet 
                  then     
                     drive := Forward; 
                  elsif not HinderFound(F) and HinderFound(R,10) then
                     --too close to the object     
                     drive := Lateral_Left;
                     --Rotate(2, False);
                  elsif not HinderFound(F) and not HinderFound(R,20) and 
              --finished
                 flag = true
                  then 
                        drive := Forward;
                        delay(0.5);
                          Rotate(90);
                        flag := False;
                        counter := 2; 
                  else
                     drive := Forward;
                  end if;
            
               when 2 .. 4 =>
                  if GetLineTrackerState /= None then
                        counter := 0;
                     car := LineFollowing;
                     end if;
                  if HinderFound(R,20) and not HinderFound(R,12) and not HinderFound(L) and      
                    not HinderFound(F) 
                      --too far from the object, go right
                  then
               drive := Lateral_Right;
               --Rotate(2, True);
                  elsif HinderFound(R,12) and not HinderFound(R,10) and not HinderFound(L) and 
                    not HinderFound(F)
                       --right distance    
                  then     
                     drive := Forward;
                     flag := True; 
                  elsif not HinderFound(R,20) and not HinderFound(L) and                        
                    not HinderFound(F) and flag = False 
                     --not reached the side yet 
                  then     
                     drive := Forward; 
                  elsif not HinderFound(F) and HinderFound(R,10) then
                     --too close to the object     
                     drive := Lateral_Left;
                  elsif not HinderFound(F) and not HinderFound(R,20) and 
              --finished
                 flag = true
                  then  
                      if counter = 4 then                 
                        Rotate(90,False);                     
                        flag := False;
                        counter := counter + 1;
                     else
                        drive := Forward;
                        delay(0.5);
                          Rotate(90);
                        flag := False;
                        counter := counter + 1;
                     end if; 
                  else
                     drive := Forward;
                  end if;
               when others =>       
                  drive := Stop;   --next state     
                  counter := 0;
                  car := Roaming;
      end case;   
   end QuadraticNavigating;
   
   procedure CircularNavigating(circleStart : in out Time) is
      clockStart : Time := Clock;
   begin
      case CircStateVariable is
         when Rotating =>
            if HinderFound(F,10) then
               Rotate(90,False);
               drive := Forward;
               delay(0.4);
               circleStart := Clock;
               CircStateVariable := CircNavigating;
            end if;
         when CircNavigating =>
            if GetLineTrackerState /= None then
               CircStateVariable := Rotating;
               car := LineFollowing;
            elsif Clock - circleStart > Seconds(12) then 
               -- Time out
               Rotate(45, False);
               drive := Forward;
               delay(1.0);
               CircStateVariable := Rotating;
               car := Roaming;
            else
               
               if not HinderFound(R,14) and not HinderFound(L) and      
                 not HinderFound(F) then 
                  --too far from the object, go right
                  drive := Lateral_Right;
               elsif HinderFound(R,14) and not HinderFound(R,10) and 
                 not HinderFound(L) and not HinderFound(F) then
                  --right distance   
                  drive := Forward;
               elsif not HinderFound(F) and HinderFound(R,10) then
                  --too close to the object     
                  drive := Lateral_Left;
               end if;
             end if;
         end case;
   end CircularNavigating;
   
   procedure Rotate (wantedAngle : Angle; clockwise : Boolean := True) is
      angleDurationMicro : constant Integer := 9_200;
      totalAngleDuration : Time_Span        :=
        Microseconds (Integer (wantedAngle) * angleDurationMicro);
      rotateStart        : Time;
   begin
      rotateStart := Clock;
      drive := (if clockwise then Rotating_Right else Rotating_Left);
      delay until rotateStart + totalAngleDuration;
   end Rotate;
   
   procedure LookForObjects is
      dist : Distance_cm := 20;
   begin
      if distanceFront <= 10 then
         probeState := Stop;
      elsif distanceFront <= dist then
         probeState := GoToFront;
      elsif distanceRight <= dist then
         probeState := GoToRight;
      elsif distanceLeft <= dist then
         probeState := GoToLeft;
      else
         probeState := Probe;
      end if;
   end LookForObjects;
   
   procedure displayStates is
   begin
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
      end case;
   end displayStates;

end Tasks;
