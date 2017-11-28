<?php
exec('./initialize_database');

require __DIR__.'/vendor/autoload.php';

ActiveRecord\Config::initialize(function($cfg)
{
   $cfg->set_model_directory(__DIR__.'/models');
   $cfg->set_connections(['development' => 'sqlite://test.db']);
});
