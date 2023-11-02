with MicroBit; use MicroBit;
with MicroBit.MotorDriver;
with MicroBit.Console; use MicroBit.Console;
with MicroBit.IOsForTasking; use MicroBit.IOsForTasking;
--  with tasks; use tasks;

procedure Main with Priority => 0 is
      LineTrackerMiddle : Boolean    := False;
      LineTrackerLeft  : Boolean    := False;
      LineTrackerRight : Boolean    := False;
begin
   Set_Analog_Period_Us(20000);
   --  Drive(Forward_Left);

   loop
      LineTrackerMiddle := digitalRead(14);
      LineTrackerLeft  := digitalRead (15);
      LineTrackerRight := digitalRead (16);
      if not LineTrackerLeft and LineTrackerMiddle and not LineTrackerRight then       --010
         MotorDriver.Drive(MotorDriver.Forward);
      elsif not LineTrackerLeft and LineTrackerMiddle and LineTrackerRight then        --011
         MotorDriver.Drive(MotorDriver.Lateral_Right,(1024,1024,1024,1024));
      elsif LineTrackerLeft and LineTrackerMiddle and not LineTrackerRight then        --110
         MotorDriver.Drive(MotorDriver.Lateral_Left,(1024,1024,1024,1024));
      elsif LineTrackerLeft and not LineTrackerMiddle and not LineTrackerRight then    --100
         MotorDriver.Drive(MotorDriver.Lateral_Left,(1024,1024,1024,1024));
      elsif not LineTrackerLeft and not LineTrackerMiddle and LineTrackerRight then    --001
         MotorDriver.Drive(MotorDriver.Lateral_Right,(1024,1024,1024,1024));
      elsif LineTrackerLeft and LineTrackerMiddle and LineTrackerRight then            --111
         MotorDriver.Drive(MotorDriver.Rotating_Right,(2048,2048,2048,2048));
      else  MotorDriver.Drive(MotorDriver.Stop);
      end if;
      delay(0.2);
   end loop;

end Main;