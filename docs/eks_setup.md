# To install kubectl for Amazon EKS

On centos distribution,
install kubectl binary using native package management:
```console
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
yum install -y kubectl
```

# To install aws-iam-authenticator for Amazon EKS
and authorize the execution permissions of the binary:

```console
curl -o aws-iam-authenticator https://amazon-eks.s3-us-west-2.amazonaws.com/1.11.5/2018-12-06/bin/linux/amd64/aws-iam-authenticator
chmod +x ./aws-iam-authenticator
```


Copy the binary to a folder in your $PATH. We recommend creating a $HOME/bin/aws-iam-authenticator 
mv ./aws-iam-authenticator $HOME/bin/aws-iam-authenticator && export PATH=$HOME/bin:$PATH


# Installing the AWS CLI Using pip

The AWS CLI is updated regularly to add support for new services and commands. 
To update to the latest version of the AWS CLI, run the installation command again.
```console
$ pip install awscli --upgrade --user
```

Use the AWS CLI update-kubeconfig command to create or update your kubeconfig for your cluster:
By default, the resulting configuration file is created at the default kubeconfig path (.kube/config) in your home directory or merged with an existing kubeconfig at that location. You can specify another path with the --kubeconfig option.


Using test-EKS-cluster-2, the name of the cluster that we created on AWS WEB UI Console:
```console
aws eks update-kubeconfig --name test-EKS-cluster-2
```

OUTPUT:
```console
Added new context arn:aws:eks:eu-west-1:412508216422:cluster/test-EKS-cluster-2 to /root/.kube/config
```

