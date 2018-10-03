<?php
$wpdb->save_queries = false;
$wpdb->persistent = false;
$wpdb->max_connections = 10;
$wpdb->check_tcp_responsiveness = true;
$wpdb->add_database(array(
  'host'     => DB_HOST,
  'user'     => DB_USER,
  'password' => DB_PASSWORD,
  'name'     => DB_NAME,
));
$wpdb->add_database(array(
  'host'     => DB_SLAVE_HOST,
  'user'     => DB_USER,
  'password' => DB_PASSWORD,
  'name'     => DB_NAME,
  'write'    => 0,
  'read'     => 1,
  'dataset'  => 'global',
  'timeout'  => 0.2,
));
