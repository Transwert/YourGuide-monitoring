#!/usr/env/bin bash

# To check if the container being exited are present, 
# If they are present, they will be removed so that new containers can be started

# To remove all running and non running containers, uncomment below line:
# docker rm $(docker stop $(docker ps -aq))

# To check if prometheus container is running or not:
container_name=prometheus
if sudo docker ps -a --format '{{.Names}}' | grep -Eq "^${container_name}\$"; then
    echo "$container_name Container exist";

    # To check if prometheus container is in exited state or not:
    if sudo docker ps -a -f status=exited --format '{{.Names}}' | grep -Eq "^${container_name}\$"; then
        echo "But Since it is in exited state, so starting now";
        sudo docker rm ${container_name}
        sudo docker run -d --name prometheus  \
        -p 9090:9090 \
        -v /home/ubuntu/YourGuide-monitoring/prometheus_config.yml:/etc/prometheus/prometheus.yml \
        prom/prometheus
    fi
else
    sudo docker run -d --name prometheus  \
        -p 9090:9090 \
        -v /home/ubuntu/YourGuide-monitoring/prometheus_config.yml:/etc/prometheus/prometheus.yml \
        prom/prometheus
fi

# To check if prometheus-pushgateway container is running or not:
container_name=pushgateway
if sudo docker ps -a --format '{{.Names}}' | grep -Eq "^${container_name}\$"; then
    sudo echo "$container_name Container exist";

    # To check if prometheus-pushgateway container is in exited state or not:
    if sudo docker ps -a -f status=exited --format '{{.Names}}' | grep -Eq "^${container_name}\$"; then
        echo "But Since it is in exited state, so starting now";
        sudo docker rm ${container_name}
        sudo docker run -d --name ${container_name} \
            -p 9091:9091 prom/pushgateway
    fi
else
    sudo docker run -d --name ${container_name} \
        -p 9091:9091 prom/pushgateway
fi

# To check if Grafana container is running or not:
container_name=grafana
if sudo docker ps -a --format '{{.Names}}' | grep -Eq "^${container_name}\$"; then
    echo "$container_name Container exist";

    # To check if Grafana container is in exited state or not:
    if sudo docker ps -a -f status=exited --format '{{.Names}}' | grep -Eq "^${container_name}\$"; then
        echo "But Since it is in exited state, so starting now";
        sudo docker rm ${container_name}
        sudo docker run -d -p 3000:3000 --name=${container_name} \
            --user "$(id -u)" \
            --volume /home/ubuntu/YourGuide-monitoring/monitoring_data:/var/lib/grafana \
            grafana/grafana-oss
    fi
else
    sudo docker run -d -p 3000:3000 --name=${container_name} \
        --user "$(id -u)" \
        --volume /home/ubuntu/YourGuide-monitoring/monitoring_data:/var/lib/grafana \
        grafana/grafana-oss
fi


# To save the monitoring.service file at right location i.e. /etc/systemd/system
f1="/etc/systemd/system/monitoring.service"
if [ ! -f "$f1" ]
then
    sudo cp monitoring.service /etc/systemd/system/monitoring.service
    sudo chmod +x /etc/systemd/system/monitoring.service
    echo "Monitoring.service created, and can be used now"
else
    echo "Monitoring.service exist"
    sudo chmod +x /etc/systemd/system/monitoring.service
fi

# To reload and start using service, use following commands in terminal after execution of this script
# sudo systemctl daemon-reload
# sudo systemctl enable monitoring.service
# sudo systemctl start monitoring.service

# To check the status of service, whether it is running or not, use following command:
# sudo systemctl status monitoring.service