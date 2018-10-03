<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the
 * installation. You don't have to use the web site, you can
 * copy this file to "wp-config.php" and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * MySQL settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://codex.wordpress.org/Editing_wp-config.php
 *
 * @package WordPress
 */

// ** MySQL settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define('DB_NAME', 'bitnami_wordpress');

/** MySQL database username */
define('DB_USER', 'bn_wordpress');

/** MySQL database password */
define('DB_PASSWORD', '1234567');

/** MySQL hostname */
define('DB_HOST', 'myblog-mariadb-master:3306');

/** Database Charset to use in creating database tables. */
define('DB_CHARSET', 'utf8');

/** The Database Collate type. Don't change this if in doubt. */
define('DB_COLLATE', '');

/**#@+
 * Authentication Unique Keys and Salts.
 *
 * Change these to different unique phrases!
 * You can generate these using the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}
 * You can change these at any point in time to invalidate all existing cookies. This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define('AUTH_KEY',         'SDrqnp6PTRZE6CK9y989KTZWi7TC8hg8');
define('SECURE_AUTH_KEY',  'XliNPHENXmI6jG4LOyC2rfCIZJ9AVi5j');
define('LOGGED_IN_KEY',    'udPNTWPf5XwB1c1BR7u2sUf7i0sMbub7');
define('NONCE_KEY',        '4We4ftGkdw4N9FJ40BT2muVftTBQyVjG');
define('AUTH_SALT',        'g4Q6EFVEnFACF2FYlwthtGZBoHQSFeiU');
define('SECURE_AUTH_SALT', 'l6akLFH5n3HbZxISMxIFFNzIXVFtMPHB');
define('LOGGED_IN_SALT',   'YWRdABAhK7PWQjnducHbaCNZZAewqm42');
define('NONCE_SALT',       'fRh683NB5f0Toyex5rb4ZrwMFNdp3C9F');

/**#@-*/

/**
 * WordPress Database Table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
$table_prefix = 'wp_';

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the Codex.
 *
 * @link https://codex.wordpress.org/Debugging_in_WordPress
 */
define('WP_DEBUG', false);

define('WP_PLUGIN_DIR', '/bitnami/wordpress' . '/wp-content/plugins');
/* That's all, stop editing! Happy blogging. */


define('WP_SITEURL', 'http://' . $_SERVER['HTTP_HOST'] . '/');
define('WP_HOME', 'http://' . $_SERVER['HTTP_HOST'] . '/');
/** Absolute path to the WordPress directory. */

if ( !defined('ABSPATH') )
	define('ABSPATH', '/opt/bitnami/wordpress' . '/');

/** Sets up WordPress vars and included files. */
require_once(ABSPATH . 'wp-settings.php');

define('FS_METHOD', 'direct');

define('WP_TEMP_DIR', '/opt/bitnami/wordpress/tmp/');

//  Disable pingback.ping xmlrpc method to prevent WordPress from participating in DDoS attacks
//  More info at: https://wiki.bitnami.com/Applications/Bitnami_WordPress#XMLRPC_and_Pingback

// remove x-pingback HTTP header
add_filter("wp_headers", function($headers) {
            unset($headers["X-Pingback"]);
            return $headers;
           });
// disable pingbacks
add_filter( "xmlrpc_methods", function( $methods ) {
             unset( $methods["pingback.ping"] );
             return $methods;
           });

#TODO: The value should be set from the env var.
define('DB_SLAVE_1', 'myblog-mariadb-slave');
