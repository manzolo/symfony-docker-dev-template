#!/bin/sh
set -e

echo "--- Running Symfony PHP-FPM Entrypoint ---"

# Run Symfony migrations
# Symfony uses Doctrine Migrations.
echo "Running database migrations..."
php bin/console doctrine:migrations:migrate --no-interaction --allow-no-migration


# Clear and cache configurations
# Symfony uses its own cache clear and warm-up commands.
echo "Optimizing Symfony caches (config, routes, views)..."
# Clear all caches
php bin/console cache:clear --no-warmup

# Warm up the cache for the production environment. This step is crucial for performance.
echo "Warming up Symfony cache for production..."
php bin/console cache:warmup

# Optionally, if you have specific cache warmers that need to be run:
# php bin/console <your-custom-cache-warmer>

# Publishing vendor assets (if applicable)
# Symfony usually handles public assets through Webpack Encore or directly via "public/" directory.
# If you have assets from bundles that need to be symlinked or copied to the public directory,
# you would use the 'assets:install' command.
echo "Publishing vendor assets..."
php bin/console assets:install --symlink --relative public

# Run any custom post-deploy scripts (optional).
# You can add other commands here if needed, e.g., to create symlinks.
# echo "Running custom post-deploy scripts..."
# php bin/console <your-custom-command>

# Run the default command (typically php-fpm)
exec "$@"