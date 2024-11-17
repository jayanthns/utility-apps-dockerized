
# Redis Docker

Instantiate the Redis using the Docker instead of native installation

## Run Locally

Ensure that Docker is installed

```bash
  docker -v
```

Create a dedicated Docker network

```bash
  docker network create -d bridge redisnet
```

Run Redis container

```bash
  docker run -d -p 6379:6379 --name myredis --network redisnet redis
```

Install redis-cli

```bash
  brew install redis-cli
```

Access `redis-cli`

```bash
  redis-cli
```

Accessing the keys

- Create a generic key like set a1 100 and get a1 100

```bash
  set a1 100
  get a1
```
