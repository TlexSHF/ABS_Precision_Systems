with MicroBit; use MicroBit;
with MicroBit.IOsForTasking; use MicroBit.IOsForTasking;
with MicroBit.MotorDriver; use MicroBit.MotorDriver;
with MicroBit.TimeWithRTC1; use MicroBit.TimeWithRTC1;


procedure Main is

begin
   Set_Analog_Period_Us(20000);
   loop
      MotorDriver.Drive(Forward,(4095,0,0,0));

      Delay_Ms(1000);
   end loop;

end Main;
