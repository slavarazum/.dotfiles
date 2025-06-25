checkprogress() {
    ssh root@158.247.192.94 docker logs 6cd7c1e3de56
    ssh root@158.247.192.94 vnstat -h 5
    ssh root@141.164.42.203 vnstat -h 5
}
