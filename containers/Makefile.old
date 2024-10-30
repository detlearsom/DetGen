# Build images on local docker instance, tag with project name

USER=detlearsom
DOCKS=$(shell ls -d docker-*)
MYIMAGES=$(subst docker-,,$(DOCKS))

## TODO: fill out this list with version numbers for standard ("official") images
STDIMAGES=httpd:2.4.34 nginx:1.13.8-alpine ubuntu:18.04 corentinaltepe/heirloom-mailx:latest mysql:8.0.12 linuxserver/syncthing:131


%:
	docker build $(BUILDARGS) -t $(USER)/$* docker-$*
	docker tag $(USER)/$* $*
	docker images $(USER)/$*
	docker history $(USER)/$*

all:
	for img in $(MYIMAGES); do $(MAKE) $$img; done
	for img in $(STDIMAGES); do docker pull $$img; docker tag $$img `basename $$img :`; done

# idea: pull with a given version, tag it with base name (default)
#%\:version:
#	docker pull $*
#	docker tag $* $*

