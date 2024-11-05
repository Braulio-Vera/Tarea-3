#!/bin/bash

# Archivo de salida
output_file="reporte_recursos.txt"

# Encabezado del archivo de salida
echo -e "tiempo\t% Total de CPU libre\t% Memoria libre\t% Disco libre" > "$output_file"

# Cálculo del uso del CPU
num_procesadores=$(grep -c ^processor /proc/cpuinfo)

# Bucle para monitorear cada 60 segundos por 5 minutos (5 ciclos)
for ((i=1; i<=5; i++)); do
	# Tiempo transcurrido en segundos
	tiempo=$((i * 60))

	#  Cálculo de CPU libre en porcentaje
	cpu_usado=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
	cpu_libre=$(echo "scale=2; 100 - $cpu_usado" | bc)

	# Memoria libre en porcentaje
	mem_libre=$(free | grep Mem | awk '{print $4/$2 * 100.0}')

	# Disco libre en porcentaje
	disco_libre=$(df / | tail -1 | awk '{print $4/$2 * 100.0}')

	# Guardar los resultados en el archivo de salida
	echo -e "${tiempo}s\t${cpu_libre}\t${mem_libre}\t${disco_libre}" >> "$output_file"

	# esperar 60 segundos antes del siguiente monitoreo
	sleep 60
done

echo "Monitoreo completado, los datos fueron guardados en $output_file"
