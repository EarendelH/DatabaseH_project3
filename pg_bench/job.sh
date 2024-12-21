# job_names=("oltp_insert" "oltp_point_select" "oltp_update_non_index" "oltp_update_index " "oltp_delete "oltp_delete" "oltp_read_only" "oltp_write_only" "oltp_read_write "oltp_common" "select_random_points" "select_random_ranges")
job_names=("oltp_read_write")
threads=8
time="600"
port="5434"
tables_=(4)
table_size=1000000

if [ "$port" = "5434" ]; then
    database="postgresql"
    user="sbtest"
    password="sbtest"
else
    database="opengauss"
    user="sbtest"
    password="Wzh@0401"
fi

for job_name in ${job_names[@]} ; do

echo "starting ${job_name} test"
    for tables in ${tables_[@]} ; do


cmd="sysbench \
--threads=${threads} \
--time=${time} \
--report-interval=100 \
--db-driver=pgsql \
oltp_delete \
--pgsql-host=localhost \
--pgsql-port=${port} \
--pgsql-user=${user} \
--pgsql-password=${password} \
--pgsql-db=sbtest \
--tables=${tables} \
--table-size=${table_size} \
cleanup > ${database}_${job_name}_threads_${threads}_time_${time}_tables_${tables}_table_size_${table_size}.log"

bash -c "$cmd"

cmd1="sysbench \
--threads=${threads} \
--time=${time} \
--report-interval=100 \
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


echo $cmd1
echo " "
echo ${cmd1} >${database}_${job_name}_threads_${threads}_time_${time}_tables_${tables}_table_size_${table_size}.log
bash -c "$cmd1"

cmd2="sysbench \
--threads=${threads} \
--time=${time} \
--report-interval=100 \
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

echo $cmd2
echo " "
echo ${cmd2} >> ${database}_${job_name}_threads_${threads}_time_${time}_tables_${tables}_table_size_${table_size}.log
bash -c "$cmd2"

cmd3="sysbench \
--threads=${threads} \
--time=${time} \
--report-interval=100 \
--db-driver=pgsql \
oltp_delete \
--pgsql-host=localhost \
--pgsql-port=${port} \
--pgsql-user=${user} \
--pgsql-password=${password} \
--pgsql-db=sbtest \
--tables=${tables} \
--table-size=${table_size} \
cleanup>> ${database}_${job_name}_threads_${threads}_time_${time}_tables_${tables}_table_size_${table_size}.log"

echo $cmd3
echo " "
echo ${cmd3} >> ${database}_${job_name}_threads_${threads}_time_${time}_tables_${tables}_table_size_${table_size}.log
bash -c "$cmd3"

echo " "
echo "Job has finished, written to ${database}_${job_name}_threads_${threads}_time_${time}_tables_${tables}_table_size_${table_size}.log"

done
done