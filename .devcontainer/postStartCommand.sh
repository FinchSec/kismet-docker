sudo dockerd 2>/dev/null >/dev/null &

# Wait for the socket to show up 
TIMEOUT=10
DOCKER_SOCK=/var/run/docker.sock
while [ ! -S ${DOCKER_SOCK} ]; do
    sleep 1
    TIMEOUT=$((TIMEOUT-1))
    if [ ${TIMEOUT} -eq 0 ]; then
        echo "Waiting loop (10 seconds) for ${DOCKER_SOCK} ended"
        exit 1
    fi
done

docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
exit 0