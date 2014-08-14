
function dis_t {
	arm-none-eabi-objdump -b binary -m arm -M force-thumb \
		--start-address=$2 --stop-address=$3 \
		-D $1 | sed 's/;/\/\//' | cut -f3,4,5,6,7,8
}

function dis_t_ {
	arm-none-eabi-objdump -b binary -m arm -M force-thumb \
		--start-address=$2 --stop-address=$3 \
		-D $1 | sed 's/;/\/\//'
}

function sub {
	python -c "print(hex($1 - $2))"
}

function dis_t_around {
	dis_t_ $1 $2 $(( $2 + 50 ))
}


