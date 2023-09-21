with MicroBit.Radio; use MicroBit.Radio;
with HAL; use HAL;
with MicroBit.Console; use MicroBit.Console;
with MicroBit.Display;
with MicroBit.Display.Symbols;
with MicroBit.Time; use MicroBit.Time;
with MicroBit.Ultrasonic;
with MicroBit.Types; use MicroBit.Types;
with MicroBit.MotorDriver; use MicroBit.MotorDriver; --using the procedures defined here
with DFR0548;  -- using the types defined here
with MicroBit.I2C;
use MicroBit;
procedure Main is
   RXdata : RadioData;
   TxData : RadioData;
    package sensor is new Ultrasonic;
   distance : Types.Distance_cm := 0;
begin
   sensor.Setup(MB_P1, MB_P0);
   TxData.Length := 5;
   TxData.Version:= 12;
   TxData.Group := 1;
   TxData.Protocol := 14;
   Radio.Setup(RadioFrequency => 2520,
               Length => TxData.Length,
               Version => TxData.Version,
               Group => TxData.Group,
               Protocol => TxData.Protocol);
      Radio.StartReceiving;
   Put_Line(Radio.State); --
   loop
            distance := sensor.Read;
      --RXdata.Payload(1) := 0;
      while Radio.DataReady loop
         RXdata :=Radio.Receive;
      end loop;

      if RXdata.Payload(1) = 10 then
         MotorDriver.Drive(Stop);
         MotorDriver.Drive(Rotating_Left);
      elsif RXdata.Payload(1) = 20 then
         MotorDriver.Drive(Stop);
         MotorDriver.Drive(Rotating_Right);
      elsif RXdata.Payload(1) = 30 then
         MotorDriver.Drive(Stop);
         MotorDriver.Drive(Backward);
      elsif distance < 20 then
         MotorDriver.Drive(Stop);
      else MotorDriver.Drive(Forward);
      end if;


      Delay_Ms(50);
   end loop;
end Main;
