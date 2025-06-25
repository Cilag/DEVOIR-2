# Utilise l'image officielle WordPress comme base (inclut PHP, Apache, WordPress)
FROM wordpress:latest

# Ajout d'un thème personnalisé dans le répertoire approprié
COPY ./custom-theme /var/www/html/wp-content/themes/custom-theme

# Ajout d'un script d'initialisation pour effectuer des actions au démarrage du conteneur
# COPY entrypoint.sh /usr/local/bin/
# RUN chmod +x /usr/local/bin/entrypoint.sh
# ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# Assure que le serveur web (Apache) a les droits d'accès corrects sur le thème
RUN chown -R www-data:www-data /var/www/html/wp-content/themes/custom-theme
