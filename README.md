## Xotocross Scheduler 

```shell
# 1. get the id_rsa
# 2. get the address for the node
# 3. run the following :
ssh -i ./id_rsa ubuntu@<address>

# 4. run kube for pods 
 kubectl get pods -A
```



TODO : 

0. check on error folder found 
1. make sure that we have dynamic names on all resource 
2. add postgres database shared on all recources 
3. add tags on all resources
4. make sure github always recreates any resource without errors (ie like loadbalancer: maybe with ? lifecycle {create_before_destroy = true})
5. make load balancers better for all recources 
6. organize it all better 
7. add credentials to all resources thats there 
8. make sure to have outputs 
9. better logs and monitoring as well as alarms 
10. an easy way to run ssh commnands to get into your resource on laptop terminal local
11. edit readme to make it better so that its clear on whats going on and how to run this repo 
12. # TODO: Need to switch to signaling based solution instead of waiting.  in load balancer
13. clear all warnings from the terminal on github actions and legacy plugin issues