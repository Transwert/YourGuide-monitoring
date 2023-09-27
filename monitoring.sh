# To check if the container being exited are present, 
# If they are present, they will be removed so that new containers can be started

# To remove all running and non running containers, uncomment below line:
# docker rm $(docker stop $(docker ps -aq))

# To check if prometheus container is running or not:
container_name=prometheus
if sudo docker ps -a --format '{{.Names}}' | grep -Eq "^${container_name}\$"; then
    echo "$container_name Container exist";

    # To check if prometheus container is in exited state or not:
    if docker ps -a -f status=exited --format '{{.Names}}' | grep -Eq "^${container_name}\$"; then
        echo "But Since it is in exited state, so starting now";
        docker rm ${container_name}
        docker run -d --name prometheus  \
        -p 9090:9090 \
        -v /home/ubuntu/YourGuide-monitoring/prometheus_config.yml:/etc/prometheus/prometheus.yml \
        prom/prometheus
    fi
else
    docker run -d --name prometheus  \
        -p 9090:9090 \
        -v /home/ubuntu/YourGuide-monitoring/prometheus_config.yml:/etc/prometheus/prometheus.yml \
        prom/prometheus
fi

# To check if prometheus-pushgateway container is running or not:
container_name=pushgateway
if sudo docker ps -a --format '{{.Names}}' | grep -Eq "^${container_name}\$"; then
    echo "$container_name Container exist";

    # To check if prometheus-pushgateway container is in exited state or not:
    if docker ps -a -f status=exited --format '{{.Names}}' | grep -Eq "^${container_name}\$"; then
        echo "But Since it is in exited state, so starting now";
        docker rm ${container_name}
        docker run -d --name ${container_name} \
            -p 9091:9091 prom/pushgateway
    fi
else
    docker run -d --name ${container_name} \
        -p 9091:9091 prom/pushgateway
fi

# To check if Grafana container is running or not:
container_name=grafana
if sudo docker ps -a --format '{{.Names}}' | grep -Eq "^${container_name}\$"; then
    echo "$container_name Container exist";

    # To check if Grafana container is in exited state or not:
    if docker ps -a -f status=exited --format '{{.Names}}' | grep -Eq "^${container_name}\$"; then
        echo "But Since it is in exited state, so starting now";
        docker rm ${container_name}
        docker run -d -p 3000:3000 --name=${container_name} \
            --user "$(id -u)" \
            --volume /home/ubuntu/YourGuide-monitoring/monitoring_data:/var/lib/grafana \
            grafana/grafana-oss
    fi
else
    docker run -d -p 3000:3000 --name=${container_name} \
        --user "$(id -u)" \
        --volume /home/ubuntu/YourGuide-monitoring/monitoring_data:/var/lib/grafana \
        grafana/grafana-oss
fi