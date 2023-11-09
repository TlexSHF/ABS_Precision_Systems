with MicroBit; use MicroBit;
with MicroBit.Ultrasonic;
with MicroBit.Types; use MicroBit.Types;

package tasks is
   -- task Testing with Priority => 1;

   subtype Angle is Integer range 90 .. 160;

   task PollEcho with Priority => 2;
   task ProbeThink with Priority => 2;
   task Fare with Priority => 1;  -- great name!

   procedure Rotate (wantedAngle : Angle; clockwise : Boolean := True);

private
   type ProbeStates is (Probe, GoToFront, GoToRight, GoToLeft, Stop);
   package sensorFront is new Ultrasonic(MB_P12,MB_P0);
   package sensorRight is new Ultrasonic(MB_P13,MB_P1);
   package sensorLeft is new Ultrasonic(MB_P8,MB_P2);

   probeState : ProbeStates := Probe;
   previousProbeState : ProbeStates := Probe;
   distanceFront  : Distance_cm := 0;
   distanceRight  : Distance_cm := 0;
   distanceLeft   : Distance_cm := 0;
   pollFlag : Boolean := False;

end tasks;
