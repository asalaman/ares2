
select count(*)
from asignaciones_historicos;

-- Tabla

select dl.column_value
from table(pck_asignaciones.dias_laborales(sysdate, sysdate +3)) dl
;

begin
  pck_asignaciones.pueble_dias_laborales;
end;


-- Consultas

-- Asignación por persona en un rango de fecha dado
desc dwf_asignaciones;

select *
from dwf_asignaciones a
where a.nombre_persona like '%ALEJANDRO%SALAMANCA%'
  and fecha_inicio > to_date('01-04-2016','dd-mm-yyyy')
order by dia
