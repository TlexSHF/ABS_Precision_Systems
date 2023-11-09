-- with MicroBit.Console;

with tasks; use tasks;

procedure Main with Priority => 0 is
begin
   loop
      null;
   end loop;
end Main;


------- OLD MAIN DEFINE FIELD: -----
--  actionTime : Time;
--  wheelSpeed : HAL.Uint12 := 768;
--  timeInterval : Integer := 6880;


------- OLD MAIN BEGIN: ------
-- actionTime := Clock;
------- LOOP: -----
--  if Clock >= actionTime + Milliseconds(6880) then
      --     wheelSpeed := 4095;
      --  end if;
      --  if Clock >= actionTime + Milliseconds(6890) then
      --     wheelSpeed := 512;
      --  end if;
      -- if Clock >= actionTime + Milliseconds(timeInterval) then
      --    wheelSpeed := 512;
      -- end if;

      -- Drive(Forward, (4095, 4095, wheelSpeed, wheelSpeed));

      -- For some reason the program compiles when "using" MicroBit.MotorDriver, but complains about
      -- "MicroBit.MotorDriver" not being visible when stated only on areas needed.
      -- Drive(Forward, (4095, 4095, 4095, 4095));
      -- Drive(Forward, (4095, 4095, 512, 512));
      -- Delay_Ms(1000);

      -- for i in 0 .. UInt12(4095) loop
      --    Drive(Forward, (4095, 4095, i, i));
      --    -- Delay_Ms(100);
      -- end loop;
      -- Drive(Forward, (4095, 4095, 0, 0));
      -- Drive(Forward, (4095, 4095, 256, 256));
      -- Drive(Forward, (4095, 4095, 512, 512));
      -- Drive(Forward, (4095, 4095, 800, 800));
      -- Drive(Forward, (4095, 4095, 1024, 1024));
      -- delay until 4950;
