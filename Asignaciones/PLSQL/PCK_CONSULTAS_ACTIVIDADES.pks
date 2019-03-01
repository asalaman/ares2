CREATE OR REPLACE PACKAGE ARES2.pck_consultas_actividades AS
/******************************************************************************
   NAME:       pck_consultas
   PURPOSE:    Metodos de consultas de las actividades ejecutadas y presupuestadas
               Generan excel de las consultas detalladas o resumidas.
               

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
    Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        03/11/2011      asalaman       Creación

******************************************************************************/


  procedure actividades_ejecutadas_dia(v_codigo_servicio in servicios.codigo_servicio%type
                                      ,v_fecha_inicio in date
                                      ,v_fecha_fin in date);
    -- Reporte actividades dia a dia en periodo dado, para un servicio dado. Genera excel
    


END pck_consultas_actividades;
/