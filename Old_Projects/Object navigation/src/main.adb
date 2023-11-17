with MicroBit.Ultrasonic;
with MicroBit.Console; use MicroBit.Console;
use MicroBit;
with MicroBit.Types;        use MicroBit.Types;
with MicroBit.MotorDriver;
with MicroBit.TimeWithRTC1; use MicroBit.TimeWithRTC1;
with MicroBit.DisplayRT;
--with tasks;
procedure Main is
   package Ultrafront is new Ultrasonic (MB_P12, MB_P0);
   package Ultraright is new Ultrasonic (MB_P13, MB_P1);
   package Ultraleft is new Ultrasonic (MB_P8, MB_P2);
   DistanceFront      : Distance_cm := 0;
   DistanceRight      : Distance_cm := 0;
   DistanceLeft      : Distance_cm := 0;

    counter        : Integer     := 0;
    flag         : Boolean     := True;
begin
   loop
   DistanceRight     := Ultraright.Read;
   DistanceLeft      := Ultraleft.Read;
   DistanceFront      := Ultrafront.Read;
   if DistanceFront = 0 then
      DistanceFront := 400;
   end if;
   if distanceRight = 0 then
      distanceRight := 400;
   end if;
   if distanceLeft = 0 then
      distanceLeft := 400;
   end if;

      --Put_Line(DistanceLeft'Image & DistanceFront'Image & DistanceRight'Image);
        -- Precondition
            case counter is
               when 0 =>
                  if (distanceFront < 10 and distanceLeft > 10 and
                        distanceRight > 10)
                  --hinder in the front
            then
                DisplayRT.Clear;
                      DisplayRT.Display('F');

                     counter := 1;

                  else
                     --or just be in another state
                     DisplayRT.Clear;
                      DisplayRT.Display('N');
                  end if;

               when 1 .. 4 =>

                  if distanceRight <= 17 and distanceRight > 15 and distanceLeft > 10 and
              distanceFront > 10

                      --too far from the object, go right
                  then
                      DisplayRT.Clear;
                      DisplayRT.Display('R');
                  elsif distanceRight < 17 and distanceRight >= 10 and distanceLeft > 10 and
                    distanceFront > 10
                       --right distance
                  then
                     DisplayRT.Clear;
                      DisplayRT.Display('F');
                     flag := True;
                  elsif distanceRight >= 25 and distanceLeft > 10 and
                    distanceFront > 10 and flag = False
                     --not reached the side yet
                  then
                      DisplayRT.Clear;
                      DisplayRT.Display('Y');
                  elsif distanceFront > 10 and distanceRight < 10 and distanceLeft > 10 then
                     --too close to the object
                     DisplayRT.Clear;
                      DisplayRT.Display('L');
                  elsif distanceFront > 10 and distanceRight > 25 and
                    --finished
                    distanceLeft > 10 and flag = true
                  then
                      if counter = 4 then
                         DisplayRT.Clear;
                      DisplayRT.Display('T');
                        flag := False;
                        counter := counter + 1;
                     else
                        DisplayRT.Clear;
                      DisplayRT.Display('T');
                        flag := False;
                        counter := counter + 1;
               end if;

                  end if;
               when others =>
                --next state
                  counter := 0;

            end case;

   end loop;
end Main;
