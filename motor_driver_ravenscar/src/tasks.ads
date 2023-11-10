with MicroBit; use MicroBit;
with MicroBit.MotorDriver; use MicroBit.MotorDriver;
with MicroBit.Ultrasonic;
with MicroBit.Types; use MicroBit.Types;

package Tasks is
   type DriveState is (Forward,
                       Backward,
                       Left,
                       Right,
                       Forward_Left,
                       Forward_Right,
                       Backward_Left,
                       Backward_Right,
                       Lateral_Left,
                       Lateral_Right,
                       Rotating_Left,
                       Rotating_Right,
                       Curve_Forward_Left,
                       Curve_Forward_Right,
                       Stop);
   subtype Angle is Integer range 90 .. 160;
   type CarState is (Roaming, LineFollowing, ObjectNavigating);
   
   --Sense
   task PollEcho with Priority => 3;
   task CheckSensor with Priority => 3; -- Measured time: 0.023842 ms

   --Think 
   task TrackLine with Priority => 3;  -- Measured time: 0.015259 ms
   task ObjectNav with Priority => 3;
   task ProbeThink with Priority => 3;
   
   --Act
   task UpdateDirection with Priority => 2; -- Measured time: 0.076294 ms
   task Fare with Priority => 1;
   
private
   type ProbeStates is (Probe, GoToFront, GoToRight, GoToLeft, Stop);
   type LineTrackerCombinations is (None, L, M, R, L_M, M_R, L_R, L_M_R);
   function GetLineTrackerState return LineTrackerCombinations;
   procedure Rotate (wantedAngle : Angle; clockwise : Boolean := True);
   
   package sensorFront is new MicroBit.Ultrasonic(MB_P12,MB_P0);
   package sensorRight is new MicroBit.Ultrasonic(MB_P13,MB_P1);
   package sensorLeft is new MicroBit.Ultrasonic(MB_P8,MB_P2);
   
   drive : DriveState := Forward;
   car : CarState := Roaming;
   probeState : ProbeStates := Probe;
   previousProbeState : ProbeStates := Probe;
   distanceFront : Distance_cm := 0;
   distanceRight : Distance_cm := 0;
   distanceLeft : Distance_cm := 0;
   lineTrackerLeft  : Boolean    := False;
   lineTrackerMiddle  : Boolean  := False;
   lineTrackerRight : Boolean    := False;
   pollFlag : Boolean := False;
         
  
end Tasks;
