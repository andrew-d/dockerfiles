DIRS := $(sort $(dir $(wildcard */)))
IMAGES := $(patsubst %/,%,$(DIRS))
REBUILD ?= no

BUILD_FLAGS :=
ifeq ($(REBUILD),yes)
	BUILD_FLAGS := $(BUILD_FLAGS) --no-cache
endif

# Rule to build a docker image from a directory
andrewd/%: %
	@echo "Building '$<':"
	@echo "--------------------------------------------------"
	@docker build $(BUILD_FLAGS) -t $@ ./$</.
	@echo "--------------------------------------------------"
	@echo

# Generate 'fake' rules for each image.
IMAGES_CMD = $(foreach dir, $(IMAGES), andrewd/$(dir))

######################################################################

# Build all images
.PHONY: build
build: $(IMAGES_CMD)
	@echo "All images built"


DIRS_NOSLASH := $(patsubst %/,%,$(DIRS))

# Push all images
.PHONY: push
push:
	$(foreach dir,$(DIRS_NOSLASH),docker push andrewd/$(dir))

######################################################################

# Helper to list all images that will be built
.PHONY: debug
debug:
	@echo "Images: $(IMAGES)"
