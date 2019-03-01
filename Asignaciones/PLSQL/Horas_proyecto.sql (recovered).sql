select sum(valor)
from
(
select sum(c.valor) valor
      ,sum(c.horas) horas
from contabilidad_x_proyecto c
where c.periodo_liquidacion = 201705
  and c.concepto_tesoreria = 'TOTAL_DEVENGADO'
  --and c.TIPO_ID_EMPLEADO = 'CC'
  --and c.NUMERO_ID_EMPLEADO = 19469140
)
;

select sum(pp.total_devengado )
from pagos_nomina pp
where pp.periodo_liquidacion = 201705
  and pp.tipo_identificacion_empleado = 'CC'
  and pp.numero_identificacion_empleado = 19469140
;

select cp.codigo_servicio
      ,cp.concepto_tesoreria
      ,cp.valor
from contabilidad_x_proyecto cp
where cp.tipo_id_empleado = 'CC'
  and cp.numero_id_empleado = 19469140
order by valor
;

-- este query es el que se requiere para el costo por persona servicio y sus horas
-- lashoras no cuadran

select sum(valor)
      ,sum(horas)
      ,sum(horas)/min(horas_periodo)
from (
--;
select cp.codigo_servicio
      ,cp.tipo_id_empleado
      ,cp.numero_id_empleado
      ,sum(a.duracion_horas) horas 
      ,min(cp.valor) valor
      ,min(n.horas_periodo) horas_periodo
from contabilidad_x_proyecto cp
    ,liquidacion_nomina n
    ,dw_actividades a
    --,usr_metricas.dw_personas dwp
    --,personas p
where a.tipo_presupuesto = 'E'
  and a.dwtie_fecha between n.fecha_inicio_periodo and n.fecha_fin_periodo
  --and a.dwper_consecutivo = dwp.consecutivo 
  --and dwp.tipo_identificacion(+) = p.tipo_identificacion
  --and dwp.numero_identificacion(+) = p.identificacion
  --and dwp.TIPO_IDENTIFICACION = cp.tipo_id_empleado
  --and dwp.NUMERO_IDENTIFICACION = cp.numero_id_empleado
  and a.dwpro_codigo = cp.codigo_servicio
  and n.periodo_liquidacion = 201705
  and cp.periodo_liquidacion = n.periodo_liquidacion
  and cp.concepto_tesoreria = 'TOTAL_DEVENGADO'
--  and cp.tipo_id_empleado = 'CC'
--  and cp.numero_id_empleado = 19469140
group by cp.codigo_servicio
        ,cp.tipo_id_empleado
        ,cp.numero_id_empleado
--;
)
;



select p.consecutivo consecutivo
                        ,a.dwpro_codigo proyecto
                        ,sum (a.duracion_horas) horas 
                        ,ratio_to_report (sum (a.duracion_horas)) over (partition by p.consecutivo) porcentaje
                  from dw_actividades a
                      ,usr_metricas.dw_personas dwp
                      ,personas p
                  where a.tipo_presupuesto = 'E'
                    and a.dwtie_fecha between v_fecha_ini and v_fecha_fin
                    and a.dwper_consecutivo = dwp.consecutivo 
                    and dwp.tipo_identificacion = p.tipo_identificacion
                    and dwp.numero_identificacion = p.identificacion
                    and p.tipo_identificacion = v_tipo_id_empleado
                    and p.identificacion = v_numero_id_empleado
                  group by p.consecutivo
                          ,a.dwpro_codigo
;

