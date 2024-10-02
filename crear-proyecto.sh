#!/bin/bash

# Función para crear los archivos y añadir el código
create_files() {
    echo "Creando estructura de archivos..."

    # Crear directorios y archivos
    mkdir -p src
    touch package.json Dockerfile docker-compose.yml .dockerignore src/index.js src/database.js

    # Crear package.json
    cat <<EOL > package.json
{
  "name": "mongodb-docker-compose-ai",
  "version": "1.0.0",
  "main": "index.js",
  "scripts": {
    "start": "node ./src/index.js",
    "test": "echo \\"Error: no test specified\\" && exit 1"
  },
  "keywords": [],
  "author": "",
  "license": "ISC",
  "description": "",
  "dependencies": {
    "express": "^4.21.0",
    "mongoose": "^8.7.0"
  }
}
EOL

    # Crear Dockerfile
    cat <<EOL > Dockerfile
# Usar la imagen oficial de Node.js como base
FROM node:18

# Establecer el directorio de trabajo
WORKDIR /usr/src/app

# Copiar package.json y package-lock.json
COPY package*.json ./

# Instalar dependencias
RUN npm install

# Copiar el resto de la aplicación
COPY . .

# Exponer el puerto 3000
EXPOSE 3000

# Comando para ejecutar la aplicación
CMD ["npm", "start"]
EOL

    # Crear docker-compose.yml
    cat <<EOL > docker-compose.yml
version: "3.8"

services:
  web:
    container_name: nodejs-app
    build: .
    ports:
      - "5000:3000"
    depends_on:
      - mongo
  mongo:
    container_name: mongodb
    image: mongo:6.0
    ports:
      - "27018:27017"
EOL

    # Crear src/index.js
    cat <<EOL > src/index.js
const express = require('express');
const mongoose = require('mongoose');

const app = express();
const PORT = 3000;

// Conectar a la base de datos
mongoose.connect('mongodb://mongo:27017/mydatabase')
  .then(() => console.log('DB is connected'))
  .catch(err => console.error(err));

app.get('/', (req, res) => {
  res.send('¡Hola, mundo!');
});

// Iniciar el servidor
app.listen(PORT, () => {
  console.log(\`Servidor corriendo en http://localhost:\${PORT}\`);
});
EOL

    # Crear src/database.js
    cat <<EOL > src/database.js
const mongoose = require("mongoose");

mongoose
  .connect("mongodb://mongo/mydatabase", {
    useNewUrlParser: true,
    useUnifiedTopology: true,
  })
  .then(() => console.log("DB is connected"))
  .catch((err) => console.error(err));

module.exports = mongoose;
EOL

    # Crear .dockerignore
    echo -e "node_modules\nnpm-debug.log" > .dockerignore

    echo "Archivos creados exitosamente."
}

# Función para inicializar el proyecto y instalar dependencias
initialize_and_install() {
    echo "Inicializando el proyecto y instalando dependencias..."
    npm init -y
    npm install
}

# Función para mostrar el menú
show_menu() {
    echo "Seleccione una opción:"
    echo "1) Iniciar Docker Compose"
    echo "2) Detener Docker Compose"
    echo "3) Salir"
    read -p "Ingrese su opción: " option

    case $option in
        1)
            echo "Iniciando Docker Compose..."
            docker-compose up --build
            ;;
        2)
            echo "Deteniendo Docker Compose..."
            docker-compose down
            ;;
        3)
            echo "Saliendo..."
            exit 0
            ;;
        *)
            echo "Opción no válida. Intente nuevamente."
            show_menu
            ;;
    esac
}

# Menú principal
echo "Configurando el proyecto..."
create_files
initialize_and_install
show_menu

# Descripción del Script setup.sh
# El script setup.sh está diseñado para configurar un proyecto de aplicación Node.js con una base de datos MongoDB utilizando Docker y Docker Compose. Este script automatiza la creación de la estructura de archivos necesaria, inicializa el proyecto y proporciona un menú para iniciar y detener los contenedores de Docker. A continuación se detallan las funciones y su propósito:

# 1. Creación de Archivos y Estructura de Directorios
# Función create_files:
# Crea la estructura de directorios y archivos necesarios para el proyecto.
# Genera los siguientes archivos:
# package.json: Contiene la configuración del proyecto y las dependencias necesarias (express y mongoose).
# Dockerfile: Define cómo construir la imagen de Docker para la aplicación Node.js.
# docker-compose.yml: Define los servicios que se ejecutarán en contenedores de Docker, incluyendo la aplicación y la base de datos MongoDB.
# src/index.js: Archivo principal de la aplicación que configura el servidor Express y se conecta a la base de datos MongoDB.
# src/database.js: Archivo que maneja la conexión a la base de datos MongoDB.
# .dockerignore: Archivo que especifica qué archivos y carpetas deben ser ignorados por Docker al construir la imagen.

# 2. Inicialización del Proyecto y Instalación de Dependencias
# Función initialize_and_install:
# Ejecuta el comando npm init -y para inicializar un nuevo proyecto Node.js, creando un archivo package.json básico.
# Instala las dependencias necesarias (express y mongoose) usando npm install.

# 3. Menú Interactivo
# Función show_menu:
# Presenta un menú al usuario con tres opciones:
# Iniciar Docker Compose: Inicia los contenedores de Docker definidos en docker-compose.yml y construye la imagen si es necesario.
# Detener Docker Compose: Detiene y elimina los contenedores en ejecución.
# Salir: Sale del script.
# Dependiendo de la opción seleccionada por el usuario, se ejecuta el comando correspondiente.

# 4. Ejecución del Script
# Al final del script, se ejecutan las funciones en orden:
# Se crea la estructura de archivos y directorios.
# Se inicializa el proyecto y se instalan las dependencias.
# Se muestra el menú interactivo al usuario.
# Cómo Usar el Script
# Guardar el script: Copia el código del script en un archivo llamado setup.sh.
# Dar permisos de ejecución: Ejecuta el comando chmod +x setup.sh para hacer que el script sea ejecutable.
# Ejecutar el script: Usa ./setup.sh en la terminal para ejecutar el script. Sigue las instrucciones en el menú para iniciar o detener Docker Compose.
# Este script simplifica el proceso de configuración y administración de una aplicación Node.js con MongoDB, permitiendo a los desarrolladores centrarse en el desarrollo sin tener que preocuparse por los detalles de la configuración inicial. 