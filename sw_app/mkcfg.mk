./work:
	@mkdir ./work

coremark: ./work
	@rm -rf ./work/*
	@cp ./cases/coremark/* ./work
	@find ./lib/ -maxdepth 1 -type f -exec cp {} ./work/ \;
	@cp ./lib/clib/* ./work
	@cp ./lib/newlib_wrap/* ./work
	@cd ./work && make -s clean && make -s all CASENAME=coremark FILE=core_main


hello_world: ./work
	@rm -rf ./work/*
	@cp ./cases/hello_world/* ./work
	@find ./lib/ -maxdepth 1 -type f -exec cp {} ./work/ \;
	@cp ./lib/clib/* ./work
	@cp ./lib/newlib_wrap/* ./work
	@cd ./work && make -s clean && make -s all CASENAME=hello_world FILE=hello_world

