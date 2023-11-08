package tasks is
   -- task Testing with Priority => 1;

   type Angle is new Integer range 90 .. 180;

   task Fare with Priority => 1;
   procedure Rotate (wantedAngle : Angle);
end tasks;
