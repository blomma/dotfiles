function go_arm_build
	env CGO_ENABLED=0 GOOS=linux GOARCH=arm GOARM=7 go build -ldflags '-d -s -w' $argv
end

