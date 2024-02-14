<!--
date: '2021-02-24'
description: A checklist for Kubernetes platform considerations
keywords:
- Kubernetes
lastmod: '2021-02-24'
linkTitle: Platform Readiness Checklist
parent: Workload Tenancy
title: Platform Readiness Checklist
weight: 100
featured: true
oldPath: "/content/guides/kubernetes/workload-tenancy-platform-checklist.md"
aliases:
- "/guides/kubernetes/workload-tenancy-platform-checklist"
level1: Building Kubernetes Runtime
level2: Building Your Kubernetes Platform
tags: []
-->


This list is a starting place for considerations about the Kubernetes platform
running your applications. It is not exhaustive and should be expanded based on
your requirements.

### Required


- etcd is highly available

It is important to configure etcd with high availability to minimize the risk of
data loss. Ensure a minimum of three nodes are running and are placed in
different fault domains.





- etcd cluster is healthy

Ensure the members of your etcd cluster are healthy. The below commands give you
a glimpse of the status of your cluster.

Note the need to substitute the node IP's for x, y and z below:

```
ETCDCTL_API=3 etcdctl --cacert=/etc/kubernetes/pki/etcd/ca.crt --cert=/etc/kubernetes/pki/etcd/healthcheck-client.crt --key=/etc/kubernetes/pki/etcd/healthcheck-client.key member list

ETCDCTL_API=3 etcdctl --cacert=/etc/kubernetes/pki/etcd/ca.crt --cert=/etc/kubernetes/pki/etcd/healthcheck-client.crt --key=/etc/kubernetes/pki/etcd/healthcheck-client.key --endpoints=https://x:2379,https://y:2379,https://z:2379 endpoint health
https://x:2379 is healthy: successfully committed proposal: took = 9.969618ms
https://y:2379 is healthy: successfully committed proposal: took = 10.675474ms
https://z:2379 is healthy: successfully committed proposal: took = 13.338815ms
```






- A Backup/restore strategy is outlined

Each cluster is different. Think through and understand what elements of your
cluster need to be backed up and restored in the event of single or multi-node
failure, database corruption or other problems. Consider the applications
running in the platform, the roles and role bindings, persistent storage
volumes, ingress configuration, security and network policies, etc.





- A certificate renewal process is in place

All certificates in the cluster have an expiration date. Although it is likely
the cluster will be upgraded/replaced before then, it is still recommended to
have a process to refresh/renew them documented.





- Failure domain/availability zones have been considered

In both cloud and on-premise installations, the importance of using different
availability zones/failure domains for your control plane nodes is fundamental
to cluster resiliency. Unless there is an architectural redundancy in your
topology (mirror clusters per AZ, or globally load balanced clusters) consider
control plane node location.




### Ingress


- Load balancer is redundant

Your ingress should be configured to run on several pre-defined nodes for
high availability. Configure the load balancer to route traffic to these nodes
accordingly. Test to make sure all defined nodes are getting traffic.





- Load balancer throughput meets requirements

Testing your cluster for network bottlenecks before going live is a must. Test
your load balancer and ingress throughput capacity to set realistic expectations
from the results obtained.




### Network / CNI


- Pod to Pod communication works

Validate that Pods can communicate with other Pods and that the Services
exposing those Pods correctly route traffic.





- Egress communication has been tested

Validate that Pods can reach endpoints outside of the cluster.





- DNS functionality validated

Test that containers in the platform can resolve external and internal domains.
Test internal domains with and without `.cluster.local` prefix.





- Network Policy configuration validated

When applicable, validate that network policies are being enforced as expected.




### Capacity


- Nodes can be added seamlessly

The worker node deployment and bootstrap process should be defined and
automated. Ensure new nodes can be seamlessly added to the cluster enabling and
preparing it for growth.





- Cluster autoscaling enabled

Cluster autoscaling automatically adjusts the size of the cluster when
insufficient resources are available to run new Pods or nodes have been
underutilized for an extended period of time. When applicable, verify it is
enabled and the expected actions are taken under these conditions.





- ResourceQuotas are defined

[ResourceQuotas](https://kubernetes.io/docs/concepts/policy/resource-quotas/)
provide constraints that limit aggregate consumption of resources per namespace.
They limit the quantity of resources of a given type that can be created. Define
and implement them in the relevant namespaces.





- LimitRanges are defined

[LimitRanges](https://kubernetes.io/docs/concepts/policy/limit-range/#enabling-limit-range)
define default, minimum and maximum memory, CPU and storage utilization per Pod
in a namespace. These should be defined to avoid running unbounded containers.

You can find more information about this in the
[resource limits](../workload-tenancy-cluster-tuning#resource-limits)
section of the cluster tuning library document.




### Monitoring


- Platform is monitored

The API, controllers, etcd, and worker node health status should be monitored.
Ensure notifications are correctly delivered, and a dead man's switch is
configured and working.





- Containers are monitored

The containers running on the platform should be monitored for performance and
availability. Kubernetes provides liveness and readiness checks, and prometheus
can give you more in-depth information of application performance.




### Storage


- Test storage classes

Ensure defined storage classes are working as expected. Test them by creating
persistent volume claims to ensure they work as defined. Validate the claims
bind properly and have the expected write permissions.




### Upgrades


- Define and test the upgrade process

Document, automate and test the upgrade process to ensure it is consistent and
repeatable.

This will help determine the upgrade expected downtime and availability impact
to properly set expectations with application owners.




### Identity


- Configure an identity provider

Verify that the configured identity provider is functional. Test the platform
login process using existing and new users.



- Define user groups and roles

Ensure roles and role bindings have been correctly applied to the groups
created.




### Metrics


- Validate metric collection

Verify that the metrics aggregation pipeline for the workloads and the platform
is functional. This is a requirement for cluster and pod autoscalers to work.



### Logging


- Validate log aggregation and forwarding

Verify the container and platform logs are reaching their destination. These can
be stored within the cluster or forwarded to an external system.



