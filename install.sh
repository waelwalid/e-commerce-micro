#!/bin/bash
# set -x
# set -e

GREEN="\033[32m"
NC='\033[0m' # No Color

GIT_URL="git@github.com:waelwalid"
PATH_CURRENT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PATH_ROOT="${PATH_CURRENT}/../"
PATH_WWW="${PATH_ROOT}www/"
PATH_SEEDERS_MYSQL="${PATH_ROOT}/seeders"
# MYSQL configurations
database_local_schemas=("catalog_service")

echo -e "${GREEN}Cloning Application Repositories${NC}"


declare -A services
services["e-authentication"]="main";
services["e-catalog-service"]="main";
services["e-nginx-proxy"]="main";
necessary_application=("mysqldb" "mongodb" "e-catalog-service" "e-authentication")

function install_dependencies() {
    # http://www.figlet.org/
    # https://en.wikipedia.org/wiki/Cowsay
    # https://boxes.thomasjensen.com/
    sudo apt install -y golang boxes curl
    sudo snap install kubectl --classic

    # Hosts Manager Go Cli
    go install github.com/cbednarski/hostess@latest
}

function update_hosts() {
    local dockercomposefile
    local "${@}"
    if [ -z $dockercomposefile ]; then
        dockercomposefile="./docker-compose.yml"
    fi
    echo "$dockercomposefile"

    #Extract domain and ip from docker compose file
    ip=""
    domainsite="no"
    while IFS= read -r line; do
        if [[ $line == *"ipv4_address:"* ]]; then
            ip="${line/ipv4_address:/}"
            ip="${ip//' '/}"
            continue
        fi
        if [[ $line == *"aliases:"* ]]; then
            domainsite="yes"
            continue
        fi
        if [[ $domainsite == "yes" ]]; then
            if [[ $line == *".local"* ]]; then
                domain="${line//' - '/}"
                domain="${domain//' '/}"
                if [ "${domain:0:1}" != '#' ]; then
                    sudo $HOME/go/bin/hostess add $domain $ip
                else
                    echo "Ignoring line: $line"
                fi
            else
                domainsite="no"
            fi
        fi
    done <"$dockercomposefile"
}

function update_repositories() {
    cd www

    for KEY in "${!services[@]}"; do
        APP=$KEY
        APP_PATH="${PATH_CURRENT}/www/${APP}"
        DEFAULT_BRANCH="${services[$KEY]}"
        # if [[ -z $DEFAULT_BRANCH ]]; then
        #     DEFAULT_BRANCH='dev-testing'
        # fi
        

        if [[ -d $APP_PATH ]]; then
            echo "Running git checkout $DEFAULT_BRANCH on $APP"
            pushd "$APP_PATH"
            EXITCODE=$(
                git checkout $DEFAULT_BRANCH >/dev/null 2>&1
                echo $?
            )
            if [ $EXITCODE -ne 0 ]; then
                echo "Don't be possible run CHECKOUT to $DEFAULT_BRANCH on $APP. Reason:"
                git status
            fi
            echo "Running git pull on $APP"
            git pull
            popd
        else
            echo "Running git clone for $APP"
            pushd "${PATH_CURRENT}/www"
            git clone "$GIT_URL/$APP"
            echo $?
            popd
        fi

        EXITCODE=$(
                git checkout $DEFAULT_BRANCH >/dev/null 2>&1
                echo $?
        )

    done

    cd ..
}

function build() {
        docker network create net_range
        for APPDATA in "${necessary_application[@]}"; do
            echo -e "${GREEN}Build DockerImages${NC} $APPDATA"
            sleep 5
            docker-compose build --compress --force-rm $APPDATA
        done

}


function create_databases() {
    docker-compose up -d mysqldb

    while :; do
        docker exec -i mysqldb mysql -uroot -proot  <<< "ALTER USER 'root'@'localhost' IDENTIFIED WITH caching_sha2_password BY 'root'; FLUSH PRIVILEGES; SELECT user,authentication_string,plugin,host FROM mysql.user;"
        
        
        CBCLUSTERVERIFY_DATABASE=$(echo $?)
        echo "Waiting service into database is up. Last return: $CBCLUSTERVERIFY_DATABASE. Expected: 0"
        if [ "$CBCLUSTERVERIFY_DATABASE" == '0' ]; then
            QUERY_CREATE_DATABASE=""
            for SCHEMA in "${database_local_schemas[@]}"; do
                QUERY_CREATE_DATABASE+="CREATE DATABASE IF NOT EXISTS ${SCHEMA}; "
            done
            echo -e "${GREEN}Create databases${NC} \n ${QUERY_CREATE_DATABASE}"
            docker exec mysqldb mysql --user=root --password=root -e "${QUERY_CREATE_DATABASE}" 2>/dev/null
            break
        fi
        sleep 5

        
    done
    docker exec -i mysqldb mysql -uroot -proot catalog_service < ./www/e-catalog-service/dump/catalog_service.sql
}

function up_dev() {
        
        sleep 3
        
        for APPDATA in "${necessary_application[@]}"; do
            echo -e "${GREEN}Running the Container${NC} $APPDATA"
            docker-compose up -d $APPDATA
            sleep 5
        done
        echo -e "${GREEN} Building Necessary apps ...${NC} \n"
        sleep 5
        docker-compose up
}

if [ -z $@ ]; then
    install_dependencies
    update_repositories
    update_hosts
    build
    create_databases
    up_dev
fi


$@
