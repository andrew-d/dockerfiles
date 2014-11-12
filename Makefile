DIRS := $(sort $(dir $(wildcard */)))
IMAGES := $(patsubst %/,%,$(DIRS))
IMAGES_WITH_REPO = $(foreach dir, $(IMAGES), andrewd/$(dir))
REBUILD ?= no

BUILD_FLAGS :=
ifeq ($(REBUILD),yes)
	BUILD_FLAGS := $(BUILD_FLAGS) --no-cache
endif

.PHONY: all
all: $(IMAGES_WITH_REPO)

# Rule to build a docker image from a directory
andrewd/%: %
	@echo "Building '$<':"
	@echo "--------------------------------------------------"
	@docker build $(BUILD_FLAGS) -t $@ ./$</.
	@echo "--------------------------------------------------"
	@echo

######################################################################

# Manual dependency tracking (for now)
andrewd/ubuntu: base-containers

andrewd/ubuntu-build: andrewd/ubuntu

andrewd/nginx: andrewd/ubuntu

andrewd/nginx-confd: andrewd/ubuntu

andrewd/syncthing: andrewd/ubuntu

andrewd/busybox: base-containers

andrewd/sthttpd: andrewd/busybox

andrewd/sthttpd-build: andrewd/ubuntu-build

.PHONY: base-containers
base-containers:
	@docker pull ubuntu:14.04.1
	@docker pull progrium/busybox

# Push all images
DIRS_NOSLASH := $(patsubst %/,%,$(DIRS))
.PHONY: push
push:
	$(foreach dir,$(DIRS_NOSLASH),docker push andrewd/$(dir))

######################################################################

# Helper to list all images that will be built
.PHONY: debug
debug:
	@echo "Images: $(IMAGES)"
