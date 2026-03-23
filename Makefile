all: up

up:
# Not report error if dirs existed
	mkdir -p /home/yingzhan/data/mariadb
	mkdir -p /home/yingzhan/data/wordpress
# -f: given path of compose file
# -d: detached
# --build: force build new images(not use cache)
	docker-compose -f srcs/docker-compose.yml up -d --build

down:
	docker-compose -f srcs/docker-compose.yml down

stop:
	docker-compose -f srcs/docker-compose.yml stop

start:
	docker-compose -f srcs/docker-compose.yml start

clean: down
# -a: all unused image
# -f: force
	docker system prune -af
	docker volume rm -f srcs_mariadb_data srcs_wordpress_data

fclean: clean
	sudo rm -rf /home/yingzhan/data/mariadb/*
	sudo rm -f /home/yingzhan/data/mariadb/.inception_initialized
	sudo rm -rf /home/yingzhan/data/wordpress/*

re: fclean all

logs:
# -f: follow
	docker-compose -f srcs/docker-compose.yml logs -f

.PHONY: all up down stop start clean fclean re logs

