#!/bin/sh

rm .\obj\*.o

armcc  -c --debug --cpu=Cortex-A9.no_neon.no_vfp -O1 -o ./obj/main_normal.o     ./src/main_normal.c
armcc  -c --debug --cpu=Cortex-A9.no_neon.no_vfp -O1 -o ./obj/retarget_normal.o ./src/retarget_normal.c

armasm    --debug --cpu=Cortex-A9.no_neon.no_vfp     -o ./obj/startup_normal.o  ./src/startup_normal.s
armasm    --debug --cpu=Cortex-A9.no_neon.no_vfp     -o ./obj/v7.o              ./src/v7.s

armlink   --scatter=scatter_normal.txt --entry=normalStart -o normal.axf ./obj/main_normal.o  ./obj/retarget_normal.o ./obj/startup_normal.o ./obj/v7.o

fromelf --bin -o normal.bin normal.axf

rm .\obj\*.o

armcc  -c --debug --cpu=Cortex-A9.no_neon.no_vfp -I ./headers/ -O1 -o ./obj/main_secure.o     ./src/main_secure.c
armcc  -c --debug --cpu=Cortex-A9.no_neon.no_vfp -I ./headers/ -O1 -o ./obj/retarget_secure.o ./src/retarget_secure.c
armcc  -c --debug --cpu=Cortex-A9.no_neon.no_vfp -I ./headers/ -O1 -o ./obj/bp147_tzpc.o      ./src/bp147_tzpc.c

armasm    --debug --cpu=Cortex-A9.no_neon.no_vfp                        -o ./obj/startup_secure.o  ./src/startup_secure.s
armasm    --debug --cpu=Cortex-A9.no_neon.no_vfp --diag_suppress=A1786W -o ./obj/monitor.o         ./src/monitor.s
armasm    --debug --cpu=Cortex-A9.no_neon.no_vfp                        -o ./obj/v7.o              ./src/v7.s

armlink   --scatter=scatter_secure.txt  -o VE_TrustZone_Example.axf --entry=secureStart --keep=startup_secure.o(NORMAL_IMAGE) ./obj/main_secure.o  ./obj/retarget_secure.o ./obj/startup_secure.o ./obj/v7.o ./obj/monitor.o ./obj/bp147_tzpc.o
