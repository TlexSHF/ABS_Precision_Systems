pragma Warnings (Off);
pragma Ada_95;
pragma Source_File_Name (ada_main, Spec_File_Name => "b__main.ads");
pragma Source_File_Name (ada_main, Body_File_Name => "b__main.adb");
pragma Suppress (Overflow_Check);

package body ada_main is

   E062 : Short_Integer; pragma Import (Ada, E062, "ada__tags_E");
   E005 : Short_Integer; pragma Import (Ada, E005, "ada__strings__text_buffers_E");
   E060 : Short_Integer; pragma Import (Ada, E060, "system__bb__timing_events_E");
   E012 : Short_Integer; pragma Import (Ada, E012, "ada__exceptions_E");
   E099 : Short_Integer; pragma Import (Ada, E099, "system__soft_links_E");
   E097 : Short_Integer; pragma Import (Ada, E097, "system__exception_table_E");
   E152 : Short_Integer; pragma Import (Ada, E152, "ada__streams_E");
   E159 : Short_Integer; pragma Import (Ada, E159, "system__finalization_root_E");
   E157 : Short_Integer; pragma Import (Ada, E157, "ada__finalization_E");
   E161 : Short_Integer; pragma Import (Ada, E161, "system__storage_pools_E");
   E156 : Short_Integer; pragma Import (Ada, E156, "system__finalization_masters_E");
   E129 : Short_Integer; pragma Import (Ada, E129, "ada__real_time_E");
   E196 : Short_Integer; pragma Import (Ada, E196, "ada__real_time__timing_events_E");
   E202 : Short_Integer; pragma Import (Ada, E202, "ada__strings__maps_E");
   E198 : Short_Integer; pragma Import (Ada, E198, "ada__strings__unbounded_E");
   E163 : Short_Integer; pragma Import (Ada, E163, "system__pool_global_E");
   E216 : Short_Integer; pragma Import (Ada, E216, "system__tasking__protected_objects_E");
   E123 : Short_Integer; pragma Import (Ada, E123, "system__tasking__restricted__stages_E");
   E214 : Short_Integer; pragma Import (Ada, E214, "generic_timers_E");
   E154 : Short_Integer; pragma Import (Ada, E154, "hal__gpio_E");
   E186 : Short_Integer; pragma Import (Ada, E186, "hal__i2c_E");
   E179 : Short_Integer; pragma Import (Ada, E179, "hal__spi_E");
   E190 : Short_Integer; pragma Import (Ada, E190, "hal__uart_E");
   E223 : Short_Integer; pragma Import (Ada, E223, "memory_barriers_E");
   E221 : Short_Integer; pragma Import (Ada, E221, "cortex_m__nvic_E");
   E240 : Short_Integer; pragma Import (Ada, E240, "nrf__events_E");
   E145 : Short_Integer; pragma Import (Ada, E145, "nrf__gpio_E");
   E242 : Short_Integer; pragma Import (Ada, E242, "nrf__gpio__tasks_and_events_E");
   E244 : Short_Integer; pragma Import (Ada, E244, "nrf__interrupts_E");
   E174 : Short_Integer; pragma Import (Ada, E174, "nrf__rtc_E");
   E177 : Short_Integer; pragma Import (Ada, E177, "nrf__spi_master_E");
   E227 : Short_Integer; pragma Import (Ada, E227, "nrf__tasks_E");
   E225 : Short_Integer; pragma Import (Ada, E225, "nrf__adc_E");
   E265 : Short_Integer; pragma Import (Ada, E265, "nrf__clock_E");
   E246 : Short_Integer; pragma Import (Ada, E246, "nrf__ppi_E");
   E181 : Short_Integer; pragma Import (Ada, E181, "nrf__timers_E");
   E184 : Short_Integer; pragma Import (Ada, E184, "nrf__twi_E");
   E188 : Short_Integer; pragma Import (Ada, E188, "nrf__uart_E");
   E135 : Short_Integer; pragma Import (Ada, E135, "nrf__device_E");
   E192 : Short_Integer; pragma Import (Ada, E192, "microbit__console_E");
   E259 : Short_Integer; pragma Import (Ada, E259, "dfr0548_E");
   E194 : Short_Integer; pragma Import (Ada, E194, "microbit__displayrt_E");
   E261 : Short_Integer; pragma Import (Ada, E261, "microbit__i2c_E");
   E218 : Short_Integer; pragma Import (Ada, E218, "microbit__iosfortasking_E");
   E257 : Short_Integer; pragma Import (Ada, E257, "microbit__motordriver_E");
   E263 : Short_Integer; pragma Import (Ada, E263, "microbit__timehighspeed_E");
   E267 : Short_Integer; pragma Import (Ada, E267, "microbit__ultrasonic_E");
   E126 : Short_Integer; pragma Import (Ada, E126, "tasks_E");

   Sec_Default_Sized_Stacks : array (1 .. 8) of aliased System.Secondary_Stack.SS_Stack (System.Parameters.Runtime_Default_Sec_Stack_Size);

   Local_Priority_Specific_Dispatching : constant String := "";
   Local_Interrupt_States : constant String := "";

   Is_Elaborated : Boolean := False;

   procedure adafinal is
      procedure s_stalib_adafinal;
      pragma Import (Ada, s_stalib_adafinal, "system__standard_library__adafinal");

      procedure Runtime_Finalize;
      pragma Import (C, Runtime_Finalize, "__gnat_runtime_finalize");

   begin
      if not Is_Elaborated then
         return;
      end if;
      Is_Elaborated := False;
      Runtime_Finalize;
      s_stalib_adafinal;
   end adafinal;

   procedure adainit is
      Main_Priority : Integer;
      pragma Import (C, Main_Priority, "__gl_main_priority");
      Time_Slice_Value : Integer;
      pragma Import (C, Time_Slice_Value, "__gl_time_slice_val");
      WC_Encoding : Character;
      pragma Import (C, WC_Encoding, "__gl_wc_encoding");
      Locking_Policy : Character;
      pragma Import (C, Locking_Policy, "__gl_locking_policy");
      Queuing_Policy : Character;
      pragma Import (C, Queuing_Policy, "__gl_queuing_policy");
      Task_Dispatching_Policy : Character;
      pragma Import (C, Task_Dispatching_Policy, "__gl_task_dispatching_policy");
      Priority_Specific_Dispatching : System.Address;
      pragma Import (C, Priority_Specific_Dispatching, "__gl_priority_specific_dispatching");
      Num_Specific_Dispatching : Integer;
      pragma Import (C, Num_Specific_Dispatching, "__gl_num_specific_dispatching");
      Main_CPU : Integer;
      pragma Import (C, Main_CPU, "__gl_main_cpu");
      Interrupt_States : System.Address;
      pragma Import (C, Interrupt_States, "__gl_interrupt_states");
      Num_Interrupt_States : Integer;
      pragma Import (C, Num_Interrupt_States, "__gl_num_interrupt_states");
      Unreserve_All_Interrupts : Integer;
      pragma Import (C, Unreserve_All_Interrupts, "__gl_unreserve_all_interrupts");
      Detect_Blocking : Integer;
      pragma Import (C, Detect_Blocking, "__gl_detect_blocking");
      Default_Stack_Size : Integer;
      pragma Import (C, Default_Stack_Size, "__gl_default_stack_size");
      Default_Secondary_Stack_Size : System.Parameters.Size_Type;
      pragma Import (C, Default_Secondary_Stack_Size, "__gnat_default_ss_size");
      Bind_Env_Addr : System.Address;
      pragma Import (C, Bind_Env_Addr, "__gl_bind_env_addr");

      procedure Runtime_Initialize (Install_Handler : Integer);
      pragma Import (C, Runtime_Initialize, "__gnat_runtime_initialize");
      Binder_Sec_Stacks_Count : Natural;
      pragma Import (Ada, Binder_Sec_Stacks_Count, "__gnat_binder_ss_count");
      Default_Sized_SS_Pool : System.Address;
      pragma Import (Ada, Default_Sized_SS_Pool, "__gnat_default_ss_pool");

   begin
      if Is_Elaborated then
         return;
      end if;
      Is_Elaborated := True;
      Main_Priority := 0;
      Time_Slice_Value := 0;
      WC_Encoding := 'b';
      Locking_Policy := 'C';
      Queuing_Policy := ' ';
      Task_Dispatching_Policy := 'F';
      Priority_Specific_Dispatching :=
        Local_Priority_Specific_Dispatching'Address;
      Num_Specific_Dispatching := 0;
      Main_CPU := -1;
      Interrupt_States := Local_Interrupt_States'Address;
      Num_Interrupt_States := 0;
      Unreserve_All_Interrupts := 0;
      Detect_Blocking := 1;
      Default_Stack_Size := -1;

      ada_main'Elab_Body;
      Default_Secondary_Stack_Size := System.Parameters.Runtime_Default_Sec_Stack_Size;
      Binder_Sec_Stacks_Count := 8;
      Default_Sized_SS_Pool := Sec_Default_Sized_Stacks'Address;

      Runtime_Initialize (1);

      Ada.Strings.Text_Buffers'Elab_Spec;
      E005 := E005 + 1;
      System.Bb.Timing_Events'Elab_Spec;
      E060 := E060 + 1;
      Ada.Exceptions'Elab_Spec;
      System.Soft_Links'Elab_Spec;
      Ada.Tags'Elab_Body;
      E062 := E062 + 1;
      System.Exception_Table'Elab_Body;
      E097 := E097 + 1;
      E099 := E099 + 1;
      E012 := E012 + 1;
      Ada.Streams'Elab_Spec;
      E152 := E152 + 1;
      System.Finalization_Root'Elab_Spec;
      E159 := E159 + 1;
      Ada.Finalization'Elab_Spec;
      E157 := E157 + 1;
      System.Storage_Pools'Elab_Spec;
      E161 := E161 + 1;
      System.Finalization_Masters'Elab_Spec;
      System.Finalization_Masters'Elab_Body;
      E156 := E156 + 1;
      Ada.Real_Time'Elab_Body;
      E129 := E129 + 1;
      Ada.Real_Time.Timing_Events'Elab_Spec;
      E196 := E196 + 1;
      Ada.Strings.Maps'Elab_Spec;
      E202 := E202 + 1;
      Ada.Strings.Unbounded'Elab_Spec;
      E198 := E198 + 1;
      System.Pool_Global'Elab_Spec;
      E163 := E163 + 1;
      System.Tasking.Protected_Objects'Elab_Body;
      E216 := E216 + 1;
      System.Tasking.Restricted.Stages'Elab_Body;
      E123 := E123 + 1;
      E214 := E214 + 1;
      HAL.GPIO'ELAB_SPEC;
      E154 := E154 + 1;
      HAL.I2C'ELAB_SPEC;
      E186 := E186 + 1;
      HAL.SPI'ELAB_SPEC;
      E179 := E179 + 1;
      HAL.UART'ELAB_SPEC;
      E190 := E190 + 1;
      E223 := E223 + 1;
      E221 := E221 + 1;
      E240 := E240 + 1;
      Nrf.Gpio'Elab_Spec;
      Nrf.Gpio'Elab_Body;
      E145 := E145 + 1;
      E242 := E242 + 1;
      E244 := E244 + 1;
      E174 := E174 + 1;
      Nrf.Spi_Master'Elab_Spec;
      Nrf.Spi_Master'Elab_Body;
      E177 := E177 + 1;
      E227 := E227 + 1;
      E225 := E225 + 1;
      E265 := E265 + 1;
      E246 := E246 + 1;
      Nrf.Timers'Elab_Spec;
      Nrf.Timers'Elab_Body;
      E181 := E181 + 1;
      Nrf.Twi'Elab_Spec;
      Nrf.Twi'Elab_Body;
      E184 := E184 + 1;
      Nrf.Uart'Elab_Spec;
      Nrf.Uart'Elab_Body;
      E188 := E188 + 1;
      Nrf.Device'Elab_Spec;
      Nrf.Device'Elab_Body;
      E135 := E135 + 1;
      Microbit.Console'Elab_Body;
      E192 := E192 + 1;
      DFR0548'ELAB_SPEC;
      DFR0548'ELAB_BODY;
      E259 := E259 + 1;
      Microbit.Displayrt'Elab_Body;
      E194 := E194 + 1;
      E261 := E261 + 1;
      Microbit.Iosfortasking'Elab_Spec;
      Microbit.Iosfortasking'Elab_Body;
      E218 := E218 + 1;
      Microbit.Motordriver'Elab_Body;
      E257 := E257 + 1;
      Microbit.Timehighspeed'Elab_Body;
      E263 := E263 + 1;
      E267 := E267 + 1;
      Tasks'Elab_Spec;
      Tasks'Elab_Body;
      E126 := E126 + 1;
   end adainit;

   procedure Ada_Main_Program;
   pragma Import (Ada, Ada_Main_Program, "_ada_main");

   procedure main is
      procedure Initialize (Addr : System.Address);
      pragma Import (C, Initialize, "__gnat_initialize");

      procedure Finalize;
      pragma Import (C, Finalize, "__gnat_finalize");
      SEH : aliased array (1 .. 2) of Integer;

      Ensure_Reference : aliased System.Address := Ada_Main_Program_Name'Address;
      pragma Volatile (Ensure_Reference);

   begin
      Initialize (SEH'Address);
      adainit;
      Ada_Main_Program;
      adafinal;
      Finalize;
   end;

--  BEGIN Object file/option list
   --   C:\Users\simone\Documents\USN\2023_Fall\Sanntidssystemer\ABS_Precision_Systems\FINAL\motor_driver_ravenscar\obj\tasks.o
   --   C:\Users\simone\Documents\USN\2023_Fall\Sanntidssystemer\ABS_Precision_Systems\FINAL\motor_driver_ravenscar\obj\main.o
   --   -LC:\Users\simone\Documents\USN\2023_Fall\Sanntidssystemer\ABS_Precision_Systems\FINAL\motor_driver_ravenscar\obj\
   --   -LC:\Users\simone\Documents\USN\2023_Fall\Sanntidssystemer\ABS_Precision_Systems\FINAL\motor_driver_ravenscar\obj\
   --   -LC:\Users\simone\Documents\USN\2023_Fall\Sanntidssystemer\ABS_Precision_Systems\Libraries\Ada_Drivers_Library_j\boards\MicroBit_v2\obj\full_lib_Debug\
   --   -LC:\gnat\2021-arm-elf\arm-eabi\lib\gnat\ravenscar-full-nrf52833\adalib\
   --   -static
   --   -lgnarl
   --   -lgnat
--  END Object file/option list   

end ada_main;
