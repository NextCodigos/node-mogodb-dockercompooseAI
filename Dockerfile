# Imagen base de Node.js (versión actualizada)
FROM node:18

# Crear directorio de trabajo en contenedor
WORKDIR /usr/src/app

# Copiar `package.json` y `package-lock.json` (si existe)
COPY package*.json ./

# Instalar dependencias
RUN npm install

# Copiar el resto de la aplicación al directorio de trabajo
COPY . .

# Exponer el puerto 3000
EXPOSE 3000

# Comando para iniciar la aplicación
CMD ["npm", "start"]
