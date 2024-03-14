# minikube with monitoring enabled

## Installation steps

### Kubernetes (for MAC)

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

### Let's play with it ###

1)  I would suggest to create an alias for kubectl.
    In case of using zsh as a shell, add alias into zshrc :
    ```
    cat ~/.zshrc >> alias k=kubectl
    ```
2) Now we can start our "k" commands:
    ```
    k get nodes
    ``` //show us that minikube is ready and running
    