-- 
-- Esquema de Asignaciones
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
        ,case upper(ah.tiempo)
           when 'TIEMPO COMPLETO' then
             1
           when 'MEDIO COMPLETO' then
             0.5
           when 'CUARTO TIEMPO' then
             0.25
           else
             0
         end                              dedicacion
        ,ah.tiempo                        tiempo
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
