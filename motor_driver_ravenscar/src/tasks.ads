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
   type CarState is (Roaming, LineFollowing, ObjectNavigating);
   
   --Sense
   task PollEcho with Priority => 1;
   task CheckSensor with Priority => 1; -- Measured time: 0.023842 ms

   --Think 
   task TrackLine with Priority => 2;  -- Measured time: 0.015259 ms
   
   --Act
   task UpdateDirection with Priority => 1; -- Measured time: 0.076294 ms
   
   
private
   package sensor is new MicroBit.Ultrasonic(MB_P12,MB_P0);
   package sensor2 is new MicroBit.Ultrasonic(MB_P13,MB_P1);
   package sensor3 is new MicroBit.Ultrasonic(MB_P8,MB_P2);
   drive : DriveState := Forward;
   distance : Distance_cm := 0;
   distance2 : Distance_cm := 0;
   distance3 : Distance_cm := 0;
   lineTrackerLeft  : Boolean    := False;
   lineTrackerMiddle  : Boolean  := False;
   lineTrackerRight : Boolean    := False;
         
  
end Tasks;
