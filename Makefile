SRCDIR=src
OBJDIR=intermediates
DISTDIR=dist

.PHONY: clean

CURRDIR = $(shell pwd)
SOURCES = $(wildcard $(SRCDIR)/*)
OBJECTS = $(SOURCES:$(SRCDIR)/%=$(OBJDIR)/%)

$(DISTDIR)/bonjour-vnc.alfredworkflow: $(OBJECTS) $(OBJDIR)/bundle $(OBJDIR)/.bundle
	mkdir -p $(@D)
	cd $(OBJDIR) && zip -r $(CURRDIR)/$@ $(patsubst $(OBJDIR)/%,%,$^)

$(OBJDIR)/%: $(SRCDIR)/%
	mkdir -p $(@D)
	cp $^ $@

$(OBJDIR)/bundle: $(OBJDIR)/Gemfile.lock $(OBJDIR)/Gemfile
	cd $(OBJDIR) && bundle install --standalone --clean

clean:
	rm -r $(OBJDIR) $(DISTDIR)
