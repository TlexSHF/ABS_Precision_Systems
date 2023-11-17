with tasks; use tasks;
-- with MicroBit; use MicroBit;
--with MicroBit.IOsForTasking; use MicroBit.IOsForTasking;
--with MicroBit.Console; use MicroBit.Console;
--with MicroBit.Ultrasonic;

procedure Main with Priority => 0 is
   --package sensorFront  is new MicroBit.Ultrasonic(MB_P12,MB_P0);
   --package sensorRight  is new MicroBit.Ultrasonic(MB_P13,MB_P1);
   --package sensorLeft   is new MicroBit.Ultrasonic(MB_P8,MB_P2);
begin
   loop
      --Put_Line("Hello World!");
      --Put_Line("Front:" & sensorFront.Read'Image);
      --Put_Line("Right:" & sensorRight.Read'Image);
      --Put_Line("Left:" & sensorLeft.Read'Image);
      --delay(0.2);
      null;
   end loop;

end Main;
