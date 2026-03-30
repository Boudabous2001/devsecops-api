# Utiliser une image Node.js légère et récente
FROM node:20-alpine

# Créer un utilisateur non-root pour la sécurité
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Définir le répertoire de travail
WORKDIR /app

# Copier les fichiers de dépendances
COPY package*.json ./

# Installer les dépendances (production uniquement)
RUN npm install --omit=dev

# Copier le code source
COPY src/ ./src/

# Changer le propriétaire des fichiers
RUN chown -R appuser:appgroup /app

# Basculer sur l'utilisateur non-root
USER appuser

# Exposer le port de l'application
EXPOSE 3000

# Commande de démarrage
CMD ["node", "src/app.js"]