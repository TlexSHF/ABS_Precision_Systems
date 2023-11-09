with MicroBit.Ultrasonic;
with MicroBit.Console; use MicroBit.Console;
use MicroBit;
with MicroBit.Types;        use MicroBit.Types;
with MicroBit.MotorDriver;
with MicroBit.TimeWithRTC1; use MicroBit.TimeWithRTC1;

procedure Main is
   package Ultrafront is new Ultrasonic (MB_P12, MB_P0);
   package Ultraright is new Ultrasonic (MB_P13, MB_P1);
   package Ultraleft is new Ultrasonic (MB_P8, MB_P2);
   Distancef      : Distance_cm := 0;
   Distancer      : Distance_cm := 0;
   Distancel      : Distance_cm := 0;
   distance_front : Integer     := 0;
   distance_right : Integer     := 0;
   distance_left  : Integer     := 0;
   counter        : Integer     := 0;
   flag         : Boolean     := False;
begin
   loop
      Distancer      := Ultraright.Read;
      Distancel      := Ultraleft.Read;
      Distancef      := Ultrafront.Read;
      if Distancef = 0 then
         Distancef := 400;
      end if;
      if distance_right = 0 then
         distance_right := 400;
      end if;
      if distance_left = 0 then
         distance_left := 400;
      end if;

      --  Put_Line("left" & distance_left'Image & "front" & distance_front'Image & "right" & distance_right'Image);
      case counter is
         when 0 =>
            if (Distancef < 10 and distance_left > 10 and --hinder in the front
              distance_right > 10)
            then
               MotorDriver.Drive (MotorDriver.Rotating_Left);
               Delay_Ms (828);
               counter := 1;
            elsif (distance_front > 10 and distance_left > 10 and --hinder in the right
              distance_right < 20) then
               counter := 1;
            elsif (distance_front > 10 and distance_left < 20 and --hinder in the left
                     distance_right > 10) then
               MotorDriver.Drive (MotorDriver.Forward);
               Delay_Ms (400);
               MotorDriver.Drive (MotorDriver.Rotating_Right);
               Delay_Ms (1800);
               counter := 1;
            else
               MotorDriver.Drive (MotorDriver.Forward); --or just be in another state
            end if;
         when 1 .. 4 =>
            if distance_right < 20 and distance_right > 13 and distance_left > 10 and --too far from the object, go right
              distance_front > 10
            then
               MotorDriver.Drive (MotorDriver.Lateral_Right);
            elsif distance_right < 13 and distance_right >= 10 and distance_left > 10 and --right distance
              distance_front > 10
            then
               MotorDriver.Drive (MotorDriver.Forward);
               flag := True;
            elsif distance_front > 10 and distance_right > 10 and --just go to the right place
              distance_left > 10 and flag = False
            then
               MotorDriver.Drive (MotorDriver.Forward);
            elsif distance_front > 10 and distance_right < 10 and distance_left > 10 then --too close to the object
               MotorDriver.Drive (MotorDriver.Lateral_Left);
            elsif distance_front > 10 and distance_right > 20 and --finished
              distance_left > 10 and flag = True
            then
               MotorDriver.Drive (MotorDriver.Forward);
               Delay_Ms (400);
               MotorDriver.Drive (MotorDriver.Rotating_Right);
               Delay_Ms (828);
               flag    := False;
               counter := counter + 1;
            end if;
         when others =>
            MotorDriver.Drive (MotorDriver.Stop); --next state
      end case;
   end loop;
end Main;
