with MicroBit; use MicroBit;
--  with MicroBit.MotorDriver;
--  with MicroBit.Ultrasonic;
--  with MicroBit.Console; use MicroBit.Console;
--  with MicroBit.IOsForTasking; use MicroBit.IOsForTasking;
with tasks; use tasks;

procedure Main with Priority => 0 is
      --  lineTrackerMiddle : Boolean    := False;
      --  lineTrackerLeft  : Boolean    := False;
      --  lineTrackerRight : Boolean    := False;
      --  package sensor is new MicroBit.Ultrasonic(MB_P12,MB_P0);
begin
   --  Set_Analog_Period_Us(20000);
   --  MotorDriver.Drive(MotorDriver.Forward, (1024, 0, 0, 0));

   loop
      --  lineTrackerLeft   := digitalRead (15);
      --  lineTrackerMiddle := digitalRead (14);
      --  lineTrackerRight  := digitalRead (16);
      --  --
      --  Put_Line(lineTrackerLeft'Image & ", " & lineTrackerMiddle'Image & ", " & lineTrackerRight'Image);
      --  Put_Line(sensor.Read'Image);
      --  delay(0.5);
      null;
   end loop;

end Main;
