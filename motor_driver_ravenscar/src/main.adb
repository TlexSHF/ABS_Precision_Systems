with MicroBit; use MicroBit;
with MicroBit.MotorDriver; use MicroBit.MotorDriver;
with MicroBit.TimeWithRTC1;


procedure Main is

begin
   loop
     MotorDriver.Drive(Forward,(4095,0,0,0));
      --  delay(1.0);
     TimeWithRTC1.Delay_Ms(1000);
   end loop;

end Main;
