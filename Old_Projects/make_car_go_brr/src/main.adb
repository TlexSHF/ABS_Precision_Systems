with MicroBit.Console; use MicroBit.Console;
with MicroBit.MotorDriver;
-- with MicroBit.Time;
-- with MicroBit.IOs;
with MicroBit.Ultrasonic;
use MicroBit;

procedure Main is
   -- lightPin : IOs.Pin_Id := 2;
   -- lightValue : IOs.Analog_Value := 0;

   package UltraFront is new Ultrasonic;
   package UltraRight is new Ultrasonic;
   package UltraLeft is new Ultrasonic;

   -- DistanceFront : UltraFront.Distance_cm := 0;
   -- DistanceLeft : UltraLeft.Distance_cm := 0;
   -- DistanceRight : UltraRight.Distance_cm := 0;

   DistanceFront : Integer := 0;
   DistanceLeft : Integer := 0;
   DistanceRight : Integer := 0;
begin
   UltraFront.Setup(12,0);
   UltraRight.Setup(13,1);
   UltraLeft.Setup(8,2);
   loop
      DistanceFront := Integer(UltraFront.Read);
      DistanceRight := Integer(UltraRight.Read);
      DistanceLeft := Integer(UltraLeft.Read);

      -- Put_Line ("Read Front" & UltraFront.Distance_cm'Image(DistanceFront));
      -- Put_Line ("Read Left" & UltraLeft.Distance_cm'Image(DistanceLeft));
      -- Put_Line ("Read Right" & UltraRight.Distance_cm'Image(DistanceRight));

      MotorDriver.Drive (MotorDriver.Forward);


      delay(1.0);
   end loop;


   --loop
      -- MotorDriver.Drive(MotorDriver.Forward);
      -- lightValue := IOs.Analog(lightPin);
      -- Console.Put_Line("Hi there");
      -- Console.Put_Line(lightValue'Image);
      -- Time.Delay_Ms(1000);
   --end loop;
end Main;
