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
    kubectl expose service prometheus-server --type=NodePort --target-port=9090 --name=prometheus-server-np
    ```
4) Check services:
    ```
    kubectl get svc
    ```

### Access Prometheus UI

1) Expose service URL:
    ```
    minikube service prometheus-server-np --url
    ```
2) Prometheus UI:
    ```
    