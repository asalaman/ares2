CREATE OR REPLACE PACKAGE BODY ARES2.PCK_consultas_actividades AS
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
                                      ,v_fecha_fin in date) as
    -- Reporte actividades dia a dia en periodo dado, para un servicio dado. Genera excel

    i number(4);
    dia date;
    v_col_ini number(4);
    v_fila number(4);
    v_id_fila_act varchar2(200);
    v_id_fila_ant varchar2(200);
    v_fmt_dia varchar2(50) := '#,##0;[Red]#,##0';
    v_fmt_fecha varchar2(50) := 'dd-mon-yyyy';
    v_dia_seguimiento t_dia_actividad;
    v_query varchar2(4000);
    v_sqlerrm varchar2(4000);
    
    procedure encabezados_columna is
    begin
      xlsx_builder_pkg.set_row( v_fila, p_fillId => xlsx_builder_pkg.get_fill( 'solid', 'FFFFC7CE' ) )  ;
      xlsx_builder_pkg.cell(v_col_ini + 1, v_fila, 'Actividad');
      xlsx_builder_pkg.cell(v_col_ini + 2, v_fila, 'Responsable');
      xlsx_builder_pkg.cell(v_col_ini + 3, v_fila, 'Numero Responsables');
      xlsx_builder_pkg.cell(v_col_ini + 4, v_fila, 'Duración');
      i := 1;
      dia := v_fecha_inicio;
      v_dia_seguimiento := t_dia_actividad();
      while dia <= v_fecha_fin loop
        -- Tabla de dias del seguimiento
        v_dia_seguimiento.extend();
        v_dia_seguimiento(i) := t_dia(i, dia);
        -- Titulos de fila para los dias
        xlsx_builder_pkg.cell(i + 5, v_fila, dia);
        -- Formato de columna
        xlsx_builder_pkg.set_column(i + 5, p_numFmtId => xlsx_builder_pkg.get_numFmt(v_fmt_dia));
        dia := dia + 1;
        i := i + 1;
      end loop;
      v_fila := v_fila + 1;
    exception
      when OTHERS then
        v_sqlerrm := sqlerrm;
        raise_application_error(-20001, 'Error creandon encabezados de columna ' || v_sqlerrm);     
    end;

  begin
    v_col_ini := 1;
    v_fila := 3;
    xlsx_builder_pkg.new_sheet;
    encabezados_columna;
    -- Detalles
    v_id_fila_ant := ' ';
    v_id_fila_act := ' ';
    dbms_output.put_line(to_char(v_fila) || '.' || v_col_ini);
    for r_actividad in (select da.i_dia columna
                              ,ac.nombre_actividad
                              ,min(pe.nombres || ' ' || pe.apellidos) responsable
                              ,count(pe.nombres || ' ' || pe.apellidos) numero_responsables
                              ,max(ac.duracion) duracion_estimada
                              ,ea.fecha_ejecucion
                              ,sum(extract(hour from ea.duracion) + extract(minute from ea.duracion)/60) horas_dia
                        from ejecucion_actividades ea
                            ,asignaciones ag
                            ,personas pe
                            ,actividades ac
                            ,table(v_dia_seguimiento) da
                        where 
                              ea.con_asignacion = ag.consecutivo
                          and ea.con_actividad_id = ac.id
                          and ea.con_cronograma_id = ac.con_cronogramas
                          and ag.con_persona = pe.consecutivo
                          and ag.cod_servicio = v_codigo_servicio
                          and trunc(ea.fecha_ejecucion (+)) = trunc(da.dia)
                          and ea.fecha_ejecucion between v_fecha_inicio and v_fecha_fin
                        group by da.i_dia
                                ,ac.nombre_actividad
                                ,ea.fecha_ejecucion
                        order by ac.nombre_actividad
                                ,ea.fecha_ejecucion
                      ) loop
      begin
        if (v_fila between 1 and 10) then
          dbms_output.put_line(to_char(v_fila) || '.' || to_char(r_actividad.columna));
        end if;
        v_id_fila_ant := v_id_fila_act;
        v_id_fila_act := r_actividad.nombre_actividad;
        if v_id_fila_act != v_id_fila_ant then
          v_fila := v_fila + 1;
          xlsx_builder_pkg.cell(v_col_ini + 1, v_fila, r_actividad.nombre_actividad);
          xlsx_builder_pkg.cell(v_col_ini + 2, v_fila, r_actividad.responsable);
          xlsx_builder_pkg.cell(v_col_ini + 3, v_fila, r_actividad.numero_responsables);
          xlsx_builder_pkg.cell(v_col_ini + 4, v_fila, r_actividad.duracion_estimada);
        end if;
        xlsx_builder_pkg.cell(v_col_ini + 4 + r_actividad.columna, v_fila, r_actividad.horas_dia);
      exception
        when others then 
          raise;
      end;    
    end loop;
    xlsx_builder_pkg.save( 'DIR_ARES_II', 'actividades_dia.xlsx' );
    
  exception
    when others then
      v_sqlerrm := sqlerrm;
      raise_application_error(-20050, 'Error generando excel de actividades dia ' || v_sqlerrm);
  end actividades_ejecutadas_dia;

 
END PCK_CONSULTAS_actividades;
/