#!/bin/bash
#XX:MinRAMPercentage setting the maximum heap size for a JVM running with a small amount of memory (less than 200 MB)
#XX:MaxRAMPercentage setting the maximum heap size for a JVM running with a large amount of memory (greater than 200 MB)
java ${JAVA_OPTS} -XX:MinRAMPercentage=50.0 -XX:MaxRAMPercentage=80.0 -Xdump:heap:defaults:file=/applis/tmp/heapdump.%Y%m%d.%H%M%S.%pid.%seq.phd -Xdump:java:defaults:file=/applis/tmp/javacore.%Y%m%d.%H%M%S.%pid.%seq.txt -Xdump:snap:defaults:file=/applis/tmp/Snap.%Y%m%d.%H%M%S.%pid.%seq.trc -Djava.io.tmpdir=/applis/tmp -Dfile.encoding=UTF-8 -cp /applis/app org.springframework.boot.loader.JarLauncher ${@}
