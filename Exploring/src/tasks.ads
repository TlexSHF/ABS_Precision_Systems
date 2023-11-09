package tasks is
   -- task Testing with Priority => 1;

   type Angle is new Integer range 90 .. 180; -- make subtype instead?

   task Fare with Priority => 1; -- great name!
   procedure Rotate (wantedAngle : Angle);
end tasks;
