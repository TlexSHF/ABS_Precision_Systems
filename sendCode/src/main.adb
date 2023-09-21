with MicroBit.Radio; use MicroBit.Radio;
with MicroBit.Buttons; use MicroBit.Buttons;
with HAL; use HAL;
with MicroBit.Console; use MicroBit.Console;
with MicroBit.Display;
with MicroBit.Display.Symbols;
with MicroBit.Time; use MicroBit.Time;
use MicroBit;

procedure Main is
   --  RXdata : RadioData;
   TxData : RadioData;

begin
   TxData.Length := 5;
   TxData.Version:= 12;
   TxData.Group := 1;
   TxData.Protocol := 14;

   Radio.Setup(RadioFrequency => 2520,
               Length => TxData.Length,
               Version => TxData.Version,
               Group => TxData.Group,
               Protocol => TxData.Protocol);

   --  Radio.StartReceiving;
   --  Put_Line(Radio.State); -- this should report Status: 3, meaning in RX mode

   loop
      --check if some data received and if so print it. Note that the framebuffer can max contain x messages (currently set to 4).
	  --important! Sometimes data received contains junk since we dont do any package verification and radio transmission is noisy!
      --  while Radio.DataReady loop
      --     RXdata :=Radio.Receive;
      --     Put("ZFP Received D1: " & UInt8'Image(RXdata.Payload(1)));
      --     Put_Line(" D2: " & UInt8'Image(RXdata.Payload(2)));
      --  end loop;

      -- setup some data to be transmitted and transmit it
      if State(Button_A) = Pressed and State(Button_B) = Pressed then
         TxData.Payload(1) := 30;
      elsif State(Button_A) = Pressed then
         TxData.Payload(1) := 10;
      elsif State(Button_B) = Pressed then
         TxData.Payload(1) := 20;
      else  TxData.Payload(1) := 00;
      end if;
      --  TxData.Payload(2) := 14;
      Put_Line("Transmit D1: " & UInt8'Image(TXdata.Payload(1)));
      --  Put_Line(" D2: " & UInt8'Image(TXdata.Payload(2)));
      Radio.Transmit(TXdata);

      --repeat every 50 ms
      Delay_Ms(50);
   end loop;
end Main;
