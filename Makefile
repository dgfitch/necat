NAME=necat
OS?=osx
include Makefile.$(OS) 


#.SILENT:

all: clean build run

clean:
	$(RM) $(NAME).love

build: clean
	cd love && $(ZIP) ../$(NAME).zip .
	mv $(NAME).zip $(NAME).love

run: build
	$(LOVE) $(NAME).love	

publish: build
	scp $(NAME).love mindfill.com:www/projects/games/necat
