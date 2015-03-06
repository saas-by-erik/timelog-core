#!/usr/bin/env sh

OUTDIR=debug
host_os=$( uname -s )

cat >Makefile <<EOF
OBJS_TEST_UNIT_TL = $( cd src && find tests/unit/tl/ -type f | sort | sed -e 's/^/build\//' -e 's/\.c$/.o/' | xargs )

.PHONY: all
EOF

if [ "$host_os" = "Darwin" ] ; then
cat >>Makefile <<EOF
all: ${OUTDIR}/lib/libtimelog.0.dylib ${OUTDIR}/bin/tl

EOF
else
cat >>Makefile <<EOF
all: ${OUTDIR}/lib/libtimelog.so.0 ${OUTDIR}/bin/tl

EOF
fi

cat >>Makefile <<EOF
Makefile: configure.sh
	./configure.sh

${OUTDIR}/include/timelog.h: src/include/timelog.h ${OUTDIR}/include/
	cp src/include/timelog.h ${OUTDIR}/include/timelog.h

${OUTDIR}/bin/tl: ${OUTDIR}/include/timelog.h src/tl.c ${OUTDIR}/bin/
EOF

if [ "$host_os" = "Darwin" ] ; then
cat >>Makefile <<EOF
	cc -I${OUTDIR}/include -L${OUTDIR}/lib -Wall -ansi -pedantic -O0 -g -o ${OUTDIR}/bin/tl src/tl.c -ltimelog

${OUTDIR}/lib/libtimelog.0.dylib: ${OUTDIR}/include/timelog.h src/timelog.c build/oobj/ ${OUTDIR}/lib/
	cc -I${OUTDIR}/include -fPIC -Wall -ansi -pedantic -O0 -g -o build/oobj/timelog.o -c src/timelog.c
	cc -dynamiclib -o ${OUTDIR}/lib/libtimelog.0.dylib -Wl,-install_name,@loader_path/../lib/libtimelog.0.dylib build/oobj/timelog.o
	test -f ${OUTDIR}/lib/libtimelog.dylib || ln -s libtimelog.0.dylib ${OUTDIR}/lib/libtimelog.dylib

EOF
else
cat >>Makefile <<EOF
	cc -I${OUTDIR}/include -L${OUTDIR}/lib -Wl,-z,origin,-rpath='\$\$ORIGIN/../lib/' -Wall -ansi -pedantic -O0 -g -o ${OUTDIR}/bin/tl src/tl.c -ltimelog

${OUTDIR}/lib/libtimelog.so.0: ${OUTDIR}/include/timelog.h src/timelog.c build/oobj/ ${OUTDIR}/lib/
	cc -I${OUTDIR}/include -fPIC -Wall -ansi -pedantic -O0 -g -o build/oobj/timelog.o -c src/timelog.c
	cc -shared -Wl,-soname,libtimelog.so.0 -o ${OUTDIR}/lib/libtimelog.so.0 build/oobj/timelog.o
	test -f ${OUTDIR}/lib/libtimelog.so || ln -s libtimelog.so.0 ${OUTDIR}/lib/libtimelog.so

EOF
fi

cat >>Makefile <<EOF
${OUTDIR}/:
	test -d ${OUTDIR}/ || mkdir ${OUTDIR}/

${OUTDIR}/include/: ${OUTDIR}/
	test -d ${OUTDIR}/include/ || mkdir ${OUTDIR}/include/

${OUTDIR}/bin/: ${OUTDIR}/
	test -d ${OUTDIR}/bin/ || mkdir ${OUTDIR}/bin/

${OUTDIR}/lib/: ${OUTDIR}/
	test -d ${OUTDIR}/lib/ || mkdir ${OUTDIR}/lib/

build/:
	test -d build/ || mkdir build/

build/oobj/: build/
	test -d build/oobj/ || mkdir build/oobj/

.PHONY: test
test: all build/test-runner-regression-timelog build/test-runner-unit-timelog build/test-runner-regression-tl build/test-runner-unit-tl
	#./build/test-runner-regression-timelog
	#./build/test-runner-unit-timelog
	#./build/test-runner-regression-tl
	./build/test-runner-unit-tl

build/test-runner-regression-timelog:
	#TODO

build/test-runner-unit-timelog:
	#TODO

build/test-runner-regression-tl:
	#TODO

build/test-runner-unit-tl: \$(OBJS_TEST_UNIT_TL)
	cc -c -Wall -ansi -pedantic -O0 -g -Isrc/tests/include/ \\
	  \$(.ALLSRC) -o build/test-runner-unit-tl

\$(OBJS_TEST_UNIT_TL): \$(.PREFIX).c build/tests/unit/tl/
	cc -c -Wall -ansi -pedantic -O0 -g -Isrc/tests/include/ -o \$(.TARGET) \$(.ALLSRC)

build/tests/unit/tl/:
	test -d build/tests/unit/tl/ || mkdir -p build/tests/unit/tl/

.PHONY: clean
clean:
	rm -rf build/

.PHONY: clean-all
clean-all: clean
	rm -rf ${OUTDIR}/
EOF
