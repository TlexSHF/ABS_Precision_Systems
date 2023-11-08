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
   flag           : Boolean     := False;
begin
   loop
      Distancer      := Ultraright.Read;
      Distancel      := Ultraleft.Read;
      Distancef      := Ultrafront.Read;
      distance_front := Integer (Distancef);
      distance_right := Integer (Distancer);
      distance_left  := Integer (Distancel);

      case counter is
         when 0 =>
            if distance_front < 10 and distance_left > 10 and
              distance_right > 10
            then
               MotorDriver.Drive (MotorDriver.Rotating_Left);
               Delay_Ms (800);
               counter := 1;
            else
               MotorDriver.Drive (MotorDriver.Forward);
            end if;
         when 1 =>
            if distance_right < 25 and distance_left > 10 and
              distance_front > 10
            then
               MotorDriver.Drive (MotorDriver.Forward);
            elsif distance_front > 10 and distance_right < 10 then
               MotorDriver.Drive (MotorDriver.Left);
            elsif distance_front > 10 and distance_right > 25 and
              distance_left > 10
            then
               MotorDriver.Drive (MotorDriver.Forward);
               Delay_Ms (400);
               counter := 2;
            end if;
         when 2 .. 5 =>
            if distance_right < 25 and distance_left > 10 and
              distance_front > 10
            then
               MotorDriver.Drive (MotorDriver.Forward);
               flag := True;
            elsif distance_front > 10 and distance_right > 10 and
              distance_left > 10 and flag = False
            then
               MotorDriver.Drive (MotorDriver.Forward);
            elsif distance_front > 10 and distance_right < 10 then
               MotorDriver.Drive (MotorDriver.Left);
            elsif distance_front > 10 and distance_right > 25 and
              distance_left > 10 and flag = True
            then
               MotorDriver.Drive (MotorDriver.Forward);
               Delay_Ms (400);
               MotorDriver.Drive (MotorDriver.Rotating_Right);
               Delay_Ms (650);
               flag    := False;
               counter := counter + 1;
            end if;
         when others =>
            MotorDriver.Drive (MotorDriver.Forward);
      end case;

   end loop;
end Main;
