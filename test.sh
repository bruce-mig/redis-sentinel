MASTER_IP=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' redis-master)
SLAVE_IP=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' redis-cluster-slave-1)
SENTINEL_IP=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' redis-cluster-sentinel-1)

echo Redis master: $MASTER_IP
echo Redis Slave: $SLAVE_IP
echo ------------------------------------------------
echo Initial status of sentinel
echo ------------------------------------------------
docker exec redis-cluster-sentinel-1 redis-cli -p 26379 info Sentinel
echo Current master is
docker exec redis-cluster-sentinel-1 redis-cli -p 26379 SENTINEL get-master-addr-by-name mymaster
echo ------------------------------------------------

echo Stop redis master
docker pause redis-master
echo Wait for 10 seconds
sleep 10
echo Current infomation of sentinel
docker exec redis-cluster-sentinel-1 redis-cli -p 26379 info Sentinel
echo Current master is
docker exec redis-cluster-sentinel-1 redis-cli -p 26379 SENTINEL get-master-addr-by-name mymaster


echo ------------------------------------------------
echo Restart Redis master
docker unpause redis-master
sleep 5
echo Current infomation of sentinel
docker exec redis-cluster-sentinel-1 redis-cli -p 26379 info Sentinel
echo Current master is
docker exec redis-cluster-sentinel-1 redis-cli -p 26379 SENTINEL get-master-addr-by-name mymaster
