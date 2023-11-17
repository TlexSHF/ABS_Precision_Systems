with System;
with Ada.Interrupts;
with nRF.GPIO; use nRF.GPIO;
with NRF_SVD.GPIO; use NRF_SVD.GPIO;
with nRF.Interrupts;
with nRF.Events;
with Ada.Real_Time; use Ada.Real_Time;
with Ada.Interrupts.Names; 
with HAL; use HAL;
with MicroBit;             use MicroBit;
with MicroBit.MotorDriver; use MicroBit.MotorDriver;
with MicroBit.Types;       use MicroBit.Types;

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
   subtype Angle     is Integer range 0 .. 360;
   type CarState     is (Roaming, LineFollowing, ObjectNavigating);
   
   --Sense
   task PollEcho     with Priority => 5;
   task CheckSensor  with Priority => 3; -- Measured time: 0.023842 ms

   --Think 
   task TrackLine    with Priority => 3;  -- Measured time: 0.015259 ms
   task ObjectNav    with Priority => 4;
   task ProbeThink   with Priority => 3;
  
   --Act
   task UpdateDirection with Priority => 2; -- Measured time: 0.076294 ms
   task Fare            with Priority => 1;
   
   
   confFalling : GPIO_Configuration := (Mode => Mode_In, Resistors => Pull_Up,    
                                        Input_Buffer => Input_Buffer_Connect,       
                                        Drive => Drive_S0S1, Sense => Sense_For_Low_Level);
   confRising  : GPIO_Configuration := (Mode => Mode_In, Resistors => Pull_Down,
                                        Input_Buffer => Input_Buffer_Connect,
                                        Drive => Drive_S0S1, Sense => Sense_For_High_Level);
   
   protected Receiver is
   
      pragma Interrupt_Priority(System.Interrupt_Priority'First);
   private
      procedure My_ISR;
      pragma Attach_Handler(My_ISR, Ada.Interrupts.Names.GPIOTE_Interrupt);
   end Receiver;
   
private
   type Ultrasensors is record
      EchoPin : GPIO_Point;
      TriggerPin : GPIO_Point;
      RisingTime : Time;
      echoTime : Time_Span := Microseconds(0);
   end record;
   type ultraArr is array (0 .. 2) of Ultrasensors;
   
   type ProbeStates              is (Probe, GoToFront, GoToRight, GoToLeft, Stop);
   type NavigationStates         is (Circular, Quadratic);
   type LineTrackerCombinations  is (None, L, M, R, L_M, M_R, L_R, L_M_R);
   type UltraSensor              is (L, F, R);
   type sensorArrayIndex         is mod 3;
   function GetLineTrackerState return LineTrackerCombinations;
   procedure   Straighten  (ultra : UltraSensor);
   function    HinderFound (PositionSensor : UltraSensor; dist : Integer := 10) return Boolean;
   procedure QuadraticNavigating (counter : in out Integer; flag : in out Boolean);
   procedure CircularNavigating;
   procedure Rotate (wantedAngle : Angle; clockwise : Boolean := True);
   -- procedure AvoidObstacle; -- Maybe unneccessary procedure
   
   ultraSensorArray : ultraArr := ((EchoPin => (Pin => 02), TriggerPin => MB_P12, others => <>),    -- Front
                                   (EchoPin => (Pin => 03), TriggerPin => MB_P13, others => <>),    -- Left
                                   (EchoPin => (Pin => 04), TriggerPin => MB_P8, others => <>));   -- Right
   --  sensorFront : Ultrasensors := (EchoPin => (Pin => 02), TriggerPin => (Pin => 12), others => <>);
   --  sensorLeft : Ultrasensors := (EchoPin => (Pin => 03), TriggerPin => (Pin => 17), others => <>);
   --  sensorRight : Ultrasensors := (EchoPin => (Pin => 04), TriggerPin => (Pin => 10), others => <>);
   
   -- Various states & flags
   drive              : DriveState       := Forward;
   car                : CarState         := ObjectNavigating;
   speed              : Speeds           := (4095, 4095, 4095, 4095);
   probeState         : ProbeStates      := Probe;
   previousProbeState : ProbeStates      := Probe;
   navState           : NavigationStates := Quadratic;
   detectObject       : Boolean          := True;
   pollFlag           : Boolean          := False;
   sensorArrIndex   : sensorArrayIndex := 0;
   
   
   -- Sensor inputs
   distanceFront     : aliased Integer := 0;
   distanceRight     : aliased Integer := 0;
   distanceLeft      : aliased Integer := 0;
   lineTrackerLeft   : Boolean             := False;
   lineTrackerMiddle : Boolean             := False;
   lineTrackerRight  : Boolean             := False;
         
   
  
end Tasks;
