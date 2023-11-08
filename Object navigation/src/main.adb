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
   flag1           : Boolean     := False;
   flag2 : Boolean := False;
begin
   loop
      Distancer      := Ultraright.Read;
      Distancel      := Ultraleft.Read;
      Distancef      := Ultrafront.Read;
      distance_front := Integer (Distancef);
      if distance_front = 0 then
         distance_front := 400;
      end if;
      distance_right := Integer (Distancer);
      if distance_right = 0 then
         distance_right := 400;
      end if;
      distance_left  := Integer (Distancel);
      if distance_left = 0 then
         distance_left := 400;
      end if;

      --  Put_Line("left" & distance_left'Image & "front" & distance_front'Image & "right" & distance_right'Image);
      case counter is
         when 0 =>
            if distance_front < 10 and distance_left > 10 and --hinder in the front
              distance_right > 10
            then
               MotorDriver.Drive (MotorDriver.Rotating_Left);
               Delay_Ms (828);
               counter := 1;
            else
               MotorDriver.Drive (MotorDriver.Forward); --or just be in another state
            end if;
         when 1 =>
            if distance_right <= 30 and distance_right >= 13 and distance_left > 10 and --too far from the object, go right(15<right<25)
              distance_front > 10
            then
               MotorDriver.Drive (MotorDriver.Lateral_Right);
            elsif distance_right < 13 and distance_right >= 10 and distance_left > 10 and --correct distance from the object, go right(10<right<15)
              distance_front > 10
            then
               MotorDriver.Drive (MotorDriver.Forward);
               flag1 := True;
            elsif distance_front > 10 and distance_right < 10 and distance_left > 10 then --too close to the object, go left(0<right<10)
               MotorDriver.Drive (MotorDriver.Lateral_Left);
            elsif distance_front > 10 and distance_right > 30 and --finished going one line, everything larger than 25
              distance_left > 10 and flag1 = True
            then
               MotorDriver.Drive (MotorDriver.Forward);
               Delay_Ms (400);
               MotorDriver.Drive (MotorDriver.Rotating_Right);
               Delay_Ms (828);
               flag1    := False;
               counter := 2;

            end if;
         when 2 .. 5 =>
            if distance_right <= 30 and distance_right >= 13 and distance_left > 10 and --too far from the object go right(15<right<25)
              distance_front > 10
            then
               MotorDriver.Drive (MotorDriver.Lateral_Right);
            elsif distance_right < 13 and distance_right >= 10 and distance_left > 10 and --right distance, 10<=r<15
              distance_front > 10
            then
               MotorDriver.Drive (MotorDriver.Forward);
               flag2 := True;
            elsif distance_front > 10 and distance_right > 10 and --just go to the right place
              distance_left > 10 and flag2 = False
            then
               MotorDriver.Drive (MotorDriver.Forward);
            elsif distance_front > 10 and distance_right < 10 and distance_left > 10 then --too close to the object
               MotorDriver.Drive (MotorDriver.Lateral_Left);
            elsif distance_front > 10 and distance_right > 30 and --finished
              distance_left > 10 and flag2 = True
            then

               MotorDriver.Drive (MotorDriver.Forward);
               Delay_Ms (400);
               MotorDriver.Drive (MotorDriver.Rotating_Right);
               Delay_Ms (828);
               flag2    := False;
               counter := counter + 1;
            end if;
         when others =>
            MotorDriver.Drive (MotorDriver.Stop); --next state
      end case;
      --  delay(0.3);

   end loop;
end Main;
