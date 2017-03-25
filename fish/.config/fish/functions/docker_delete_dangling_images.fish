function docker_delete_dangling_images
	docker rmi (docker images -q -f dangling=true)
end
