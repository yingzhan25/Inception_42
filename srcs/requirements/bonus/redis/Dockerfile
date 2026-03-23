FROM debian:bookworm

# install redis-server and clean up cache
Run apt-get update && \
    apt-get install -y --no-install-recommends redis-server && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# modify redix .conf
# listen to all address, shutdown protected mode, avoid using up memory
# Avoid daemon return main process
RUN sed -i "s/bind 127.0.0.1 -::1/bind 0.0.0.0/g" /etc/redis/redis.conf && \
    sed -i "s/protected-mode yes/protected-mode no/g" /etc/redis/redis.conf && \
    sed -i "s/daemonize yes/daemonize no/g" /etc/redis/redis.conf && \
    sed -i "s/# maxmemory <bytes>/maxmemory 128mb/g" /etc/redis/redis.conf && \
    sed -i "s/# maxmemory-policy noeviction/maxmemory-policy allkeys-lru/g" /etc/redis/redis.conf

# set up dir and change owner
Run mkdir -p /var/run/redis && \
    chown redis:redis /var/run/redis

EXPOSE 6379

# Dont use root
USER redis

# start redis server
CMD ["redis-server", "/etc/redis/redis.conf"]