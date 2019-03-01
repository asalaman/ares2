CREATE OR REPLACE PACKAGE ARES2.pck_asignaciones AS
/******************************************************************************
   NAME:       pck_asignaciones
   PURPOSE:    Administraci�n de asignaci�n de personas a los proyectos.
               Planeaci�n, ejecuci�n y control de asignaciones.
               

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
    Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        26/04/2016      asalaman       Creaci�n

******************************************************************************/


  function dias_laborales(v_fecha_ini in date
                         ,v_fecha_fin in date
                         )
    return t_fechas deterministic;
    --  Genera fechas dia a dia de dias laborales en el rango de fechas dado
  procedure pueble_dias_laborales;

END pck_asignaciones;
/