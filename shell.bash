#!/bin/bash
appname="pureftpd"
host="0.0.0.0"
ftpusers="$(pwd)/ftpusers"

run() {
    echo "docker run \
        -e PUBLICHOST=$host \
        -v $ftpusers:/home/ftpusers
        --name=$appname \
        -p 21:21 \
        -p 20:20 \
        -p 21100-21110:21100-21110
        -d \
        --restart=unless-stopped $appname"
}

stopall() {
    docker ps | grep $appname | awk 'FNR > 0 {print $1}' | xargs docker rm -f
}

if [ $1 == "local" ]
  then

    if [ $2 == "deploy" ]
      then
        docker build -t $appname .
        stopall
        eval $(run)
    fi

    if [ $2 == "stop" ]
      then
        stopall
    fi

    if [ $2 == "exec" ]
      then
        docker exec -it $3 $4
    fi

    if [ $2 == "start" ]
      then
        docker start $3
    fi

    if [ $2 == "logs" ]
      then
        docker logs -f $3
    fi
fi