[oracle@exa7db01 getSQLMON4]$ ./getSQLMON.sh RTL19

SQL_ID        SQL_EXEC_ID      EPOCH SQLTXT               DURATION_SECS
------------- ----------- ---------- -------------------- -------------
8g97qvjxkdvq5    16777218 1439194608 select /*+ RTL19 */              8
8g97qvjxkdvq5    16777216 1439194779 select /*+ RTL19 */              3
8g97qvjxkdvq5    16777216 1439363758 select /*+ RTL19 */              2

Gather SQLMON reports for these SQLids
ALL done... Reports are in sqlmon_081215_1308


[oracle@exa7db01 sqlmon_081215_1308]$ cat sqlmon_summary_081215_1308.txt

SQL_ID        SQL_EXEC_ID      EPOCH SQLTXT               DURATION_SECS
------------- ----------- ---------- -------------------- -------------
8g97qvjxkdvq5    16777218 1439194608 select /*+ RTL19 */              8
8g97qvjxkdvq5    16777216 1439194779 select /*+ RTL19 */              3
8g97qvjxkdvq5    16777216 1439363758 select /*+ RTL19 */              2


[oracle@exa7db01 sqlmon_081215_1308]$ ls -ltr sqlid*
sqlid_8g97qvjxkdvq5_epoch_1439363758:
total 36
-rw-r--r-- 1 oracle oinstall 14536 Aug 12 13:08 sqlmon_sqlid_8g97qvjxkdvq5_execid_16777216_epoch_1439363758_dt_081215_1308.txt
-rw-r--r-- 1 oracle oinstall 16877 Aug 12 13:08 sqlmon_sqlid_8g97qvjxkdvq5_execid_16777216_epoch_1439363758_dt_081215_1308.html

sqlid_8g97qvjxkdvq5_epoch_1439194779:
total 36
-rw-r--r-- 1 oracle oinstall 14716 Aug 12 13:08 sqlmon_sqlid_8g97qvjxkdvq5_execid_16777216_epoch_1439194779_dt_081215_1308.txt
-rw-r--r-- 1 oracle oinstall 17230 Aug 12 13:08 sqlmon_sqlid_8g97qvjxkdvq5_execid_16777216_epoch_1439194779_dt_081215_1308.html

sqlid_8g97qvjxkdvq5_epoch_1439194608:
total 36
-rw-r--r-- 1 oracle oinstall 14535 Aug 12 13:08 sqlmon_sqlid_8g97qvjxkdvq5_execid_16777218_epoch_1439194608_dt_081215_1308.txt
-rw-r--r-- 1 oracle oinstall 18415 Aug 12 13:08 sqlmon_sqlid_8g97qvjxkdvq5_execid_16777218_epoch_1439194608_dt_081215_1308.html


