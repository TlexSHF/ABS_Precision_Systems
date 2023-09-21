pragma Warnings (Off);
pragma Ada_95;
pragma Source_File_Name (ada_main, Spec_File_Name => "b__main.ads");
pragma Source_File_Name (ada_main, Body_File_Name => "b__main.adb");
pragma Suppress (Overflow_Check);

package body ada_main is

   E083 : Short_Integer; pragma Import (Ada, E083, "memory_barriers_E");
   E081 : Short_Integer; pragma Import (Ada, E081, "cortex_m__nvic_E");
   E075 : Short_Integer; pragma Import (Ada, E075, "nrf__events_E");
   E030 : Short_Integer; pragma Import (Ada, E030, "nrf__gpio_E");
   E077 : Short_Integer; pragma Import (Ada, E077, "nrf__interrupts_E");
   E038 : Short_Integer; pragma Import (Ada, E038, "nrf__rtc_E");
   E041 : Short_Integer; pragma Import (Ada, E041, "nrf__spi_master_E");
   E062 : Short_Integer; pragma Import (Ada, E062, "nrf__tasks_E");
   E060 : Short_Integer; pragma Import (Ada, E060, "nrf__clock_E");
   E098 : Short_Integer; pragma Import (Ada, E098, "nrf__radio_E");
   E045 : Short_Integer; pragma Import (Ada, E045, "nrf__timers_E");
   E048 : Short_Integer; pragma Import (Ada, E048, "nrf__twi_E");
   E052 : Short_Integer; pragma Import (Ada, E052, "nrf__uart_E");
   E018 : Short_Integer; pragma Import (Ada, E018, "nrf__device_E");
   E056 : Short_Integer; pragma Import (Ada, E056, "microbit__console_E");
   E091 : Short_Integer; pragma Import (Ada, E091, "microbit__i2c_E");
   E095 : Short_Integer; pragma Import (Ada, E095, "microbit__radio_E");
   E058 : Short_Integer; pragma Import (Ada, E058, "microbit__time_E");
   E014 : Short_Integer; pragma Import (Ada, E014, "dfr0548_E");
   E087 : Short_Integer; pragma Import (Ada, E087, "microbit__display_E");
   E089 : Short_Integer; pragma Import (Ada, E089, "microbit__display__symbols_E");
   E093 : Short_Integer; pragma Import (Ada, E093, "microbit__motordriver_E");
   E100 : Short_Integer; pragma Import (Ada, E100, "microbit__time__highspeed_E");
   E103 : Short_Integer; pragma Import (Ada, E103, "microbit__ultrasonic_E");

   Sec_Default_Sized_Stacks : array (1 .. 1) of aliased System.Secondary_Stack.SS_Stack (System.Parameters.Runtime_Default_Sec_Stack_Size);


   procedure adainit is
      Binder_Sec_Stacks_Count : Natural;
      pragma Import (Ada, Binder_Sec_Stacks_Count, "__gnat_binder_ss_count");

      Default_Secondary_Stack_Size : System.Parameters.Size_Type;
      pragma Import (C, Default_Secondary_Stack_Size, "__gnat_default_ss_size");
      Default_Sized_SS_Pool : System.Address;
      pragma Import (Ada, Default_Sized_SS_Pool, "__gnat_default_ss_pool");

   begin
      null;

      ada_main'Elab_Body;
      Default_Secondary_Stack_Size := System.Parameters.Runtime_Default_Sec_Stack_Size;
      Binder_Sec_Stacks_Count := 1;
      Default_Sized_SS_Pool := Sec_Default_Sized_Stacks'Address;


      E083 := E083 + 1;
      E081 := E081 + 1;
      E075 := E075 + 1;
      E030 := E030 + 1;
      E077 := E077 + 1;
      E038 := E038 + 1;
      E041 := E041 + 1;
      E062 := E062 + 1;
      E060 := E060 + 1;
      E098 := E098 + 1;
      E045 := E045 + 1;
      E048 := E048 + 1;
      E052 := E052 + 1;
      Nrf.Device'Elab_Spec;
      Nrf.Device'Elab_Body;
      E018 := E018 + 1;
      Microbit.Console'Elab_Body;
      E056 := E056 + 1;
      E091 := E091 + 1;
      E095 := E095 + 1;
      Microbit.Time'Elab_Body;
      E058 := E058 + 1;
      E014 := E014 + 1;
      Microbit.Display'Elab_Body;
      E087 := E087 + 1;
      E089 := E089 + 1;
      Microbit.Motordriver'Elab_Body;
      E093 := E093 + 1;
      Microbit.Time.Highspeed'Elab_Body;
      E100 := E100 + 1;
      E103 := E103 + 1;
   end adainit;

   procedure Ada_Main_Program;
   pragma Import (Ada, Ada_Main_Program, "_ada_main");

   procedure main is
      Ensure_Reference : aliased System.Address := Ada_Main_Program_Name'Address;
      pragma Volatile (Ensure_Reference);

   begin
      adainit;
      Ada_Main_Program;
   end;

--  BEGIN Object file/option list
   --   C:\Users\aditi.DESKTOP-49PGKM5\Documents\Radio_project\obj\main.o
   --   -LC:\Users\aditi.DESKTOP-49PGKM5\Documents\Radio_project\obj\
   --   -LC:\Users\aditi.DESKTOP-49PGKM5\Documents\Radio_project\obj\
   --   -LC:\Users\aditi.DESKTOP-49PGKM5\OneDrive - USN\Dokumenter\ada\Ada_Drivers_Library_j\boards\MicroBit_v2\obj\zfp_lib_Debug\
   --   -LC:\gnat\2021-arm-elf\arm-eabi\lib\gnat\zfp-cortex-m4f\adalib\
   --   -static
   --   -lgnat
--  END Object file/option list   

end ada_main;
