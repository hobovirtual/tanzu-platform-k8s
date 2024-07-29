#what are the steps to get this up?????

# set project context via tanzu cli - select AMER-East
tanzu project use

# 1: create clustergroup
tanzu operations clustergroup create -f platform-engineer/1-clustergroup.yaml

# set clustergroup context via tanzu cli - select [yourhandle]-cg
tanzu operations clustergroup use

#### add capabilities
tanzu package install cert-manager.tanzu.vmware.com -p cert-manager.tanzu.vmware.com -v '>0.0.0'
tanzu package install k8sgateway.tanzu.vmware.com -p k8sgateway.tanzu.vmware.com -v '>0.0.0'
tanzu package install tcs.tanzu.vmware.com -p tcs.tanzu.vmware.com -v '>0.0.0'
tanzu package install egress.tanzu.vmware.com -p egress.tanzu.vmware.com -v '>0.0.0'
tanzu package install observability.tanzu.vmware.com -p observability.tanzu.vmware.com -v '>0.0.0'
tanzu package install mtls.tanzu.vmware.com -p mtls.tanzu.vmware.com -v '>0.0.0'
tanzu package install crossplane.tanzu.vmware.com -p crossplane.tanzu.vmware.com -v '>0.0.0'
tanzu package install bitnami.services.tanzu.vmware.com -p bitnami.services.tanzu.vmware.com -v '>0.0.0'
tanzu package install container-apps.tanzu.vmware.com -p container-apps.tanzu.vmware.com -v '>0.0.0'
tanzu package install servicebinding.tanzu.vmware.com -p servicebinding.tanzu.vmware.com -v '>0.0.0'
tanzu package install tanzu-servicebinding.tanzu.vmware.com -p tanzu-servicebinding.tanzu.vmware.com -v '>0.0.0'
tanzu package install spring-cloud-gateway.tanzu.vmware.com -p spring-cloud-gateway.tanzu.vmware.com -v '>0.0.0'

# 2: create kubernetes cluster
tanzu operations ekscluster create -f platform-engineer/2-cluster.yaml

# 3: create kuberneter cluster nodepool
tanzu operations ekscluster nodepool create -f platform-engineer/3-nodepool.yaml

currentstatus=`tanzu operations cluster get eks.916681805290.us-east-1.[yourhandle]-eks -t eks -o json | jq '.status.phase'`
while [ $currentstatus != '"READY"' ]
do
    echo "cluster not ready"
    sleep 60
    currentstatus=`tanzu operations cluster get eks.916681805290.us-east-1.[yourhandle]-eks -t eks -o json | jq '.status.phase'`
done

# 4: create availability targets
tanzu availability-target create -f platform-engineer/4-target.yaml -y

# 5: create network profile
tanzu profile create -f platform-engineer/5-profile.yaml -y

#6: create space
#tanzu deploy --only platform-engineer/6-space.yaml -y
tanzu space create crenaud-workshop-space -p spring-dev.tanzu.vmware.com -p crenaud.tanzu-studio.com -t crenaud-target --update-strategy RollingUpdate -y

# set space context via tanzu cli - select [yourhandle]-workshop-space
tanzu space use