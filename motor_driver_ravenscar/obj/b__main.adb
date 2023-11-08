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
   E142 : Short_Integer; pragma Import (Ada, E142, "ada__streams_E");
   E149 : Short_Integer; pragma Import (Ada, E149, "system__finalization_root_E");
   E147 : Short_Integer; pragma Import (Ada, E147, "ada__finalization_E");
   E151 : Short_Integer; pragma Import (Ada, E151, "system__storage_pools_E");
   E146 : Short_Integer; pragma Import (Ada, E146, "system__finalization_masters_E");
   E187 : Short_Integer; pragma Import (Ada, E187, "ada__real_time_E");
   E153 : Short_Integer; pragma Import (Ada, E153, "system__pool_global_E");
   E225 : Short_Integer; pragma Import (Ada, E225, "system__tasking__protected_objects_E");
   E182 : Short_Integer; pragma Import (Ada, E182, "system__tasking__restricted__stages_E");
   E144 : Short_Integer; pragma Import (Ada, E144, "hal__gpio_E");
   E176 : Short_Integer; pragma Import (Ada, E176, "hal__i2c_E");
   E169 : Short_Integer; pragma Import (Ada, E169, "hal__spi_E");
   E180 : Short_Integer; pragma Import (Ada, E180, "hal__uart_E");
   E198 : Short_Integer; pragma Import (Ada, E198, "memory_barriers_E");
   E196 : Short_Integer; pragma Import (Ada, E196, "cortex_m__nvic_E");
   E215 : Short_Integer; pragma Import (Ada, E215, "nrf__events_E");
   E135 : Short_Integer; pragma Import (Ada, E135, "nrf__gpio_E");
   E217 : Short_Integer; pragma Import (Ada, E217, "nrf__gpio__tasks_and_events_E");
   E219 : Short_Integer; pragma Import (Ada, E219, "nrf__interrupts_E");
   E164 : Short_Integer; pragma Import (Ada, E164, "nrf__rtc_E");
   E167 : Short_Integer; pragma Import (Ada, E167, "nrf__spi_master_E");
   E202 : Short_Integer; pragma Import (Ada, E202, "nrf__tasks_E");
   E200 : Short_Integer; pragma Import (Ada, E200, "nrf__adc_E");
   E242 : Short_Integer; pragma Import (Ada, E242, "nrf__clock_E");
   E221 : Short_Integer; pragma Import (Ada, E221, "nrf__ppi_E");
   E171 : Short_Integer; pragma Import (Ada, E171, "nrf__timers_E");
   E174 : Short_Integer; pragma Import (Ada, E174, "nrf__twi_E");
   E178 : Short_Integer; pragma Import (Ada, E178, "nrf__uart_E");
   E125 : Short_Integer; pragma Import (Ada, E125, "nrf__device_E");
   E191 : Short_Integer; pragma Import (Ada, E191, "microbit__console_E");
   E236 : Short_Integer; pragma Import (Ada, E236, "dfr0548_E");
   E238 : Short_Integer; pragma Import (Ada, E238, "microbit__i2c_E");
   E193 : Short_Integer; pragma Import (Ada, E193, "microbit__iosfortasking_E");
   E234 : Short_Integer; pragma Import (Ada, E234, "microbit__motordriver_E");
   E240 : Short_Integer; pragma Import (Ada, E240, "microbit__timehighspeed_E");
   E244 : Short_Integer; pragma Import (Ada, E244, "microbit__ultrasonic_E");
   E185 : Short_Integer; pragma Import (Ada, E185, "tasks_E");

   Sec_Default_Sized_Stacks : array (1 .. 5) of aliased System.Secondary_Stack.SS_Stack (System.Parameters.Runtime_Default_Sec_Stack_Size);

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
      Binder_Sec_Stacks_Count := 5;
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
      E142 := E142 + 1;
      System.Finalization_Root'Elab_Spec;
      E149 := E149 + 1;
      Ada.Finalization'Elab_Spec;
      E147 := E147 + 1;
      System.Storage_Pools'Elab_Spec;
      E151 := E151 + 1;
      System.Finalization_Masters'Elab_Spec;
      System.Finalization_Masters'Elab_Body;
      E146 := E146 + 1;
      Ada.Real_Time'Elab_Body;
      E187 := E187 + 1;
      System.Pool_Global'Elab_Spec;
      E153 := E153 + 1;
      System.Tasking.Protected_Objects'Elab_Body;
      E225 := E225 + 1;
      System.Tasking.Restricted.Stages'Elab_Body;
      E182 := E182 + 1;
      HAL.GPIO'ELAB_SPEC;
      E144 := E144 + 1;
      HAL.I2C'ELAB_SPEC;
      E176 := E176 + 1;
      HAL.SPI'ELAB_SPEC;
      E169 := E169 + 1;
      HAL.UART'ELAB_SPEC;
      E180 := E180 + 1;
      E198 := E198 + 1;
      E196 := E196 + 1;
      E215 := E215 + 1;
      Nrf.Gpio'Elab_Spec;
      Nrf.Gpio'Elab_Body;
      E135 := E135 + 1;
      E217 := E217 + 1;
      E219 := E219 + 1;
      E164 := E164 + 1;
      Nrf.Spi_Master'Elab_Spec;
      Nrf.Spi_Master'Elab_Body;
      E167 := E167 + 1;
      E202 := E202 + 1;
      E200 := E200 + 1;
      E242 := E242 + 1;
      E221 := E221 + 1;
      Nrf.Timers'Elab_Spec;
      Nrf.Timers'Elab_Body;
      E171 := E171 + 1;
      Nrf.Twi'Elab_Spec;
      Nrf.Twi'Elab_Body;
      E174 := E174 + 1;
      Nrf.Uart'Elab_Spec;
      Nrf.Uart'Elab_Body;
      E178 := E178 + 1;
      Nrf.Device'Elab_Spec;
      Nrf.Device'Elab_Body;
      E125 := E125 + 1;
      Microbit.Console'Elab_Body;
      E191 := E191 + 1;
      DFR0548'ELAB_SPEC;
      DFR0548'ELAB_BODY;
      E236 := E236 + 1;
      E238 := E238 + 1;
      Microbit.Iosfortasking'Elab_Spec;
      Microbit.Iosfortasking'Elab_Body;
      E193 := E193 + 1;
      Microbit.Motordriver'Elab_Body;
      E234 := E234 + 1;
      Microbit.Timehighspeed'Elab_Body;
      E240 := E240 + 1;
      E244 := E244 + 1;
      Tasks'Elab_Spec;
      Tasks'Elab_Body;
      E185 := E185 + 1;
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
   --   C:\Users\xboxl\Documents\Github\ABS_Precision_Systems\motor_driver_ravenscar\obj\tasks.o
   --   C:\Users\xboxl\Documents\Github\ABS_Precision_Systems\motor_driver_ravenscar\obj\main.o
   --   -LC:\Users\xboxl\Documents\Github\ABS_Precision_Systems\motor_driver_ravenscar\obj\
   --   -LC:\Users\xboxl\Documents\Github\ABS_Precision_Systems\motor_driver_ravenscar\obj\
   --   -LC:\Users\xboxl\Documents\Github\Libraries\Ada_Drivers_Library_j\boards\MicroBit_v2\obj\full_lib_Debug\
   --   -LC:\gnat\2021-arm-elf\arm-eabi\lib\gnat\ravenscar-full-nrf52833\adalib\
   --   -static
   --   -lgnarl
   --   -lgnat
--  END Object file/option list   

end ada_main;
