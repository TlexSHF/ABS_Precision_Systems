with MicroBit;             use MicroBit;
with MicroBit.MotorDriver; use MicroBit.MotorDriver;
with MicroBit.Ultrasonic;
with MicroBit.Types;       use MicroBit.Types;
with Ada.Real_Time;        use Ada.Real_Time;

package Tasks is
   type DriveState   is (Forward,
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
   
   --Sense
   task PollEcho          with Priority => 4;
   task CheckLineTracker  with Priority => 3;

   --Think 
   task TrackLine         with Priority => 2;
   task ObjectNav         with Priority => 2;
   -- task ProbeThink     with Priority => 2;
   task Roam           with Priority => 2;
  
   --Act
   task UpdateDirection   with Priority => 1;
   
private
   type ProbeStates                    is (Probe, GoToFront, GoToRight, GoToLeft, Stop);
   type CarState                       is (Roaming, LineFollowing, ObjectNavigating);
   type NavigationStates               is (Circular, Quadratic);
   type LineTrackerCombinations        is (None, L, M, R, L_M, M_R, L_R, L_M_R);
   type UltraSensor                    is (L, F, R);
   type CircState                      is (Rotating,CircNavigating);
   subtype Angle                       is Integer range 0 .. 360;
   
   -- Functions
   function GetLineTrackerState return LineTrackerCombinations;
   function HinderFound (PositionSensor : UltraSensor; dist : Distance_cm := 10) return Boolean;
   
   -- Procedures
   procedure QuadraticNavigating (counter : in out Integer; flag : in out Boolean);
   procedure CircularNavigating(circleStart : in out Time);
   procedure Rotate (wantedAngle : Angle; clockwise : Boolean := True);
   procedure Straighten (ultra : UltraSensor);
   procedure LookForObjects;
   procedure displayStates;
   
   package sensorFront  is new MicroBit.Ultrasonic(MB_P12,MB_P0);
   package sensorRight  is new MicroBit.Ultrasonic(MB_P13,MB_P1);
   package sensorLeft   is new MicroBit.Ultrasonic(MB_P8,MB_P2);
   
   -- Priorities
   pollEchoPeriod         : Time_Span := Milliseconds(78);
   checkLineTrackerPeriod : Time_Span := Milliseconds(79);
   thinkPeriod            : Time_Span := Milliseconds(80);
   updateDirectionPeriod  : Time_Span := Milliseconds(83);
   
   -- Various states & flags
   drive              : DriveState       := Forward;
   car                : CarState         := Roaming;
   speed              : Speeds           := (4095, 4095, 4095, 4095);
   probeState         : ProbeStates      := Probe;
   previousProbeState : ProbeStates      := Probe;
   navState           : NavigationStates := Circular;
   CircStateVariable  : CircState        := Rotating;
   enableObjectDetect : Boolean          := True;
   pollFlag           : Boolean          := False;
   
   
   -- Sensor inputs
   distanceFront     : aliased Distance_cm  := 0;
   distanceRight     : aliased Distance_cm  := 0;
   distanceLeft      : aliased Distance_cm  := 0;
   lineTrackerLeft   : Boolean              := False;
   lineTrackerMiddle : Boolean              := False;
   lineTrackerRight  : Boolean              := False;
         
  
end Tasks;
