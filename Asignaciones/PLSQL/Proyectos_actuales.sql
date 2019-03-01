-- Proyectos actuales 
select e.nombre empresa
      ,s.codigo_servicio   codigo
      ,s.nombre   proyecto
      ,c.rv_meaning estado
      ,s.fecha_inicial
      ,s.fecha_final
      ,s.duracion_dias_estimado
      ,s.tamaño_estimado
from servicios s
    ,cg_ref_codes c
    ,empresas e
where c.rv_domain = 'ESTADO_PROYECTO'
  and c.rv_low_value = s.estado
  and rv_meaning = 'Abierto'
  and e.consecutivo = s.con_empresa_ofre
order by s.fecha_final desc
