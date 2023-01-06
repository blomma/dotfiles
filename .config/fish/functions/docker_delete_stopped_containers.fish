function docker_delete_stopped_containers
	docker rm (docker ps -a -q)
end
