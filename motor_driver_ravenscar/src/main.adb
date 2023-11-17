with tasks; use tasks;
--  with MicroBit; use MicroBit;
--  with MicroBit.IOsForTasking; use MicroBit.IOsForTasking;
--  with MicroBit.Console; use MicroBit.Console;
--  with MicroBit.Ultrasonic;
--  with MicroBit.MotorDriver;

procedure Main with Priority => 0 is
   --  package sensorFront  is new MicroBit.Ultrasonic(MB_P12,MB_P0);
   --  type modulus is mod 4;
   --  number : modulus := 1;
begin
   --  MotorDriver.Drive(MotorDriver.Lateral_Right);
   loop
      --  Put_Line(number'Image);
      --  number := number + 1;
      --  Put_Line(sensorFront.Read'Image);
      null;
   end loop;

end Main;
