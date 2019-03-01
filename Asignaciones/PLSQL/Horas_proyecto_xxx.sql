select c.concepto_tesoreria
      ,ct.tipo_concepto
      ,sum(c.valor) valor
      ,sum(c.horas) horas
from contabilidad_x_proyecto c
    ,conceptos_tesoreria ct
where c.concepto_tesoreria = ct.codigo_concepto
  and c.periodo_liquidacion = 201511
  --and c.concepto_tesoreria = 'TOTAL_DEVENGADO'
  and c.tipo_id_empleado = 'CC'
  and c.numero_id_empleado = 19469140
group by c.concepto_tesoreria
      ,ct.tipo_concepto
;

select sum(pp.total_devengado )
from pagos_nomina pp
where pp.periodo_liquidacion = 201511
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

-- 23/12/2015 Costos x unidad y horas vendidas para presupuesto.
--   La información es la misma que se utiliza en contabilidad_x_proyecto, pero no se puede de esta tabla porque
--     solo queda el ultimo periodo, es mucho volumen.
select sum(valor)                       costo
      ,sum(horas)                       "unidades (horas)"
      ,sum(valor)/sum(horas)            costo_x_unidad
      ,sum(horas)/min(horas_periodo)    "personas calculadas"
from (
select pn.tipo_identificacion_empleado
      ,pn.numero_identificacion_empleado
      ,sum( nvl(BONIFICACIONES,0)+nvl(PREPAGADA, 0)+nvl(FONDO_EMPLEADOS, 0)+nvl(AUXILIO_SOCIOS, 0)+nvl(AUXILIO_MEDIOS_TRANSPORTE, 0)+nvl(AUXILIO_CELULAR, 0)+nvl(AUXILIO_EDUCATIVO, 0)+nvl(PROVISION_SALUD, 0)+nvl(PROVISION_PENSION, 0)+nvl(PROVISION_CAJA, 0)+nvl(PROVISION_SENA, 0)+nvl(PROVISION_ICBF, 0)+nvl(PROVISION_ARL, 0)+nvl(PROVISION_CESANTIAS, 0)+nvl(PROVISION_INTERESES_CESANTIAS, 0)+nvl(PROVISION_PRIMA, 0)+nvl(PROVISION_VACACIONES, 0)+nvl(ADMON_Y_OTR_CREDITOS, 0)+nvl(APOYO_SOSTENIMIENTO, 0)+nvl(AUX_TRANSPORTE, 0)+nvl(BONOS_CANASTA, 0)+nvl(BONOS_GASOLINA, 0)+nvl(COMISIONES_SAL_BASICO, 0)+nvl(CUENTAS_ALQUILER_EQUIPOS, 0)+nvl(CUENTAS_DIGITACION, 0)+nvl(CUENTAS_TRANSPORTE, 0)+nvl(DAFUTURO_ABIERTO, 0)+nvl(DAFUTURO_CERRADO, 0)+nvl(PRIMA_LEGAL, 0)+nvl(ESPECIAL_ABIERTO, 0)+nvl(ESPECIAL_CERRADO, 0)+nvl(HR_EXTRA_DIURNA_125, 0)+nvl(HR_EXTRA_FESTIVA_DIURNA, 0)+nvl(HR_EXTRA_FESTIVA_NOCTURNA, 0)+nvl(HR_EXTRA_NOCTURNA, 0)+nvl(INCAP_ENFERMEDAD_GRAL, 0)+nvl(INCAP_GRAL_TRES_DIAS, 0)+nvl(LIC_MATERNIDAD, 0)+nvl(LIC_PATERNIDAD, 0)+nvl(LIC_REMUNERADA, 0)+nvl(INTERESES_CESANTIA, 0)+nvl(VAC_DISFRUTADAS_SI, 0)+nvl(SALARIO_BASICO, 0)+nvl(SALARIO_INTEGRAL, 0)+nvl(VAC_DISFRUTADAS_B, 0)
          ) valor
      ,sum(a.duracion_horas ) horas
      ,min(n.horas_periodo) horas_periodo
from pagos_nomina pn
    ,liquidacion_nomina n
    ,dw_actividades a
    ,usr_metricas.dw_personas dwp
    ,personas p
where a.tipo_presupuesto = 'E'
  and a.dwtie_fecha between n.fecha_inicio_periodo and n.fecha_fin_periodo
  and a.dwper_consecutivo = dwp.consecutivo 
  and dwp.tipo_identificacion = p.tipo_identificacion
  and dwp.numero_identificacion = p.identificacion
  and p.tipo_identificacion = pn.tipo_identificacion_empleado
  and p.identificacion = pn.numero_identificacion_empleado
  --and a.dwpro_codigo = pn.codigo_servicio
  and n.periodo_liquidacion = 201511
  and pn.periodo_liquidacion = n.periodo_liquidacion
  and pn.tipo_identificacion_empleado = 'CC'
  and pn.numero_identificacion_empleado = 19469140
group by pn.tipo_identificacion_empleado
        ,pn.numero_identificacion_empleado
)
;

select pck_contabilidad_x_proyecto.parse_formula(ct.codigo_concepto, ct.formula)
        from conceptos_tesoreria ct
        where ct.codigo_concepto = 'TOTAL_DEVENGADO'
;

select nvl(BONIFICACIONES,0)+nvl(PREPAGADA, 0)+nvl(FONDO_EMPLEADOS, 0)+nvl(AUXILIO_SOCIOS, 0)+nvl(AUXILIO_MEDIOS_TRANSPORTE, 0)+nvl(AUXILIO_CELULAR, 0)+nvl(AUXILIO_EDUCATIVO, 0)+nvl(PROVISION_SALUD, 0)+nvl(PROVISION_PENSION, 0)+nvl(PROVISION_CAJA, 0)+nvl(PROVISION_SENA, 0)+nvl(PROVISION_ICBF, 0)+nvl(PROVISION_ARL, 0)+nvl(PROVISION_CESANTIAS, 0)+nvl(PROVISION_INTERESES_CESANTIAS, 0)+nvl(PROVISION_PRIMA, 0)+nvl(PROVISION_VACACIONES, 0)+nvl(ADMON_Y_OTR_CREDITOS, 0)+nvl(APOYO_SOSTENIMIENTO, 0)+nvl(AUX_TRANSPORTE, 0)+nvl(BONOS_CANASTA, 0)+nvl(BONOS_GASOLINA, 0)+nvl(COMISIONES_SAL_BASICO, 0)+nvl(CUENTAS_ALQUILER_EQUIPOS, 0)+nvl(CUENTAS_DIGITACION, 0)+nvl(CUENTAS_TRANSPORTE, 0)+nvl(DAFUTURO_ABIERTO, 0)+nvl(DAFUTURO_CERRADO, 0)+nvl(PRIMA_LEGAL, 0)+nvl(ESPECIAL_ABIERTO, 0)+nvl(ESPECIAL_CERRADO, 0)+nvl(HR_EXTRA_DIURNA_125, 0)+nvl(HR_EXTRA_FESTIVA_DIURNA, 0)+nvl(HR_EXTRA_FESTIVA_NOCTURNA, 0)+nvl(HR_EXTRA_NOCTURNA, 0)+nvl(INCAP_ENFERMEDAD_GRAL, 0)+nvl(INCAP_GRAL_TRES_DIAS, 0)+nvl(LIC_MATERNIDAD, 0)+nvl(LIC_PATERNIDAD, 0)+nvl(LIC_REMUNERADA, 0)+nvl(INTERESES_CESANTIA, 0)+nvl(VAC_DISFRUTADAS_SI, 0)+nvl(SALARIO_BASICO, 0)+nvl(SALARIO_INTEGRAL, 0)+nvl(VAC_DISFRUTADAS_B, 0)
from pagos_nomina pn
where pn.periodo_liquidacion = '201512'
  and pn.tipo_identificacion_empleado = 'CC'
  and pn.numero_identificacion_empleado = 19469140
;

