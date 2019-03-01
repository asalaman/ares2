CREATE OR REPLACE PACKAGE BODY ARES2.pck_asignaciones AS
/******************************************************************************
   NAME:       pck_asignaciones
   PURPOSE:    Administración de asignación de personas a los proyectos.
               Planeación, ejecución y control de asignaciones.
               

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
    Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        26/04/2016      asalaman       Creación
******************************************************************************/


  type t_fechas is table of date;

  function dias_laborales(v_fecha_ini in date
                         ,v_fecha_fin in date
                         )
    return t_fechas deterministic as
    --  Genera fechas dia a dia de dias laborales en el rango de fechas dado
    v_fechas      t_fechas;
    v_fecha_act   date;
    i             integer := 1;
  begin
    v_fechas := new t_fechas();
    v_fecha_act := v_fecha_ini;
    while v_fecha_act <= v_fecha_fin
    loop
      if not pck_presupuesto.es_festivo(v_fecha_act) then
        v_fechas.extend();
        v_fechas(i) := v_fecha_act;
        i := i +1;
      end if;
      v_fecha_act := v_fecha_act + 1;
    end loop;
    
    return v_fechas;
    
  end dias_laborales;
  
  procedure pueble_dias_laborales is
  begin
    insert into dias_laborales (dia)
    select *
    from table(dias_laborales(to_date('01-01-2015', 'dd-mm-yyyy'), to_date('31-12-2017', 'dd-mm-yyyy')));
  end pueble_dias_laborales;

/*
-- 
-- Esquema de Asignaciones. ddl_asignaciones.sql
-- 15/04/2016   asalaman  Generacion de asignaciones diarias por persona. Creación
-- 29/04/2016   asalaman  Generación de consultas de resumen. Preparación para visualizar.
-- 14/06/2016   asalaman  Publicación. Comentarios de vista y columna.
-- 

create or replace view bi_asignaciones_diaria as
  select p.nombres || ' ' || p.apellidos  nombre_persona
        ,s.codigo_servicio                codigo_servicio
        ,s.nombre                         nombre_servicio
        ,ar.descripcion                   area
        ,rn.nombre                        rol
        ,c.nombre                         cargo
        --,ah.fecha_inicio                  fecha_inicio
        --,ah.fecha_fin                     fecha_fin
        ,case ah.tiempo
           when 'Tiempo completo' then
             1
           when 'Medio Tiempo' then
             0.5
           when 'Cuarto Tiempo' then
             0.25
           else
             0
         end                              dedicacion
        ,dl.dia                           dia
  from asignaciones_historicos ah
      ,asignaciones a
      ,personas p
      ,roles_personas rp
      ,roles_negocio rn
      ,cargos c
      ,servicios s
      ,areas ar
      ,dias_laborales dl
  where ah.con_asig = a.consecutivo
    and a.cod_servicio = s.codigo_servicio
    and a.con_persona = p.consecutivo
    and a.con_rol_persona = rp.consecutivo
    and rp.con_rol_negocio = rn.consecutivo
    and rp.con_persona = p.consecutivo
    and p.con_cargo = c.consecutivo
    and ar.consecutivo = c.con_area
    and dl.dia between ah.fecha_inicio and ah.fecha_fin
;

comment on table bi_asignaciones_diaria is 'Asignación diaria por persona y servicio (proyecto)';
comment on column bi_asignaciones_diaria.nombre_persona is 'Nombres y apellidos de la persona';
comment on column bi_asignaciones_diaria.codigo_servicio is 'Codigo del servicio o proyecto';
comment on column bi_asignaciones_diaria.nombre_servicio is 'Nombre completo del servicio';
comment on column bi_asignaciones_diaria.area is 'Area que ejecuta el servicio';
comment on column bi_asignaciones_diaria.rol is 'Rol de la persona en el servicio';
comment on column bi_asignaciones_diaria.dedicacion is 'Dedicacion (0,5 Medio Tiempo; 1 Tiempo Completo; ...)';
comment on column bi_asignaciones_diaria.dia is 'Fecha del dia de la asignacion';

*/
 
END pck_asignaciones;
/