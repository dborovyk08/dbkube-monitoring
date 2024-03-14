# minikube with monitoring enabled

## Kubernetes (for MAC)

1) The easiest way to run containers on Mac is to use **Colima** 
    ```
    brew install colima
    ```
    Then just start your runtime
    ```
    brew start colima
    ```

2) So now we can install and start our kubernetes cluster. The easiest way is to use **minikube**

    ```
    brew install minikube
    ```
    Start the cluster
    ```
    minikube start
    ```

## Let's play with it ###

1)  I would suggest to create an alias for kubectl.
    In case of using zsh as a shell, add alias into zshrc :
    ```
    cat ~/.zshrc >> alias k=kubectl
    ```
2) Now we can start our "k" commands:
    ```
    k get nodes
    ``` 
    show us that minikube is ready and running
    ```
    k get pods -A
    ```
    shows all pods in all namespaces. For now we should see only system related pods running in kube-system namespace
3) Let's add some apps
    ```
    k create deployment nginx-hello-text --image=nginxdemos/hello:plain-text
    ```
    This is very small nginx that just getting back with text hello output
    ```
    k expose deployment nginx-hello-text --type=NodePort --port=80
    ```
    Create a service that can be used as a load-balancer
    ```
    k scale deploy nginx-hello-text --replicas=3
    ```
    Scale nginx deployemnt to 3 pods
    ```
    k get endpoints nginx-hello-text
    ```
    Be sure that our service is refering to all three pods
    ```
    minikube service nginx-hello-text
    ```
    Now creatng a port-forwarding so we can access the serive. Copy URL with the loopback IP and newly created port.
    Now you can either use browser or CURL.
    ```
    ·> curl 127.0.0.1:65081
    Server address: 10.244.0.90:80
    Server name: nginx-hello-text-549879f679-bg6nm
    Date: 14/Mar/2024:11:43:02 +0000
    URI: /
    Request ID: 9478d659ec0050dc62bfb61e895a6723
    ```
    If you're using CURL you can see that server address is changing all the time because there is no caching with CURL so load-balancing just works

    **(Optional)** You can also use LoadBalancer instead of NodePort but you will need to use sudo for that.
    ```
    ...
    k expose deployment nginx-hello-text --type=NodePort --port=80
    ...
    minikube tunnel
    ```
## Now adding monitoring

### Prometheus

1) Add prometheus repository

    ```
    helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
    ```

2) Install provided Helm chart for Prometheus
    ```
    helm install prometheus prometheus-community/prometheus
    ```
3) Expose the prometheus-server service via NodePort
    ```
    k expose service prometheus-server --type=NodePort --target-port=9090 --name=prometheus-server-np
    ```
4) Check services:
    ```
    k get svc
    ```

### Access Prometheus UI

1) Expose service URL:
    ```
    minikube service prometheus-server-np --url
    ```
2) Prometheus UI:
    ![Screenshot of the Prometheus console](https://dborovyk-nginx-public.s3.amazonaws.com/prometheus.jpg)
3) Using Prometheus UI:
    Consider using [Prometheus Docs] (prometheus.io/docs/prometheus/latest/querying/basics/) for more information on how to use PromQL 
    ![Now we can use PromQL to request information and show graphs](https://dborovyk-nginx-public.s3.amazonaws.com/prometheus2.jpg)

### Grafana

1) Installation. Add Grafana Helm repo:
    ```
    helm repo add grafana https://grafana.github.io/helm-charts
    ```
2) Install Grafana chart:
    ```
    helm install grafana grafana/grafana
    ```
3) Expose Grafana service via NodePort in order to access Grafana UI:
    ```
    k expose service grafana --type=NodePort --target-port=3000 --name=grafana-np
    ```
4) Check exposed service:
    ```
    k get services
    ```
5) Get Grafana admin credentials
    ```
    k get secret --namespace default grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
    ```
6) Access Grafana Web UI
    ```
    minikube service grafana-np
    ```
7) Add Prometheus data source (use prometheus-server:80 URL):
    !(https://dborovyk-nginx-public.s3.amazonaws.com/grafana.png)
8) Import community based Grafana dashboards. For example you can use dashboard with 6417 id: 
    !(https://dborovyk-nginx-public.s3.amazonaws.com/grafana3.png)
9) Using Dashboard to monitor our Kubernetes:
    !(https://dborovyk-nginx-public.s3.amazonaws.com/grafana2.jpg)
