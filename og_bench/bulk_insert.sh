job_name="bulk_insert"
threads=2
time=60
port="5432"
tables_=(2 4 8 50)
table_size_=1000000



if [ "$port" = "5434" ]; then
    database="postgresql"
    user="sbtest"
    password="sbtest"
else
    database="opengauss"
    user="sbtest"
    password="Wzh@0401"
fi


for tables in ${tables_[@]} ; do
threads=$tables
cmd1="sysbench \
--threads=${threads} \
--time=${time} \
--report-interval=10 \
--db-driver=pgsql \
oltp_delete \
--pgsql-host=localhost \
--pgsql-port=${port} \
--pgsql-user=${user} \
--pgsql-password=${password} \
--pgsql-db=sbtest \
--tables=${tables} \
--table-size=${table_size} \
cleanup >> ${database}_${job_name}_threads_${threads}_time_${time}_tables_${tables}_table_size_${table_size}.log"
echo $cmd1
echo ${cmd1} >${database}_${job_name}_threads_${threads}_time_${time}_tables_${tables}_table_size_${table_size}.log
bash -c "$cmd1"


cmd2="sysbench \
--threads=${threads} \
--time=${time} \
--report-interval=10 \
--db-driver=pgsql \
${job_name} \
--pgsql-host=localhost \
--pgsql-port=${port} \
--pgsql-user=${user} \
--pgsql-password=${password} \
--pgsql-db=sbtest \
--tables=${tables} \
--table-size=${table_size} \
prepare >> ${database}_${job_name}_threads_${threads}_time_${time}_tables_${tables}_table_size_${table_size}.log"
echo $cmd2
echo ${cmd2} >${database}_${job_name}_threads_${threads}_time_${time}_tables_${tables}_table_size_${table_size}.log
bash -c "$cmd2"

cmd3="sysbench \
--threads=${threads} \
--time=${time} \
--report-interval=10 \
--db-driver=pgsql \
${job_name} \
--pgsql-host=localhost \
--pgsql-port=${port} \
--pgsql-user=${user} \
--pgsql-password=${password} \
--pgsql-db=sbtest \
--tables=${tables} \
--table-size=${table_size} \
run >> ${database}_${job_name}_threads_${threads}_time_${time}_tables_${tables}_table_size_${table_size}.log"

echo $cmd3
echo ${cmd3} >>${database}_${job_name}_threads_${threads}_time_${time}_tables_${tables}_table_size_${table_size}.log
bash -c "$cmd3"

echo $cmd1
echo ${cmd1} >>${database}_${job_name}_threads_${threads}_time_${time}_tables_${tables}_table_size_${table_size}.log
bash -c "$cmd1"

done