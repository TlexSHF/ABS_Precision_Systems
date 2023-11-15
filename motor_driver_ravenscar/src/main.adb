with tasks; use tasks;
--  with MicroBit; use MicroBit;
--  with MicroBit.IOsForTasking; use MicroBit.IOsForTasking;
--  with MicroBit.Console; use MicroBit.Console;
--  with MicroBit.Ultrasonic;

procedure Main with Priority => 0 is
   --  package sensorFront  is new MicroBit.Ultrasonic(MB_P12,MB_P0);
begin
   loop
      --  Put_Line(sensorFront.Read'Image);
      null;
   end loop;

end Main;
