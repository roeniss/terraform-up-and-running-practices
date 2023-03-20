# stop all

tfenv use 1.4.0
CUR=$(pwd)
cd $CUR/src/live/prod/services/webserver-cluster && tfd -auto-approve &&\
cd $CUR/src/live/stage/services/webserver-cluster && tfd -auto-approve &&\
cd $CUR/src/live/stage/data-stores/mysql && tfd -auto-approve -var "db_password=12345678" &&\
cd $CUR/src/live/prod/data-stores/mysql && tfd -auto-approve -var "db_password=12345678"

# start all

tfenv use 1.4.0
CUR=$(pwd)
cd $CUR/src/live/prod/data-stores/mysql && tfa -auto-approve -var "db_password=12345678" &&\
cd $CUR/src/live/prod/services/webserver-cluster && tfa -auto-approve &&\
cd $CUR/src/live/stage/data-stores/mysql && tfa -auto-approve -var "db_password=12345678" &&\
cd $CUR/src/live/stage/services/webserver-cluster && tfa -auto-approve &&\
