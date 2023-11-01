with MicroBit; use MicroBit;
with MicroBit.MotorDriver; use MicroBit.MotorDriver;
with MicroBit.Ultrasonic;
with MicroBit.Types; use MicroBit.Types;

package tasks is
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
   

   
   task updateDirection with Priority => 1;
   
   task checkSensor with Priority => 1;
   
private
   package sensor is new MicroBit.Ultrasonic(MB_P1,MB_P0);
   State : DriveState := Forward;
   distance : Distance_cm := 0;
  
end tasks;
