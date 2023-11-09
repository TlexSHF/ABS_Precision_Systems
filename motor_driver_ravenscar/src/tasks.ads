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
   task PollEcho with Priority => 2;
   task CheckSensor with Priority => 2;

   --Think 
   task TrackLine with Priority => 2;
   task ObjectNav with Priority => 2;
   
   --Act
   task UpdateDirection with Priority => 2;
   
   
private
   package sensorFront  is new MicroBit.Ultrasonic(MB_P12,MB_P0);
   package sensorRight  is new MicroBit.Ultrasonic(MB_P13,MB_P1);
   package sensorLeft   is new MicroBit.Ultrasonic(MB_P8,MB_P2);
   drive             : DriveState   := Forward;
   car               : CarState     := LineFollowing;
   distanceFront     : Integer  := 0;
   distanceRight     : Integer  := 0;
   distanceLeft      : Integer  := 0;
   lineTrackerLeft   : Boolean      := False;
   lineTrackerMiddle : Boolean      := False;
   lineTrackerRight  : Boolean      := False;
         
  
end Tasks;
