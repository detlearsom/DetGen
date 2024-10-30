# Define the base directory for the containers
CONTAINERS_DIR := containers

# Find all subdirectories in the format docker-{NAME}
DOCKER_DIRS := $(shell find $(CONTAINERS_DIR) -type d -name 'docker-*')

# Extract names from the directories
NAMES := $(patsubst docker-%,%, $(notdir $(DOCKER_DIRS)))

# Define Docker image names
IMAGES := $(patsubst %,detlearsom/%,$(NAMES))

# Default target builds all images
all: $(IMAGES)

# Rule to build each Docker image
detlearsom/%:
	$(eval DIR=$(CONTAINERS_DIR)/docker-$*)
	docker build -t detlearsom/$* $(DIR)

# Clean up images
clean:
	@for image in $(IMAGES); do \
        echo "Removing image $$image"; \
        docker rmi $$image || true; \
    done

.PHONY: all clean
