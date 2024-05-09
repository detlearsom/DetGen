Docker Image for [Siege](http://www.joedog.org/siege-home/)
====

How to use.
----

### setup

```console
$ git clone https://github.com/yokogawa-k/docker-siege.git
$ cd docker-siege
$ docker build -t yokogawa/siege .
```

### help

```console
$ docker run --rm -t yokogawa/siege
```

If you use `./run` script.

```console
$ ./run
```

### Performance test

```console
$ docker run --rm -t yokogawa/siege -d1 -r10 -c25 example.com
```

If you use `./run` script.

```console
$ ./run -d1 -r10 -c25 example.com
```

### use bash

```console
$ ./run bash
```

fig
----

```console
$ fig up -d
$ fig logs
```

