TARGET_EXEC ?= vulkan-app

BUILD_DIR ?= ./build
SRC_DIRS ?= src/
CXX := clang
LDFLAGS = -Wall -Wextra -Werror -lglfw -lvulkan -ldl -lpthread -lX11 -lXxf86vm -lXrandr -lXi -lstdc++


SRCS := $(shell find $(SRC_DIRS) -name *.cpp)
#OBJS := $(SRCS:%=%.o)
#DEPS := $(OBJS:.o=.d)

DEPS = $(shell find build/ -name *.d)

INC_DIRS := $(shell find $(SRC_DIRS) -type d)
INC_FLAGS := $(addprefix -I,$(INC_DIRS))

CPPFLAGS ?= $(INC_FLAGS) -std=c++17 -MMD -MP -Wall

#
# Debug build settings
#
DBGDIR := $(BUILD_DIR)/debug
DBGEXE := $(DBGDIR)/$(TARGET_EXEC)
DBGOBJS := $(SRCS:%=$(DBGDIR)/%.o)
DBGCFLAGS := $(CPPFLAGS) -g -O0 -ftrapv -Wall -Wextra -DDEBUG

#
# Release build settings
#
RELDIR := $(BUILD_DIR)/release
RELEXE := $(RELDIR)/$(TARGET_EXEC)
RELOBJS := $(SRCS:%=$(RELDIR)/%.o)
RELCFLAGS := $(CPPFLAGS) -O3 -Ofast -ffast-math -DRELEASE -DNDEBUG

.PHONY: clean release debug run rund all remake

all: release debug
remake: clean all

release: $(RELEXE)

$(RELEXE): $(RELOBJS)
	$(MKDIR_P) $(dir $@)
	$(CC) $(RELOBJS) -o $@ $(LDFLAGS)

$(RELDIR)/%.cpp.o: %.cpp
	$(MKDIR_P) $(dir $@)
	$(CXX) $(RELCFLAGS) -c $< -o $@


debug: $(DBGEXE)

$(DBGEXE): $(DBGOBJS)
	$(MKDIR_P) $(dir $@)
	$(CC) $(DBGOBJS) -o $@ $(LDFLAGS)

$(DBGDIR)/%.cpp.o: %.cpp
	$(MKDIR_P) $(dir $@)
	$(CXX) $(DBGCFLAGS) -c $< -o $@


clean:
	$(RM) -r $(BUILD_DIR)

run:
	$(RELEXE)

rund:
	$(DBGEXE)

test:
	valgrind --leak-check=full $(RELEXE)

-include $(DEPS)

MKDIR_P ?= mkdir -p
