#!/bin/ksh 
#
# getSQLMON.sh
#
# Description:
#   get SQLMON for all queries with specific SQL_ID
#


export dt=`date '+%m%d%y_%H%M'`

if [ "X$1" == "X" ]; then
  print "Usage:  $0  <SQLPATTERN>\n"
  exit
fi

getsummary()
{
sqlplus -s '/as sysdba' <<!
set linesize 200
set pagesize 30

col SQLTXT format A20

select 
m.sql_id SQL_ID,  
m.SQL_EXEC_ID SQL_EXEC_ID, 
(SQL_EXEC_START-(TO_DATE('19700101000000', 'YYYYMMDDHH24MISS')))*86400 EPOCH,
--TO_CHAR(SQL_EXEC_START,'dd-Mon-yyyy hh:mi:ss PM') ,
substr(m.sql_text,0,20) SQLTXT, 
(m.last_refresh_time-m.sql_exec_start)*86400 Duration_secs
from gv\$sql_monitor m
where
  (
     --(upper(m.sql_text) like '%${1}%' and upper(m.sql_text) like 'SELECT%')
     m.sql_id in (select distinct sql_id from gv\$sqltext where upper(sql_text) like '%${1}%')
  )
  and m.status = 'DONE (ALL ROWS)' and PX_SERVER# is null
order by sql_id
/
exit
!

}

getsids()
{
sqlplus -s '/as sysdba' <<!
set heading off

col KEY format 99999999999999

select 'ZZZZZZZZZZZ', m.sql_id, m.SQL_EXEC_ID, (SQL_EXEC_START-(TO_DATE('19700101000000', 'YYYYMMDDHH24MISS')))*86400 EPOCH 
from gv\$sql_monitor m
where
  (
     --(upper(m.sql_text) like '%${1}%' and upper(m.sql_text) like 'SELECT%')
     m.sql_id in (select distinct sql_id from gv\$sqltext where upper(sql_text) like '%${1}%')
  )
  and m.status = 'DONE (ALL ROWS)' and PX_SERVER# is null
order by sql_id
/
exit
!

}


getoneSQLMON()
{
export sqlid=${1}
export sqlexecid=${2}
export epoch=${3}

export d=sqlmon_${dt}/sqlid_${sqlid}_epoch_${epoch}

mkdir -p $d

sqlplus '/as sysdba' <<!

spool off
set timing off
set autotrace off
set trimspool on
set trim on
set pagesize 0
set linesize 1000
set long 1000000
set longchunksize 1000000
spool sqlmon_sqlid_${sqlid}_execid_${sqlexecid}_epoch_${epoch}_dt_${dt}.txt
select dbms_sqltune.report_sql_monitor(sql_id=> '${sqlid}', sql_exec_id=>'${sqlexecid}', sql_exec_start=>to_date('1970-01-01','YYYY-MM-DD') + numtodsinterval(${epoch}, 'SECOND'), report_level=>'ALL',type=>'TEXT') from dual;
spool off
spool sqlmon_sqlid_${sqlid}_execid_${sqlexecid}_epoch_${epoch}_dt_${dt}.html
select dbms_sqltune.report_sql_monitor(sql_id=> '${sqlid}', sql_exec_id=>'${sqlexecid}', sql_exec_start=>to_date('1970-01-01','YYYY-MM-DD') + numtodsinterval(${epoch}, 'SECOND'), report_level=>'ALL',type=>'ACTIVE') from dual;

exit
!

mv sqlmon_sqlid_${sqlid}_execid_${sqlexecid}_epoch_${epoch}_dt_${dt}.txt ${d}
mv sqlmon_sqlid_${sqlid}_execid_${sqlexecid}_epoch_${epoch}_dt_${dt}.html ${d}
}


getsummary ${1} > sqlmon_summary_${dt}.txt

cat sqlmon_summary_${dt}.txt

print "Gather SQLMON reports for these SQLids"

getsids "${1}" | awk '/ZZZZZZZZZZZ/ {printf("%s %s %s\n",$2,$3,$4)}' |
while read sid_exec
do
getoneSQLMON $sid_exec  > getSQLMON.out 2>&1
done

mv sqlmon_summary_${dt}.txt sqlmon_${dt}

print "ALL done... Reports are in sqlmon_${dt}"



