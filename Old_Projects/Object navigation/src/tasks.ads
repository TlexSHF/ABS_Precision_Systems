with MicroBit; use MicroBit;
with MicroBit.MotorDriver; use MicroBit.MotorDriver;
with MicroBit.Ultrasonic;
with MicroBit.Types; use MicroBit.Types;

package Tasks is
   task Drive_1 with Priority=> 2;
   task Drive_1 with Priority=> 2;
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
 
   
  
   --Act
   task UpdateDirection with Priority => 2;
   
   
private
   package sensorFront  is new MicroBit.Ultrasonic(MB_P12,MB_P0);
   package sensorRight  is new MicroBit.Ultrasonic(MB_P13,MB_P1);
   package sensorLeft   is new MicroBit.Ultrasonic(MB_P8,MB_P2);
   drive             : DriveState   := Forward;
   car               : CarState     := ObjectNavigating;
   distanceFront     : Integer  := 0;
   distanceRight     : Integer  := 0;
   distanceLeft      : Integer  := 0;
   lineTrackerLeft   : Boolean      := False;
   lineTrackerMiddle : Boolean      := False;
   lineTrackerRight  : Boolean      := False;
         
  
end Tasks;
