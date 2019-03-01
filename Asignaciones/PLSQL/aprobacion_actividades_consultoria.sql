-- 04/07/2017   asalaman  Creacion

-- I- Los jefes que aprueban las actividades
select j.nombres || ' ' || j.apellidos      jefe
      ,p.nombres || ' ' || p.apellidos      persona
from personas p
    ,personas j
where p.con_jefe = j.consecutivo 
  and (   p.nombres || ' ' || p.apellidos like '%RIBEIRO%'
       or p.nombres || ' ' || p.apellidos like upper('%John%Herrera')
       or p.nombres || ' ' || p.apellidos like upper('%Juan%Carlos%Lores%')
       or p.nombres || ' ' || p.apellidos like upper('%Cristian%Camilo%Benavides%')
       or p.nombres || ' ' || p.apellidos like upper('%Jhon%Freddy%Herrera%')
       or p.nombres || ' ' || p.apellidos like upper('%Ramiro%Villaveces%')
       or p.nombres || ' ' || p.apellidos like upper('%Jos%davi%Rodriguez%')
       or p.nombres || ' ' || p.apellidos like upper('%Jesus%daniel%Rodriguez%')
       or p.nombres || ' ' || p.apellidos like upper('%Octavio%')
       or p.nombres || ' ' || p.apellidos like upper('%Ana%Arias%')
      )
;

-- Los Directores de proyecto, de los proyectos actuales en el periodo dado
select p.nombres || ' ' || p.apellidos  nombre_persona
        ,s.codigo_servicio                codigo_servicio
        ,s.nombre                         nombre_servicio
        ,ar.descripcion                   area
        ,rn.nombre                        rol
        ,c.nombre                         cargo
        ,ah.fecha_inicio                  fecha_inicio
        ,ah.fecha_fin                     fecha_fin
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
        --,dl.dia                           dia
  from asignaciones_historicos ah
      ,asignaciones a
      ,personas p
      ,roles_personas rp
      ,roles_negocio rn
      ,cargos c
      ,servicios s
      ,areas ar
      --,dias_laborales dl
  where ah.con_asig = a.consecutivo
    and a.cod_servicio = s.codigo_servicio
    and s.ESTADO = 1
    and a.con_persona = p.consecutivo
    and a.con_rol_persona = rp.consecutivo
    and rp.con_rol_negocio = rn.consecutivo
    and rp.con_persona = p.consecutivo
    and p.con_cargo = c.consecutivo
    and ar.consecutivo = c.con_area
    --and dl.dia between ah.fecha_inicio and ah.fecha_fin
    --and dl.dia between to_date('01/05/2017', 'dd/mm/yyyy') and to_date('30/05/2017', 'dd/mm/yyyy')
    --and p.identificacion = 19469140
    and a.responsable = 'S'
--    and s.codigo_servicio = 'CO_549'
  order by codigo_servicio
          ,fecha_inicio
;

-- Asignacion a proyectos para comparar contra lo ejecutado
select p.nombres || ' ' || p.apellidos  nombre_persona
        ,s.codigo_servicio                codigo_servicio
        ,s.nombre                         nombre_servicio
        ,ar.descripcion                   area
        ,rn.nombre                        rol
        ,c.nombre                         cargo
        ,ah.fecha_inicio                  fecha_inicio
        ,ah.fecha_fin                     fecha_fin
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
        --,dl.dia                           dia
  from 
       asignaciones_historicos ah
      ,asignaciones a
      ,personas p
      ,roles_personas rp
      ,roles_negocio rn
      ,cargos c
      ,servicios s
      ,areas ar
      --,dias_laborales dl
  where ah.con_asig = a.consecutivo
    and a.cod_servicio = s.codigo_servicio
    and a.con_persona = p.consecutivo
    and a.con_rol_persona = rp.consecutivo
    and rp.con_rol_negocio = rn.consecutivo
    and rp.con_persona = p.consecutivo
    and p.con_cargo = c.consecutivo
    and ar.consecutivo = c.con_area
    --and dl.dia between  to_date('01/07/2017', 'dd/mm/yyyy') and to_date('30/07/2017', 'dd/mm/yyyy')
    and ah.fecha_inicio <= to_date('30/07/2017', 'dd/mm/yyyy') and ah.fecha_fin >= to_date('01/07/2017', 'dd/mm/yyyy')  
    and p.identificacion = 19469140
;


-- II- Servicios donde soy el unico responsable

select se.CODIGO_SERVICIO
      ,se.NOMBRE
      --,p.nombres || ' ' || p.apellidos nombre
from asignaciones a
    ,servicios se
    ,personas p
where p.consecutivo = a.con_persona
  and se.codigo_servicio = a.cod_servicio
  and a.responsable = 'S'
minus
select se.CODIGO_SERVICIO
      ,se.NOMBRE
      --,p.nombres || ' ' || p.apellidos nombre
from asignaciones a
    ,servicios se
    ,personas p
where p.consecutivo = a.con_persona
  and se.codigo_servicio = a.cod_servicio
  and a.responsable = 'S'
  and p.tipo_identificacion = 'CC'
  and p.identificacion != 19469140 ;
;

-- II- Servicios donde soy el jefe

select se.CODIGO_SERVICIO
      ,se.NOMBRE
      --,p.nombres || ' ' || p.apellidos nombre
from asignaciones a
    ,servicios se
    ,personas p
where p.consecutivo = a.con_persona
  and se.codigo_servicio = a.cod_servicio
  and a.responsable = 'S'
minus
select se.CODIGO_SERVICIO
      ,se.NOMBRE
      --,p.nombres || ' ' || p.apellidos nombre
from asignaciones a
    ,servicios se
    ,personas p
where p.consecutivo = a.con_persona
  and se.codigo_servicio = a.cod_servicio
  and a.responsable = 'S'
  and p.tipo_identificacion = 'CC'
  and p.identificacion != 19469140 ;
;


-- V- Actividades de las personas a mi cargo (soy el jefe) 
--    Con el Director de proyecto responsable
--    Con el jefe de area. La estructura nueva matricial


-- VI- Actividades por aprobar. De los servicios donde soy responsable y jefe de la persona
update ejecucion_actividades ea
set estado = 'APROBADO'
where ea.consecutivo in 
(
select 
       a.consecutivo
       /*
j.nombres || ' ' || j.apellidos     jefe
       -- Director de proyecto
      -- Jefe de Area
      ,p.nombres || ' ' || p.apellidos     persona
      ,asig.cod_servicio
      ,a.*
      */
from ejecucion_actividades a
    ,personas p
    ,personas j
    ,asignaciones asig
where a.fecha_ejecucion between to_date('21/07/2017', 'dd/mm/yyyy') and to_date('27/07/2017', 'dd/mm/yyyy')
  and a.consecutivo_persona = p.consecutivo 
  and p.con_jefe = j.consecutivo
  and j.tipo_identificacion = 'CC'
  and j.identificacion = 19469140 
  and a.con_asignacion =asig.consecutivo
  and a.estado like '%PENDIENTE%'
  -- y el servicio es donde soy responsable, i.e. el query de abajo
/*
  and asig.cod_servicio in 
  (
  select s.codigo_servicio                codigo_servicio
          from 
       asignaciones_historicos ah
      ,asignaciones a
      ,personas p
      ,roles_personas rp
      ,roles_negocio rn
      ,cargos c
      ,servicios s
      ,areas ar
      --,dias_laborales dl
  where ah.con_asig = a.consecutivo
    and a.cod_servicio = s.codigo_servicio
    and a.con_persona = p.consecutivo
    and a.con_rol_persona = rp.consecutivo
    and rp.con_rol_negocio = rn.consecutivo
    and rp.con_persona = p.consecutivo
    and p.con_cargo = c.consecutivo
    and ar.consecutivo = c.con_area
    --and dl.dia between  to_date('01/07/2017', 'dd/mm/yyyy') and to_date('30/07/2017', 'dd/mm/yyyy')
    and ah.fecha_inicio <= to_date('06/07/2017', 'dd/mm/yyyy') and ah.fecha_fin >= to_date('30/06/2017', 'dd/mm/yyyy')  
    and p.identificacion = 19469140
)
*/
--order by persona, asig.cod_servicio, a.consecutivo
)
;

-- Chequeos de consistencia:
--   Horas ejecutadas >= Horas por periodo
--   Actividades menores de 2 horas.
--   Descripción cambie de acuerdo a la actividad, no siempre lo mismo. Para eso es la etapa o entregable.
--   Que reflejen el estado del proyecto ???
select 
       j.nombres || ' ' || j.apellidos     jefe
      ,p.nombres || ' ' || p.apellidos     persona
      ,a.fecha_ejecucion
      ,sum(duracion_horas) horas_dia
      ,count(*) numero_actividades
      -- Una funcion de relevancia sobre las frases, que aprenda 
      --, Por el momento que tenga mas de 20 palabras
      --,length(a.descripcion) - length(replace(a.descripcion, ' ', '')) + 1  palabras
from ejecucion_actividades a
    ,personas p
    ,personas j
    ,asignaciones asig
where a.fecha_ejecucion between to_date('13/10/2017', 'dd/mm/yyyy') and to_date('26/10/2017', 'dd/mm/yyyy')
  and a.consecutivo_persona = p.consecutivo 
  and p.con_jefe = j.consecutivo
  and j.tipo_identificacion = 'CC'
  and j.identificacion = 19469140 
  and a.con_asignacion =asig.consecutivo
  and a.estado like '%%'
group by j.nombres || ' ' || j.apellidos
         ,p.nombres || ' ' || p.apellidos
         ,a.fecha_ejecucion
order by persona
        ,fecha_ejecucion
;

-------------
-- Actividades de adm0001 Ingresos
---------------
select 
       a.consecutivo
       -- Director de proyecto
       -- Jefe de Area
       ,j.nombres || ' ' || j.apellidos     jefe
      ,p.nombres || ' ' || p.apellidos     persona
      ,asig.cod_servicio
      ,a.fecha_ejecucion
      ,duracion_horas
      ,a.estado
      ,a.descripcion
      ,codigo_etapa
from ejecucion_actividades a
    ,personas p
    ,personas j
    ,asignaciones asig
where a.fecha_ejecucion between to_date('01/07/2017', 'dd/mm/yyyy') and to_date('31/07/2017', 'dd/mm/yyyy')
  and a.consecutivo_persona = p.consecutivo 
  and p.con_jefe = j.consecutivo
  --and j.tipo_identificacion = 'CC'
  --and j.identificacion = 19469140 
  and a.con_asignacion =asig.consecutivo
  and a.estado like '%%'
  --and asig.cod_servicio = 'ADM_001'
  -- y el servicio es donde soy responsable, i.e. el query de abajo
/*
  and asig.cod_servicio in 
  (
  select s.codigo_servicio                codigo_servicio
          from 
       asignaciones_historicos ah
      ,asignaciones a
      ,personas p
      ,roles_personas rp
      ,roles_negocio rn
      ,cargos c
      ,servicios s
      ,areas ar
      --,dias_laborales dl
  where ah.con_asig = a.consecutivo
    and a.cod_servicio = s.codigo_servicio
    and a.con_persona = p.consecutivo
    and a.con_rol_persona = rp.consecutivo
    and rp.con_rol_negocio = rn.consecutivo
    and rp.con_persona = p.consecutivo
    and p.con_cargo = c.consecutivo
    and ar.consecutivo = c.con_area
    --and dl.dia between  to_date('01/07/2017', 'dd/mm/yyyy') and to_date('30/07/2017', 'dd/mm/yyyy')
    and ah.fecha_inicio <= to_date('06/07/2017', 'dd/mm/yyyy') and ah.fecha_fin >= to_date('30/06/2017', 'dd/mm/yyyy')  
    and p.identificacion = 19469140
)
*/
order by persona, asig.cod_servicio, a.consecutivo
;


-- Chequeo en la nomina
--   Horas reportadas por persona, luego validar que estén aprobadas.
select 
       j.nombres || ' ' || j.apellidos     jefe
      ,p.nombres || ' ' || p.apellidos     persona
      ,p.FECHA_INGRESO
      ,p.FECHA_RETIRO
      ,(pck_presupuesto.dias_habiles(greatest(p.fecha_ingreso, to_date('01/' || to_char(sysdate, 'mm/yyyy'))), least(nvl(p.fecha_retiro, sysdate), sysdate)) - 1) * 8   horas
      ,sum(duracion_horas) horas_dia
      ,  sum(duracion_horas) 
       - ((pck_presupuesto.dias_habiles(greatest(p.fecha_ingreso, to_date('01/' || to_char(sysdate, 'mm/yyyy'))), least(nvl(p.fecha_retiro, sysdate), sysdate)) - 1) * 8 ) diferencia
      ,count(*) numero_actividades
      ,max(a.fecha_ejecucion)
from ejecucion_actividades a
    ,personas p
    ,personas j
    ,asignaciones asig
where a.fecha_ejecucion between to_date('01/07/2017', 'dd/mm/yyyy') and to_date('27/07/2017', 'dd/mm/yyyy')
  and a.consecutivo_persona = p.consecutivo 
  and p.con_jefe = j.consecutivo
  --and j.tipo_identificacion = 'CC'
  --and j.identificacion = 19469140 
  and a.con_asignacion =asig.consecutivo
  and a.estado like '%%'
group by j.nombres || ' ' || j.apellidos
         ,p.nombres || ' ' || p.apellidos
      ,p.FECHA_INGRESO
      ,p.FECHA_RETIRO
order by sum(duracion_horas)  desc
;

select 18 * 8
from dual
;

