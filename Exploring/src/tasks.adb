with MicroBit; use MicroBit;
with MicroBit.MotorDriver;
with Ada.Real_Time; use Ada.Real_Time;
with MicroBit.TimeWithRTC1; use MicroBit.TimeWithRTC1;
with MicroBit.IOsForTasking; use MicroBit.IOsForTasking;
with MicroBit.Console;
with Ada.Numerics.Discrete_Random;

package body tasks is

   task body Fare is
      -- Random Number Generator
      package Rand_Int is new ada.numerics.discrete_random(Angle);
      gen : Rand_Int.Generator;

      -- Times and Durations
      driveDuration : constant Time_Span := Seconds(3);
      driveStart : Time;
      wantedAngle : Angle := 90;

   begin
      Set_Analog_Period_Us(20000);
      loop
         -- Car drives for "driveDuration"
         driveStart := Clock;
         MotorDriver.Drive(MotorDriver.Forward);

         delay until driveStart + driveDuration;

         -- Car rotates for "wantedAngle" degrees
         Rand_Int.reset(gen);
         wantedAngle := Rand_Int.random(gen);
         Rotate(wantedAngle);

      end loop;
   end Fare;


   procedure Rotate (wantedAngle : Angle) is
      angleDurationMicro : constant Integer := 9200;
      totalAngleDuration : Time_Span := Microseconds(Integer(wantedAngle) * angleDurationMicro);
      rotateStart : Time;

   begin
      rotateStart := Clock;
      MotorDriver.Drive(MotorDriver.Rotating_Right);

      delay until rotateStart + totalAngleDuration;
   end Rotate;

end tasks;
