CXXFLAGS= -O3 -fomit-frame-pointer -ffast-math
override CXXFLAGS+= -Wall -fsigned-char -fno-exceptions -fno-rtti

PLATFORM= $(shell uname -s)
PLATFORM_ARCH= $(shell uname -m)

INCLUDES= -Ishared -Iengine -Igame -Ienet/include

STRIP=
ifeq (,$(findstring -g,$(CXXFLAGS)))
ifeq (,$(findstring -pg,$(CXXFLAGS)))
  STRIP=strip
endif
endif

MV=mv

ifneq (,$(findstring MINGW,$(PLATFORM)))
WINDRES= windres
ifneq (,$(findstring 64,$(PLATFORM)))
ifneq (,$(findstring CROSS,$(PLATFORM)))
  CXX=x86_64-w64-mingw32-g++
  WINDRES=x86_64-w64-mingw32-windres
ifneq (,$(STRIP))
  STRIP=x86_64-w64-mingw32-strip
endif
endif
WINLIB=lib64
WINBIN=../bin64
override CXX+= -m64
override WINDRES+= -F pe-x86-64
else
ifneq (,$(findstring CROSS,$(PLATFORM)))
  CXX=i686-w64-mingw32-g++
  WINDRES=i686-w64-mingw32-windres
ifneq (,$(STRIP))
  STRIP=i686-w64-mingw32-strip
endif
endif
WINLIB=lib
WINBIN=../bin
override CXX+= -m32
override WINDRES+= -F pe-i386
endif
STD_LIBS= -static-libgcc -static-libstdc++
endif

SERVER_INCLUDES= -DSTANDALONE -Istandalone/shared -Istandalone/engine -Istandalone/game $(INCLUDES)
ifneq (,$(findstring MINGW,$(PLATFORM)))
SERVER_INCLUDES+= -Iinclude
SERVER_LIBS= -mwindows $(STD_LIBS) -L$(WINBIN) -L$(WINLIB) -lzlib1 -lenet -lws2_32 -lwinmm
else
SERVER_LIBS= -Lenet -lenet -lz
endif

SERVER_OBJS= \
	standalone/shared/crypto.o \
	standalone/shared/stream.o \
	standalone/shared/tools.o \
	standalone/engine/command.o \
	standalone/engine/server.o \
	standalone/engine/worldio.o \
	standalone/game/entities.o \
	standalone/game/server.o

SERVER_PCH= standalone/shared/cube.h.gch standalone/engine/engine.h.gch standalone/game/game.h.gch

default: server

clean:
	-$(RM) $(SERVER_PCH) $(SERVER_OBJS) ovoid

fixspace:
	sed -i 's/[ \t]*$$//; :rep; s/^\([ ]*\)\t/\1    /g; trep' shared/*.c shared/*.cpp shared/*.h engine/*.cpp engine/*.h game/*.cpp game/*.h

$(filter-out standalone/shared/%,$(SERVER_PCH)): $(filter standalone/shared/%,$(SERVER_PCH))
$(SERVER_PCH): standalone/%.h.gch: %.h
	$(CXX) $(CXXFLAGS) -x c++-header -o $@.tmp $<
	$(MV) $@.tmp $@

$(SERVER_OBJS): CXXFLAGS += $(SERVER_INCLUDES)
$(filter standalone/shared/%,$(SERVER_OBJS)): $(filter standalone/shared/%,$(SERVER_PCH))
$(filter standalone/engine/%,$(SERVER_OBJS)): $(filter standalone/engine/%,$(SERVER_PCH))
$(filter standalone/game/%,$(SERVER_OBJS)): $(filter standalone/game/%,$(SERVER_PCH))

$(SERVER_OBJS): standalone/%.o: %.cpp
	$(CXX) $(CXXFLAGS) -c -o $@ $<

ifneq (,$(findstring MINGW,$(PLATFORM)))

server: $(SERVER_OBJS)
	$(WINDRES) -I vcpp -i vcpp/mingw.rc -J rc -o vcpp/mingw.res -O coff
	$(CXX) $(CXXFLAGS) -o $(WINBIN)/ovoid.exe vcpp/mingw.res $(SERVER_OBJS) $(SERVER_LIBS)

install: server
else

server:	libenet $(SERVER_OBJS)
	$(CXX) $(CXXFLAGS) -o ovoid $(SERVER_OBJS) $(SERVER_LIBS)  

install: server
	cp -f ovoid	../bin_unix/ovoid
ifneq (,$(STRIP))
	$(STRIP) ../bin_unix/ovoid
endif
endif

enet/libenet.a:
	$(MAKE) -C enet
libenet: enet/libenet.a

depend:
	makedepend -a -pstandalone/ -Y -DSTANDALONE -Ishared -Iengine -Igame $(SERVER_OBJS:standalone/%.o=%.cpp)
	makedepend -a -pstandalone/ -o.h.gch -Y -DSTANDALONE -Ishared -Iengine -Igame $(SERVER_PCH:standalone/%.h.gch=%.h)

# DO NOT DELETE

standalone/shared/crypto.o: shared/cube.h shared/tools.h shared/geom.h
standalone/shared/crypto.o: shared/ents.h shared/command.h shared/iengine.h
standalone/shared/crypto.o: shared/igame.h
standalone/shared/stream.o: shared/cube.h shared/tools.h shared/geom.h
standalone/shared/stream.o: shared/ents.h shared/command.h shared/iengine.h
standalone/shared/stream.o: shared/igame.h
standalone/shared/tools.o: shared/cube.h shared/tools.h shared/geom.h
standalone/shared/tools.o: shared/ents.h shared/command.h shared/iengine.h
standalone/shared/tools.o: shared/igame.h
standalone/engine/command.o: engine/engine.h shared/cube.h shared/tools.h
standalone/engine/command.o: shared/geom.h shared/ents.h shared/command.h
standalone/engine/command.o: shared/iengine.h shared/igame.h engine/world.h
standalone/engine/server.o: engine/engine.h shared/cube.h shared/tools.h
standalone/engine/server.o: shared/geom.h shared/ents.h shared/command.h
standalone/engine/server.o: shared/iengine.h shared/igame.h engine/world.h
standalone/engine/worldio.o: engine/engine.h shared/cube.h shared/tools.h
standalone/engine/worldio.o: shared/geom.h shared/ents.h shared/command.h
standalone/engine/worldio.o: shared/iengine.h shared/igame.h engine/world.h
standalone/game/entities.o: game/game.h shared/cube.h shared/tools.h
standalone/game/entities.o: shared/geom.h shared/ents.h shared/command.h
standalone/game/entities.o: shared/iengine.h shared/igame.h game/ai.h
standalone/game/server.o: game/game.h shared/cube.h shared/tools.h
standalone/game/server.o: shared/geom.h shared/ents.h shared/command.h
standalone/game/server.o: shared/iengine.h shared/igame.h game/ai.h
standalone/game/server.o: game/ctf.h game/extinfo.h game/aiman.h
