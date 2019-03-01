create or replace type t_fechas is table of date;
/*
   Genera fechas dia a dia de dias laborales en el rango de fechas dado
*/
create function dias_laborales(v_fecha_ini in date
                              ,v_fecha_fin in date
                              )
  return t_fechas deterministic pipelined as
  v_fechas      t_fechas;
  v_fecha_act   date;
  i             integer := 1;
begin
  v_fechas := new t_fechas();
  v_fecha_act := v_fecha_ini;
  while v_fecha_act <= v_fecha_fin
  loop
    v_fechas.extend();
    v_fechas(i) := v_fecha_act;
    v_fecha_act := v_fecha_act + 1;
    i := i +1;
  end loop;
  
  return v_fechas;
end dias_laborales;
/